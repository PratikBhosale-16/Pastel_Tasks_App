import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pastel_tasks/features/widget/providers/widget_sync_service.dart';

// Provider that triggers the sync service to start listening
final widgetInitializationProvider = Provider<void>((ref) {
  // Just watching the provider causes the service to be created
  // and the listenToChanges() method is called in the constructor.
  ref.watch(widgetSyncServiceProvider);
});
