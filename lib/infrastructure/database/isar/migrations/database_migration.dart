import 'package:isar/isar.dart';
import 'package:pastel_tasks/core/logging/app_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseMigration {
  const DatabaseMigration();

  static const int currentVersion = 1;
  static const String _versionKey = 'db_version';

  Future<void> runMigrations(Isar isar) async {
    final prefs = await SharedPreferences.getInstance();
    final storedVersion = prefs.getInt(_versionKey) ?? 0;

    if (storedVersion < currentVersion) {
      appLogger.info('Migrating database from version $storedVersion to $currentVersion');
      
      // Future schema migrations go here.
      
      await prefs.setInt(_versionKey, currentVersion);
      appLogger.info('Database migration complete.');
    }
  }
}
