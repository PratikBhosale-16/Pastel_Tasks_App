import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:pastel_tasks/core/errors/app_exception.dart';
import 'package:pastel_tasks/core/logging/app_logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pastel_tasks/infrastructure/database/isar/collections/reminder_collection.dart';
import 'package:pastel_tasks/infrastructure/database/isar/collections/tag_collection.dart';
import 'package:pastel_tasks/infrastructure/database/isar/collections/task_collection.dart';
import 'package:pastel_tasks/infrastructure/database/isar/migrations/database_migration.dart';

/// Service managing the Isar database instance and transactions.
class DatabaseService {
  DatabaseService._();

  /// Shared Isar service instance.
  static final instance = DatabaseService._();

  Isar? _isar;

  /// Gets the active Isar instance or throws a [StorageException].
  Isar get instanceOrThrow {
    final isar = _isar;
    if (isar == null) {
      throw const StorageException('Database has not been initialized.');
    }
    return isar;
  }

  /// Initializes the Isar database and runs migrations.
  Future<Isar?> initialize() async {
    final existing = _isar;
    if (existing != null) {
      return existing;
    }

    try {
      var dirPath = '';
      if (!kIsWeb) {
        final directory = await getApplicationDocumentsDirectory();
        dirPath = directory.path;
      }

      final isar = await Isar.open(
        [
          TaskCollectionSchema,
          TagCollectionSchema,
          ReminderCollectionSchema,
        ],
        directory: dirPath,
      );

      _isar = isar;
      
      const migration = DatabaseMigration();
      await migration.runMigrations(isar);

      appLogger.info('Database initialized successfully.');
      return isar;
    } catch (e, stack) {
      appLogger.error('Failed to initialize database', error: e, stackTrace: stack);
      throw StorageException('Failed to open the local database.', cause: e);
    }
  }

  /// Closes the Isar database safely.
  Future<void> close({bool deleteFromDisk = false}) async {
    if (_isar != null) {
      final isOpen = _isar!.isOpen;
      if (isOpen) {
        await _isar!.close(deleteFromDisk: deleteFromDisk);
        appLogger.info('Database closed.');
      }
      _isar = null;
    }
  }

  /// Helper to perform a read transaction.
  Future<T> read<T>(Future<T> Function(Isar isar) operation) async {
    try {
      final isar = instanceOrThrow;
      return await isar.txn(() => operation(isar));
    } catch (e) {
      throw StorageException('Database read transaction failed.', cause: e);
    }
  }

  /// Helper to perform a write transaction.
  Future<T> write<T>(Future<T> Function(Isar isar) operation) async {
    try {
      final isar = instanceOrThrow;
      return await isar.writeTxn(() => operation(isar));
    } catch (e) {
      throw StorageException('Database write transaction failed.', cause: e);
    }
  }
}
