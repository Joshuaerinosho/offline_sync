import 'package:flutter/widgets.dart';
import 'offline_sync.dart';

/// Provides [OfflineSync] and its sync status, error, and progress to the widget tree.
class OfflineSyncProvider extends InheritedWidget {
  final OfflineSync offlineSync;

  const OfflineSyncProvider({
    Key? key,
    required this.offlineSync,
    required Widget child,
  }) : super(key: key, child: child);

  static OfflineSync of(BuildContext context) {
    final OfflineSyncProvider? provider =
        context.dependOnInheritedWidgetOfExactType<OfflineSyncProvider>();
    assert(provider != null, 'No OfflineSyncProvider found in context');
    return provider!.offlineSync;
  }

  @override
  bool updateShouldNotify(OfflineSyncProvider oldWidget) =>
      offlineSync != oldWidget.offlineSync;
}

/// Example usage:
///
/// ```dart
/// final offlineSync = OfflineSync(config: ...);
/// await offlineSync.initialize();
/// runApp(
///   OfflineSyncProvider(
///     offlineSync: offlineSync,
///     child: MyApp(),
///   ),
/// );
/// ```
///
/// Then, anywhere in the widget tree:
///
/// ```dart
/// final offlineSync = OfflineSyncProvider.of(context);
/// ValueListenableBuilder<SyncStatus>(
///   valueListenable: offlineSync.syncStatus,
///   builder: (context, status, _) {
///     // Show sync status in UI
///   },
/// )
/// ```
