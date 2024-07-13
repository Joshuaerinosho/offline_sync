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
  final offlineSync = OfflineSync();
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

