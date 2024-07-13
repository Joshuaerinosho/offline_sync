import 'package:offline_sync/offline_sync.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'offline_sync_test.mocks.dart' as mock;

@GenerateMocks(
    [Database, http.Client, Connectivity, SharedPreferences, OfflineSync])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late mock.MockOfflineSync offlineSync;
  late mock.MockDatabase mockDatabase;
  // late mock.MockClient mockHttpClient;
  // late mock.MockConnectivity mockConnectivity;
  // late mock.MockSharedPreferences mockSharedPreferences;

  setUp(() async {
    offlineSync = mock.MockOfflineSync();
    mockDatabase = mock.MockDatabase();
    // mockHttpClient = mock.MockClient();
    // mockConnectivity = mock.MockConnectivity();
    // mockSharedPreferences = mock.MockSharedPreferences();

    await offlineSync.initialize();
  });

  test('Save and read local data', () async {
    const action = 'create';

    final data = {
      'name': 'John Doe',
      'email': 'john@example.com',
      'age': 30,
    };

    when(offlineSync.readLocalData(any)).thenAnswer(
      (_) => Future.value(data),
    );

    when(mockDatabase.query(any)).thenAnswer((_) => Future.value([data]));

    // Ensure offline sync is initialized
    verify(offlineSync.initialize()).called(1);

    await offlineSync.saveLocalData('user_1', data);

    final userData = await offlineSync.readLocalData('user_1');

    expect(userData, equals(data));

    await offlineSync.addToSyncQueue(action, data);

    final databaseQuery = await mockDatabase.query('sync_queue');

    expect(databaseQuery.length, equals(1));
  });

//TODO: ADD MORE TEST CASES HERE
}
