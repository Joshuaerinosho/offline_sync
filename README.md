# OfflineSync

OfflineSync is a Flutter package that provides offline-first data management and synchronization. It ensures smooth functionality even without an internet connection and syncs data once connectivity is restored.

## Features

- Local data storage and retrieval
- Automatic synchronization with server when online
- Conflict resolution
- Encryption of sensitive data
- Batch syncing for improved performance
- Error handling and retry mechanisms

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  offline_sync: ^0.0.1
```

## Usage

## Initialization

First, initialize the OfflineSync instance in your app:

```dart
import 'package:offline_sync/offline_sync.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final offlineSync = OfflineSync(
    config: OfflineSyncConfig(
      apiEndpoint: 'https://your-custom-api.com',
      // encryptionKey is optional and will be generated automatically if not provided
    ),
  );
  await offlineSync.initialize();
  runApp(MyApp());
}
```

## Setting Custom API Endpoint

Set a custom endpoint for your specific server:

```dart
final offlineSync = OfflineSync();
offlineSync.setApiEndpoint('https://your-custom-api.com');
```

## Saving Data

To save data locally and queue it for syncing:

```dart
final offlineSync = OfflineSync();
await offlineSync.saveLocalData('user_1', {
  'name': 'John Doe',
  'email': 'john@example.com',
  'age': 30,
});
```

## Reading Data

To read locally stored data:

```dart
final userData = await offlineSync.readLocalData('user_1');
if (userData != null) {
  print('User name: ${userData['name']}');
} else {
  print('User not found');
}
```

## Syncing with Server

The package automatically syncs data when an internet connection is available. However, you can manually trigger a sync:

```dart
try {
  await offlineSync.updateFromServer();
  print('Data updated from server successfully');
} catch (e) {
  print('Failed to update from server: $e');
}
```

## Handling Authentication

Set the authentication token for API requests:

```dart
await offlineSync.setAuthToken('your_auth_token_here');
```

# Advanced Usage:

## Conflict Resolution

The package includes basic conflict resolution. You can customize this by extending the OfflineSync class:

```dart
class CustomOfflineSync extends OfflineSync {
  @override
  Future<Map<String, dynamic>> resolveConflict(
    String id,
    Map<String, dynamic> localData,
    Map<String, dynamic> serverData
  ) async {
    // Implement your custom conflict resolution strategy here
    // This example prefers local changes
    final resolvedData = Map<String, dynamic>.from(serverData);
    localData.forEach((key, value) {
      if (value != serverData[key]) {
        resolvedData[key] = value;
      }
    });
    return resolvedData;
  }
}
```

## Batch Processing

The package processes sync queue in batches. You can adjust the batch size:

```dart
class CustomOfflineSync extends OfflineSync {
  @override
  int get batchSize => 100; // Default is 50
}
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Using with Flutter Provider

Wrap your app with the `OfflineSyncProvider` to make the sync instance and its status available throughout the widget tree:

```dart
final offlineSync = OfflineSync(config: OfflineSyncConfig(
  apiEndpoint: 'https://your-api.com',
  // encryptionKey is now optional
));
await offlineSync.initialize();

runApp(
  OfflineSyncProvider(
    offlineSync: offlineSync,
    child: MyApp(),
  ),
);
```

Then, anywhere in your widget tree, you can access the sync instance and status:

```dart
final offlineSync = OfflineSyncProvider.of(context);
ValueListenableBuilder<SyncStatus>(
  valueListenable: offlineSync.syncStatus,
  builder: (context, status, _) {
    // Show sync status in UI
    return Text('Sync status: $status');
  },
)
```

## API Reference

### OfflineSyncConfig

- `apiEndpoint` (String, required): The server endpoint for syncing.
- `batchSize` (int, default: 50): Number of items to sync per batch.
- `encryptionKey` (String, optional): 32-character key for AES encryption. If not provided, a secure key is generated and stored automatically.
- `encryptionIV` (IV, optional): Custom IV for encryption.
- `conflictResolver` (callback, optional): Custom function for resolving data conflicts.
- `logger` (callback, optional): Function for debug or error logging.

### OfflineSync

- `OfflineSync({required OfflineSyncConfig config, ...})`: Create a new instance with config and optional injected dependencies.
- `Future<void> initialize()`: Initialize the database and connectivity.
- `Future<void> setAuthToken(String token)`: Set the auth token for API requests.
- `Future<void> saveLocalData(String id, Map<String, dynamic> data)`: Save data locally and queue for sync.
- `Future<Map<String, dynamic>?> readLocalData(String id)`: Read local data by ID.
- `Future<void> updateFromServer()`: Manually trigger sync from server.
- `ValueNotifier<SyncStatus> syncStatus`: Listen for sync status changes.
- `ValueNotifier<SyncErrorType?> lastError`: Listen for error changes.
- `ValueNotifier<double> syncProgress`: Listen for sync progress (0.0 to 1.0).

## Migration Guide

### From Singleton to Instance API

- **Before:**
  ```dart
  final offlineSync = OfflineSync();
  await offlineSync.initialize();
  offlineSync.setApiEndpoint('https://api.com');
  ```
- **After:**
  ```dart
  final offlineSync = OfflineSync(
    config: OfflineSyncConfig(
      apiEndpoint: 'https://api.com',
      // encryptionKey is now optional
    ),
  );
  await offlineSync.initialize();
  ```
- Use the new `OfflineSyncProvider` to expose the instance to your widget tree.
- Set all configuration options via `OfflineSyncConfig` instead of setters.
