import 'package:pastel_tasks/core/logging/app_logger.dart';
import 'package:workmanager/workmanager.dart';
import 'package:pastel_tasks/features/backup/data/repositories/local_backup_repository.dart';
import 'package:pastel_tasks/features/backup/data/services/backup_crypto_service.dart';
import 'package:pastel_tasks/features/backup/data/mappers/backup_mapper.dart';
import 'package:pastel_tasks/infrastructure/database/isar/database_service.dart';
import 'package:pastel_tasks/infrastructure/database/isar/collections/tag_collection.dart';
import 'package:pastel_tasks/infrastructure/database/isar/collections/task_collection.dart';
import 'package:pastel_tasks/infrastructure/database/isar/collections/reminder_collection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:isar/isar.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    appLogger.info('Background task executed: $task');
    
    if (task == 'pastel_tasks_auto_backup') {
      try {
        final prefs = await SharedPreferences.getInstance();
        final autoBackupPref = prefs.getString('autoBackupFrequency') ?? 'off';
        
        if (autoBackupPref != 'off') {
          // Verify time since last backup based on frequency... (simplified for MVP)
          
          final isar = await DatabaseService.instance.initialize(); // Re-init Isar in background isolate
          if (isar == null) {
            appLogger.error('Auto backup failed: Isar is null');
            return Future.value(false);
          }
          
          final tasks = await isar.taskCollections.where().findAll();
          final tags = await isar.tagCollections.where().findAll();
          final reminders = await isar.reminderCollections.where().findAll();
          
          final payload = BackupMapper.createPayload(
            tasks: tasks,
            tags: tags,
            reminders: reminders,
            prefs: prefs,
          );
          
          final repo = LocalBackupRepository(BackupCryptoService());
          await repo.createBackup(payload); // No password by default for auto backup
          
          // Optionally close Isar if needed, though Isar handles multi-isolate safely
          appLogger.info('Auto backup successful');
        }
      } catch (e, stack) {
        appLogger.error('Auto backup failed', error: e, stackTrace: stack);
        return Future.value(false);
      }
    }
    
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
    
    // Register periodic task for other syncs if any
    await Workmanager().registerPeriodicTask(
      'pastel_tasks_periodic_sync',
      'pastel_tasks_periodic_sync_task',
      frequency: const Duration(hours: 4),
      constraints: Constraints(
        networkType: NetworkType.notRequired,
        requiresBatteryNotLow: true,
      ),
    );

    // Register auto backup task (daily check)
    await Workmanager().registerPeriodicTask(
      'pastel_tasks_auto_backup',
      'pastel_tasks_auto_backup',
      frequency: const Duration(days: 1),
      constraints: Constraints(
        networkType: NetworkType.notRequired,
        requiresBatteryNotLow: true,
        requiresStorageNotLow: true,
      ),
    );
  }
}
