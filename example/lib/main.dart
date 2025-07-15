import 'package:flutter/material.dart';
import 'package:offline_sync/offline_sync.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Create the OfflineSync instance with only the API endpoint.
  // The encryption key will be generated and stored automatically.
  final offlineSync = OfflineSync(
    config: OfflineSyncConfig(
      apiEndpoint: 'https://jsonplaceholder.typicode.com/posts',
      // encryptionKey is now optional!
      logger: (msg) => debugPrint('[OfflineSync] $msg'),
    ),
  );

  await offlineSync.initialize();

  // Wrap your app with OfflineSyncProvider to access it anywhere in the widget tree.
  runApp(OfflineSyncProvider(
    offlineSync: offlineSync,
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'OfflineSync Simple Example',
      home: PostScreen(),
    );
  }
}

/// A simple screen to create, sync, and view posts using OfflineSync.
class PostScreen extends StatefulWidget {
  const PostScreen({super.key});
  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  List<Map<String, dynamic>> _serverPosts = [];
  bool _loading = false;

  /// Save a new post locally and queue it for sync.
  Future<void> _savePost() async {
    final title = _titleController.text.trim();
    final body = _bodyController.text.trim();

    if (title.isEmpty || body.isEmpty) return;

    final offlineSync = OfflineSyncProvider.of(context);

    // Use a unique ID for each post (here, the current timestamp).
    await offlineSync.saveLocalData(
      DateTime.now().millisecondsSinceEpoch.toString(),
      {'title': title, 'body': body, 'userId': 1},
    );

    _titleController.clear();
    _bodyController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Post saved locally and queued for sync!')),
    );
  }

  /// Fetch posts from the server and display them.
  Future<void> _fetchServerPosts() async {
    setState(() => _loading = true);

    final offlineSync = OfflineSyncProvider.of(context);

    try {
      // This will fetch from the server and update local storage.
      await offlineSync.updateFromServer();

      // After syncing, get all local posts.
      final all = await offlineSync.readAllLocalData();

      setState(() => _serverPosts =
          all.map((e) => e['data'] as Map<String, dynamic>).toList());
    } catch (e) {
      print('Failed to fetch from server: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch from server: $e')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final offlineSync = OfflineSyncProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('OfflineSync: Posts Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Input fields for post title and body
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Post Title'),
            ),
            TextField(
              controller: _bodyController,
              decoration: const InputDecoration(labelText: 'Post Body'),
              minLines: 2,
              maxLines: 4,
            ),
            const SizedBox(height: 8),
            // Buttons to save a post or fetch posts from the server
            Row(
              children: [
                ElevatedButton(
                  onPressed: _savePost,
                  child: const Text('Save Post'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _loading ? null : _fetchServerPosts,
                  child: _loading
                      ? const CircularProgressIndicator()
                      : const Text('Fetch Server Posts'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Show sync status
            ValueListenableBuilder<SyncStatus>(
              valueListenable: offlineSync.syncStatus,
              builder: (context, status, _) => Text('Sync Status: $status'),
            ),
            // Show error messages if any
            ValueListenableBuilder<SyncErrorType?>(
              valueListenable: offlineSync.lastError,
              builder: (context, error, _) => error != null
                  ? Text(
                      'Error: $error',
                      style: const TextStyle(color: Colors.red),
                    )
                  : const SizedBox.shrink(),
            ),
            // Show sync progress as a linear progress bar
            ValueListenableBuilder<double>(
              valueListenable: offlineSync.syncProgress,
              builder: (context, progress, _) =>
                  LinearProgressIndicator(value: progress),
            ),
            const SizedBox(height: 16),
            const Text('Server Posts:'),
            // Display the list of posts fetched from the server
            Expanded(
              child: _serverPosts.isEmpty
                  ? const Center(child: Text('No posts loaded.'))
                  : ListView.builder(
                      itemCount: _serverPosts.length,
                      itemBuilder: (context, i) {
                        final post = _serverPosts[i];
                        return ListTile(
                          title: Text(post['title'] ?? ''),
                          subtitle: Text(post['body'] ?? ''),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
