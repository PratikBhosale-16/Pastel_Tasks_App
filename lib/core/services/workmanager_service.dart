import 'package:pastel_tasks/core/logging/app_logger.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    appLogger.info('Background task executed: $task');
    // Implement background sync logic here (e.g. check for overdue tasks)
    return Future.value(true);
  });
}

class WorkManagerService {
  WorkManagerService._();

  static final instance = WorkManagerService._();

  Future<void> initialize() async {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false,
    );
    appLogger.info('Workmanager initialized.');
    
    // Register periodic task
    await Workmanager().registerPeriodicTask(
      'pastel_tasks_periodic_sync',
      'pastel_tasks_periodic_sync_task',
      frequency: const Duration(hours: 4),
      constraints: Constraints(
        networkType: NetworkType.notRequired,
        requiresBatteryNotLow: true,
      ),
    );
  }
}
