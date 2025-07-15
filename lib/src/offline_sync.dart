import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class OfflineSyncConfig {
  final String apiEndpoint;
  final int batchSize;
  final String? encryptionKey; // Now optional
  final encrypt.IV? encryptionIV;
  final Future<Map<String, dynamic>> Function(
      String id,
      Map<String, dynamic> localData,
      Map<String, dynamic> serverData)? conflictResolver;
  final void Function(String message)? logger;

  const OfflineSyncConfig({
    required this.apiEndpoint,
    this.batchSize = 50,
    this.encryptionKey,
    this.encryptionIV,
    this.conflictResolver,
    this.logger,
  });
}

enum SyncStatus { idle, syncing, success, error, offline }

enum SyncErrorType { network, auth, server, unknown }

class OfflineSyncException implements Exception {
  final SyncErrorType type;
  final String message;
  OfflineSyncException(this.type, this.message);
  @override
  String toString() => 'OfflineSyncException($type): $message';
}

class OfflineSync {
  late final Database _database;
  late final SharedPreferences _sharedPreferences;
  final Connectivity _connectivity;
  final http.Client _httpClient;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  late final encrypt.Encrypter _encrypter;
  late final encrypt.IV _iv;
  String? _authToken;
  final OfflineSyncConfig config;
  final ValueNotifier<SyncStatus> syncStatus = ValueNotifier(SyncStatus.idle);
  final ValueNotifier<SyncErrorType?> lastError = ValueNotifier(null);
  final ValueNotifier<double> syncProgress = ValueNotifier(0.0); // 0.0 to 1.0
  final String? dbPath; // Optional custom database path for testing

  static const int _currentSchemaVersion = 2;
  static const _encryptionKeyPrefsKey = 'offline_sync_encryption_key';

  OfflineSync({
    required this.config,
    this.dbPath, // Allow custom DB path
    Connectivity? connectivity,
    http.Client? httpClient,
  })  : _connectivity = connectivity ?? Connectivity(),
        _httpClient = httpClient ?? http.Client();

  Future<void> initialize() async {
    final dbPathToUse =
        dbPath ?? join(await getDatabasesPath(), 'offline_sync.db');
    _database = await openDatabase(
      dbPathToUse,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE sync_queue(id INTEGER PRIMARY KEY, action TEXT, data TEXT, synced INTEGER, retry_count INTEGER, created_at INTEGER)',
        );
        await db.execute(
          'CREATE TABLE schema_version(version INTEGER PRIMARY KEY)',
        );
        await db.execute(
          'CREATE TABLE local_data(id TEXT PRIMARY KEY, data TEXT, last_updated INTEGER)',
        );
        await db.insert('schema_version', {'version': _currentSchemaVersion});
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            'CREATE TABLE local_data(id TEXT PRIMARY KEY, data TEXT, last_updated INTEGER)',
          );
        }
      },
      version: _currentSchemaVersion,
    );

    _sharedPreferences = await SharedPreferences.getInstance();

    // Handle encryption key
    String? key = config.encryptionKey;
    if (key == null) {
      key = _sharedPreferences.getString(_encryptionKeyPrefsKey);
      if (key == null) {
        key = _generateRandomKey(32);
        await _sharedPreferences.setString(_encryptionKeyPrefsKey, key);
      }
    }
    _encrypter = encrypt.Encrypter(
        encrypt.AES(encrypt.Key.fromUtf8(key.padRight(32).substring(0, 32))));
    _iv = config.encryptionIV ?? encrypt.IV.fromLength(16);

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_handleConnectivityChange);
  }

  /// Generates a secure random string of [length] characters for encryption key.
  String _generateRandomKey(int length) {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random.secure();
    return List.generate(length, (_) => chars[rand.nextInt(chars.length)])
        .join();
  }

  // Getter for the current API endpoint
  String get apiEndpoint => config.apiEndpoint;

  Future<void> setAuthToken(String token) async {
    _authToken = token;
    await _sharedPreferences.setString(
        'auth_token', _encrypter.encrypt(token, iv: _iv).base64);
  }

  /// Deprecated: setApiEndpoint is now a no-op. Set apiEndpoint via OfflineSyncConfig instead.
  @Deprecated('Set apiEndpoint via OfflineSyncConfig instead.')
  void setApiEndpoint(String endpoint) {
    // No-op. Use OfflineSyncConfig.
  }

  Future<void> loadAuthToken() async {
    final encryptedToken = _sharedPreferences.getString('auth_token');
    if (encryptedToken != null) {
      _authToken = _encrypter.decrypt64(encryptedToken, iv: _iv);
    }
  }

  Future<void> addToSyncQueue(String action, Map<String, dynamic> data) async {
    final encryptedData = _encrypter.encrypt(json.encode(data), iv: _iv).base64;
    await _database.insert('sync_queue', {
      'action': action,
      'data': encryptedData,
      'synced': 0,
      'retry_count': 0,
      'created_at': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<void> _handleConnectivityChange(
      List<ConnectivityResult> connectivityResult) async {
    if (connectivityResult.any(
      (result) => {
        ConnectivityResult.mobile,
        ConnectivityResult.wifi,
        ConnectivityResult.ethernet,
        ConnectivityResult.vpn
      }.contains(result),
    )) {
      await syncData();
    }
  }

  @visibleForTesting
  Future<void> syncData() async {
    syncStatus.value = SyncStatus.syncing;
    lastError.value = null;
    final unsynced = await _database.query(
      'sync_queue',
      where: 'synced = ? AND retry_count < ?',
      whereArgs: [0, config.batchSize],
      orderBy: 'created_at ASC',
      limit: config.batchSize,
    );
    int total = unsynced.length;
    int processed = 0;
    for (int i = 0; i < unsynced.length; i += config.batchSize) {
      final batch = unsynced.skip(i).take(config.batchSize).toList();
      await _syncBatch(batch);
      processed += batch.length;
      syncProgress.value = total == 0 ? 1.0 : processed / total;
    }
    syncStatus.value = SyncStatus.success;
    syncProgress.value = 1.0;
  }

  Future<void> _syncBatch(List<Map<String, dynamic>> batch) async {
    final List<Map<String, dynamic>> batchData = [];
    for (final item in batch) {
      try {
        final decryptedData =
            _encrypter.decrypt64(item['data'] as String, iv: _iv);
        batchData.add({
          'id': item['id'],
          'action': item['action'],
          'data': json.decode(decryptedData),
        });
      } catch (e) {
        // Wrap decryption errors
        throw OfflineSyncException(
            SyncErrorType.unknown, 'Decryption failed: $e');
      }
    }

    try {
      final response = await _sendToServer('batch_sync', {'batch': batchData});
      final serverResponse = json.decode(response.body);

      for (final result in serverResponse['results']) {
        if (result['success']) {
          await _database.update(
            'sync_queue',
            {'synced': 1},
            where: 'id = ?',
            whereArgs: [result['id']],
          );
        } else {
          await _handleSyncError(result['id'], result['error']);
        }
      }
    } catch (e) {
      for (final item in batch) {
        await _handleSyncError(item['id'], 'Network error');
      }
    }
  }

  Future<void> _handleSyncError(int id, String error) async {
    await _database.update(
      'sync_queue',
      {
        'retry_count': 2, //TODO: should update
        'synced': 0,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
    lastError.value = SyncErrorType.unknown;
    syncStatus.value = SyncStatus.error;
    config.logger?.call('Sync failed for item $id: $error');
    // Optionally throw a custom exception
    // throw OfflineSyncException(SyncErrorType.unknown, 'Sync failed for item $id: $error');
  }

  Future<http.Response> _sendToServer(
      String action, Map<String, dynamic> data) async {
    if (apiEndpoint.isEmpty) {
      lastError.value = SyncErrorType.server;
      syncStatus.value = SyncStatus.error;
      config.logger?.call('API endpoint not set');
      throw OfflineSyncException(SyncErrorType.server, 'API endpoint not set');
    }
    final response = await _httpClient.post(
      Uri.parse(apiEndpoint),
      body: json.encode(data),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_authToken',
      },
    );
    if (response.statusCode == 401) {
      lastError.value = SyncErrorType.auth;
      syncStatus.value = SyncStatus.error;
      config.logger?.call('Authentication failed');
      throw OfflineSyncException(SyncErrorType.auth, 'Authentication failed');
    }
    return response;
  }

  Future<void> saveLocalData(String id, Map<String, dynamic> data) async {
    final encryptedData = _encrypter.encrypt(json.encode(data), iv: _iv).base64;
    await _database.insert(
      'local_data',
      {
        'id': id,
        'data': encryptedData,
        'last_updated': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Add to sync queue
    await addToSyncQueue('update_data', {'id': id, 'data': data});
  }

  Future<Map<String, dynamic>?> readLocalData(String id) async {
    final result = await _database.query(
      'local_data',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      try {
        final encryptedData = result.first['data'] as String;
        final decryptedData = _encrypter.decrypt64(encryptedData, iv: _iv);
        return json.decode(decryptedData);
      } catch (e) {
        // Wrap decryption errors
        throw OfflineSyncException(
            SyncErrorType.unknown, 'Decryption failed: $e');
      }
    }

    return null;
  }

  Future<void> updateFromServer() async {
    if (apiEndpoint.isEmpty) {
      lastError.value = SyncErrorType.server;
      syncStatus.value = SyncStatus.error;
      config.logger?.call('API endpoint not set');
      throw OfflineSyncException(SyncErrorType.server, 'API endpoint not set');
    }
    final response = await _httpClient.get(
      Uri.parse(apiEndpoint),
      headers: {
        'Authorization': 'Bearer $_authToken',
      },
    );
    if (response.statusCode == 200) {
      final updates = json.decode(response.body);
      await _applyServerUpdates(updates);
      syncStatus.value = SyncStatus.success;
    } else if (response.statusCode == 401) {
      lastError.value = SyncErrorType.auth;
      syncStatus.value = SyncStatus.error;
      config.logger?.call('Authentication failed');
      throw OfflineSyncException(SyncErrorType.auth, 'Authentication failed');
    } else {
      lastError.value = SyncErrorType.server;
      syncStatus.value = SyncStatus.error;
      config.logger?.call('Failed to fetch updates from server');
      throw OfflineSyncException(
          SyncErrorType.server, 'Failed to fetch updates from server');
    }
  }

  Future<void> _applyServerUpdates(dynamic updates) async {
    // If updates is a List (e.g., from JSONPlaceholder), treat each as a record
    if (updates is List) {
      for (final item in updates) {
        if (item is Map<String, dynamic> && item['id'] != null) {
          final id = item['id'].toString();
          await saveLocalData(id, item);
        }
      }
      return;
    }
    // Otherwise, use the original logic for Map-based updates
    if (updates is List<Map<String, dynamic>>) {
      for (final update in updates) {
        final id = update['id'];
        final serverData = update['data'];
        final serverTimestamp = update['timestamp'];

        final localData = await readLocalData(id);

        if (localData == null ||
            serverTimestamp > (localData['last_updated'] as int)) {
          await saveLocalData(id, serverData);
        } else {
          // Local data is newer, resolve conflict
          final resolvedData =
              await _resolveConflict(id, localData, serverData);
          await saveLocalData(id, resolvedData);
        }
      }
    }
  }

  Future<Map<String, dynamic>> _resolveConflict(String id,
      Map<String, dynamic> localData, Map<String, dynamic> serverData) async {
    // Use custom conflict resolver if provided
    if (config.conflictResolver != null) {
      return await config.conflictResolver!(id, localData, serverData);
    }
    // Default: merges data, preferring local changes
    final resolvedData = Map<String, dynamic>.from(serverData);
    localData.forEach((key, value) {
      if (value != serverData[key]) {
        resolvedData[key] = value;
      }
    });
    return resolvedData;
  }

  Future<List<Map<String, dynamic>>> readAllLocalData() async {
    final results = await _database.query('local_data');
    return results.map((row) {
      final encryptedData = row['data'] as String;
      final decryptedData = _encrypter.decrypt64(encryptedData, iv: _iv);
      return {
        'id': row['id'],
        'data': json.decode(decryptedData),
        'last_updated': row['last_updated'],
      };
    }).toList();
  }

  Future<void> dispose() async {
    await _connectivitySubscription?.cancel();
    await _database.close();
  }

  @visibleForTesting
  String encryptData(Map<String, dynamic> data) {
    return _encrypter.encrypt(json.encode(data), iv: _iv).base64;
  }
}
