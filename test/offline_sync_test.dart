import 'package:offline_sync/offline_sync.dart';
// import 'package:test/test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'offline_sync_test.mocks.dart' as mock;

@GenerateMocks([Database, http.Client, Connectivity, SharedPreferences])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late OfflineSync offlineSync;
  late mock.MockDatabase mockDatabase;
  late mock.MockClient mockHttpClient;
  late mock.MockConnectivity mockConnectivity;
  late mock.MockSharedPreferences mockSharedPreferences;

  setUp(() async {
    mockDatabase = mock.MockDatabase();
    mockHttpClient = mock.MockClient();
    mockConnectivity = mock.MockConnectivity();
    mockSharedPreferences = mock.MockSharedPreferences();

    // Initialize OfflineSync with mocks
    offlineSync = OfflineSync.withDependencies(
      database: mockDatabase,
      httpClient: mockHttpClient,
      connectivity: mockConnectivity,
      sharedPreferences: mockSharedPreferences,
    );

    // Mock SharedPreferences
    when(mockSharedPreferences.getString(any)).thenReturn(null);

    // Initialize OfflineSync
    await offlineSync.initialize();
  });

  group('OfflineSync', () {
    test('initialize creates necessary tables', () async {
      verify(mockDatabase.execute(argThat(contains('CREATE TABLE sync_queue'))))
          .called(1);
      verify(mockDatabase
              .execute(argThat(contains('CREATE TABLE schema_version'))))
          .called(1);
      verify(mockDatabase.execute(argThat(contains('CREATE TABLE local_data'))))
          .called(1);
    });

    test('setAuthToken encrypts and saves token', () async {
      const token = 'test_token';
      await offlineSync.setAuthToken(token);
      verify(mockSharedPreferences.setString(any, any)).called(1);
    });

    test('loadAuthToken decrypts and loads token', () async {
      const encryptedToken = 'encrypted_test_token';
      when(mockSharedPreferences.getString(any)).thenReturn(encryptedToken);
      await offlineSync.loadAuthToken();
      // Verify that the token was decrypted and loaded correctly
      // This might require exposing the token for testing purposes
    });

    test('addToSyncQueue adds item to queue', () async {
      const action = 'create';
      final data = {'name': 'John Doe'};
      await offlineSync.addToSyncQueue(action, data);
      verify(mockDatabase.insert('sync_queue', any)).called(1);
    });

    test('saveLocalData encrypts and saves data', () async {
      const id = 'user_1';
      final data = {'name': 'John Doe'};
      await offlineSync.saveLocalData(id, data);
      verify(mockDatabase.insert('local_data', any,
              conflictAlgorithm: ConflictAlgorithm.replace))
          .called(1);
      verify(mockDatabase.insert('sync_queue', any)).called(1);
    });

    test('readLocalData decrypts and returns data', () async {
      const id = 'user_1';
      final encryptedData = offlineSync.encryptData({'name': 'John Doe'});
      when(mockDatabase.query('local_data',
              where: anyNamed('where'), whereArgs: anyNamed('whereArgs')))
          .thenAnswer((_) async => [
                {'id': id, 'data': encryptedData}
              ]);

      final result = await offlineSync.readLocalData(id);
      expect(result, {'name': 'John Doe'});
    });

    test('updateFromServer fetches and applies updates', () async {
      final updates = [
        {
          'id': 'user_1',
          'data': {'name': 'John Doe'},
          'timestamp': DateTime.now().millisecondsSinceEpoch
        }
      ];
      when(mockHttpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(json.encode(updates), 200));

      await offlineSync.updateFromServer();
      verify(mockDatabase.insert('local_data', any,
              conflictAlgorithm: ConflictAlgorithm.replace))
          .called(1);
    });

    test('_syncData processes unsynced items', () async {
      final unsynced = [
        {
          'id': 1,
          'action': 'create',
          'data': offlineSync.encryptData({'name': 'John Doe'}),
          'retry_count': 0
        }
      ];
      when(mockDatabase.query('sync_queue',
              where: anyNamed('where'),
              whereArgs: anyNamed('whereArgs'),
              orderBy: anyNamed('orderBy'),
              limit: anyNamed('limit')))
          .thenAnswer((_) async => unsynced);
      when(mockHttpClient.post(any,
              body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(
              json.encode({
                'results': [
                  {'id': 1, 'success': true}
                ]
              }),
              200));

      await offlineSync.syncData();
      verify(mockDatabase.update('sync_queue', {'synced': 1},
              where: anyNamed('where'), whereArgs: anyNamed('whereArgs')))
          .called(1);
    });

    test('_handleConnectivityChange triggers sync on connection', () async {
      when(mockConnectivity.onConnectivityChanged)
          .thenAnswer((_) => Stream.value([ConnectivityResult.wifi]));
      offlineSync = OfflineSync.withDependencies(
        database: mockDatabase,
        httpClient: mockHttpClient,
        connectivity: mockConnectivity,
        sharedPreferences: mockSharedPreferences,
      );
      await offlineSync.initialize();

      // Wait for the stream to emit a value and trigger sync
      await Future.delayed(Duration(milliseconds: 100));

      // Verify that syncData was called
      // This might require exposing syncData or adding a callback for testing
    });
  });
}
