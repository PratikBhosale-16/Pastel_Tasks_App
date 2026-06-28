import 'package:isar/isar.dart';
import 'package:pastel_tasks/core/errors/app_exception.dart';
import 'package:pastel_tasks/core/errors/failure.dart';
import 'package:pastel_tasks/core/result/result.dart';
import 'package:pastel_tasks/features/tasks/data/mappers/reminder_mapper.dart';
import 'package:pastel_tasks/features/tasks/domain/models/reminder.dart';
import 'package:pastel_tasks/features/tasks/domain/repositories/reminder_repository.dart';
import 'package:pastel_tasks/infrastructure/database/isar/collections/reminder_collection.dart';
import 'package:pastel_tasks/infrastructure/database/isar/database_service.dart';

/// Isar implementation of [ReminderRepository].
class ReminderRepositoryImpl implements ReminderRepository {
  /// Creates a new [ReminderRepositoryImpl].
  ReminderRepositoryImpl({DatabaseService? dbService})
      : _dbService = dbService ?? DatabaseService.instance;

  final DatabaseService _dbService;

  @override
  Future<Result<Reminder>> create(Reminder reminder) async {
    try {
      final collection = reminder.toIsar();
      await _dbService.write((isar) async {
        await isar.reminderCollections.put(collection);
      });
      return Success(reminder);
    } catch (e) {
      return StorageFailure(StorageException('Failed to create reminder', cause: e));
    }
  }

  @override
  Future<Result<Reminder>> update(Reminder reminder) async {
    try {
      await _dbService.write((isar) async {
        final existing = await isar.reminderCollections.filter().uuidEqualTo(reminder.id).findFirst();
        if (existing == null) throw const StorageException('Reminder not found');

        final updated = reminder.toIsar()..id = existing.id;
        await isar.reminderCollections.put(updated);
      });
      return Success(reminder);
    } catch (e) {
      return StorageFailure(StorageException('Failed to update reminder', cause: e));
    }
  }

  @override
  Future<Result<void>> delete(String id) async {
    try {
      await _dbService.write((isar) async {
        final existing = await isar.reminderCollections.filter().uuidEqualTo(id).findFirst();
        if (existing != null) {
          await isar.reminderCollections.delete(existing.id);
        }
      });
      return const Success(null);
    } catch (e) {
      return StorageFailure(StorageException('Failed to delete reminder', cause: e));
    }
  }

  @override
  Future<Result<Reminder?>> getById(String id) async {
    try {
      return await _dbService.read((isar) async {
        final reminder = await isar.reminderCollections.filter().uuidEqualTo(id).findFirst();
        return Success(reminder?.toDomain());
      });
    } catch (e) {
      return StorageFailure(StorageException('Failed to get reminder by id', cause: e));
    }
  }

  @override
  Future<Result<List<Reminder>>> getUpcoming() async {
    try {
      return await _dbService.read((isar) async {
        final reminders = await isar.reminderCollections
            .filter()
            .reminderDateGreaterThan(DateTime.now())
            .and()
            .isEnabledEqualTo(true)
            .sortByReminderDate()
            .findAll();
        return Success(reminders.map((e) => e.toDomain()).toList());
      });
    } catch (e) {
      return StorageFailure(StorageException('Failed to get upcoming reminders', cause: e));
    }
  }

  @override
  Future<Result<List<Reminder>>> getEnabled() async {
    try {
      return await _dbService.read((isar) async {
        final reminders = await isar.reminderCollections
            .filter()
            .isEnabledEqualTo(true)
            .sortByReminderDate()
            .findAll();
        return Success(reminders.map((e) => e.toDomain()).toList());
      });
    } catch (e) {
      return StorageFailure(StorageException('Failed to get enabled reminders', cause: e));
    }
  }

  @override
  Stream<Result<List<Reminder>>> watchAll() {
    try {
      final isar = _dbService.instanceOrThrow;
      return isar.reminderCollections
          .where()
          .sortByReminderDate()
          .watch(fireImmediately: true)
          .map((reminders) => Success(reminders.map((e) => e.toDomain()).toList()));
    } catch (e) {
      return Stream.value(StorageFailure(StorageException('Failed to watch reminders', cause: e)));
    }
  }
}
