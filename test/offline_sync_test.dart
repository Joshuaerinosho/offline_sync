import 'package:offline_sync/offline_sync.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // For FFI database in tests

import 'offline_sync_test.mocks.dart' as mock;

@GenerateMocks([Database, http.Client, Connectivity, SharedPreferences])
void main() {
  // Initialize FFI for unit tests so sqflite works in Dart VM
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  TestWidgetsFlutterBinding.ensureInitialized();

  late OfflineSync offlineSync;
  late mock.MockClient mockHttpClient;
  late mock.MockConnectivity mockConnectivity;
  late mock.MockSharedPreferences mockSharedPreferences;
  late List<String> loggerMessages;

  setUp(() async {
    mockHttpClient = mock.MockClient();
    mockConnectivity = mock.MockConnectivity();
    mockSharedPreferences = mock.MockSharedPreferences();
    loggerMessages = [];

    // Stub connectivity stream to avoid MissingStubError
    when(mockConnectivity.onConnectivityChanged)
        .thenAnswer((_) => Stream.value([ConnectivityResult.wifi]));

    // Set up SharedPreferences mock for encryption key
    when(mockSharedPreferences.getString(any)).thenReturn(null);
    when(mockSharedPreferences.setString(any, any))
        .thenAnswer((_) async => true);
    SharedPreferences.setMockInitialValues({});

    // Always stub HTTP GET/POST to return a valid response by default
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('[]', 200));
    when(mockHttpClient.post(any,
            body: anyNamed('body'), headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('{"results":[]}', 200));

    // Use a unique in-memory database for each test (sqflite_ffi supports this)
    // This is handled by default with sqflite_ffi if you use ':memory:' as the path
    // But since OfflineSync uses getDatabasesPath, you may want to clear the DB file if needed
    // For now, rely on sqflite_ffi's isolation per test run

    offlineSync = OfflineSync(
      config: OfflineSyncConfig(
        apiEndpoint: 'https://example.com/api',
        logger: (msg) => loggerMessages.add(msg),
        batchSize: 2,
      ),
      httpClient: mockHttpClient,
      connectivity: mockConnectivity,
      dbPath: ':memory:', // Use in-memory DB for tests
    );
    await offlineSync.initialize();
  });

  test('Save and read local data', () async {
    final data = {
      'name': 'John Doe',
      'email': 'john@example.com',
      'age': 30,
    };
    await offlineSync.saveLocalData('user_1', data);
    final userData = await offlineSync.readLocalData('user_1');
    expect(userData, equals(data));
  });

  test('Automatic encryption key generation and persistence', () async {
    // Should generate and persist a key if not provided
    final key = offlineSync.config.encryptionKey;
    expect(key, isNull); // Not provided
    // The key should be generated and stored in SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final storedKey = prefs.getString('offline_sync_encryption_key');
    expect(storedKey, isNotNull);
    expect(storedKey!.length, 32);
  });
}
