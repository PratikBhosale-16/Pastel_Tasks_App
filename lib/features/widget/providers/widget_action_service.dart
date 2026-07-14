import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pastel_tasks/core/providers/core_providers.dart';
import 'package:pastel_tasks/infrastructure/database/isar/collections/task_collection.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/task_status.dart';
import 'package:isar/isar.dart';
import 'package:pastel_tasks/features/widget/providers/widget_sync_service.dart';

@pragma('vm:entry-point')
void backgroundCallback(Uri? uri) async {
  if (uri == null) return;
  debugPrint('Widget background callback triggered: ${uri.toString()}');

  if (uri.host == 'complete') {
    final id = uri.queryParameters['id'];
    if (id != null) {
      try {
        final dir = await getApplicationDocumentsDirectory();
        final isar = Isar.getInstance() ?? await Isar.open(
          [TaskCollectionSchema],
          directory: dir.path,
        );
        
        final task = await isar.taskCollections.filter().uuidEqualTo(id).findFirst();
        if (task != null) {
          await isar.writeTxn(() async {
            task.status = task.status == TaskStatus.completed ? TaskStatus.pending : TaskStatus.completed;
            task.updatedAt = DateTime.now();
            await isar.taskCollections.put(task);
          });
          
          // Sync widgets
          final syncService = WidgetSyncService(isar);
          await syncService.syncAllWidgets();
        }
      } catch (e) {
        debugPrint('Error in backgroundCallback: $e');
      }
    }
  }
}

class WidgetActionService {
  void initialize() {
    try {
      HomeWidget.setAppGroupId('YOUR_APP_GROUP_ID'); // Important for iOS, fine for Android
      HomeWidget.registerBackgroundCallback(backgroundCallback);
      
      // Check if launched from a widget
      HomeWidget.initiallyLaunchedFromHomeWidget().then(_handleWidgetAction).catchError((_) {});
      
      // Listen to background widget clicks while app is open
      HomeWidget.widgetClicked.listen(_handleWidgetAction).onError((_) {});
    } on MissingPluginException {
      // Ignore for tests
    } catch (e) {
      debugPrint('HomeWidget init error: $e');
    }
  }

  void _handleWidgetAction(Uri? uri) {
    if (uri == null) return;
    
    if (uri.host == 'add') {
      debugPrint('Widget action launched: ${uri.toString()}');
    }
  }
}

final widgetActionServiceProvider = Provider<WidgetActionService>((ref) {
  final service = WidgetActionService();
  service.initialize();
  return service;
});
