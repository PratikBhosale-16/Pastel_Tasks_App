import 'package:isar/isar.dart';
import 'package:pastel_tasks/core/errors/app_exception.dart';
import 'package:pastel_tasks/core/errors/failure.dart';
import 'package:pastel_tasks/core/result/result.dart';
import 'package:pastel_tasks/features/tasks/data/mappers/task_mapper.dart';
import 'package:pastel_tasks/features/tasks/data/mappers/reminder_mapper.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/task_status.dart';
import 'package:pastel_tasks/features/tasks/domain/models/task.dart';
import 'package:pastel_tasks/features/tasks/domain/repositories/task_repository.dart';
import 'package:pastel_tasks/infrastructure/database/isar/collections/task_collection.dart';
import 'package:pastel_tasks/infrastructure/database/isar/collections/reminder_collection.dart';
import 'package:pastel_tasks/infrastructure/database/isar/database_service.dart';

/// Isar implementation of [TaskRepository].
class TaskRepositoryImpl implements TaskRepository {
  /// Creates a new [TaskRepositoryImpl].
  TaskRepositoryImpl({DatabaseService? dbService})
      : _dbService = dbService ?? DatabaseService.instance;

  final DatabaseService _dbService;

  Future<Task> _mapTask(Isar isar, TaskCollection collection) async {
    final reminderColl = await isar.reminderCollections.filter().taskIdEqualTo(collection.uuid).findFirst();
    final task = collection.toDomain();
    if (reminderColl != null) {
      return task.copyWith(reminder: reminderColl.toDomain());
    }
    return task;
  }

  @override
  Future<Result<Task>> create(Task task) async {
    try {
      final collection = task.toIsar();
      await _dbService.write((isar) async {
        await isar.taskCollections.put(collection);
        if (task.reminder != null) {
          await isar.reminderCollections.put(task.reminder!.toIsar());
        }
      });
      return Success(task);
    } catch (e) {
      return StorageFailure(StorageException('Failed to create task', cause: e));
    }
  }

  @override
  Future<Result<Task>> update(Task task) async {
    try {
      await _dbService.write((isar) async {
        final existing = await isar.taskCollections.filter().uuidEqualTo(task.id).findFirst();
        if (existing == null) throw const StorageException('Task not found');

        final updated = task.toIsar()..id = existing.id;
        await isar.taskCollections.put(updated);

        final existingReminder = await isar.reminderCollections.filter().taskIdEqualTo(task.id).findFirst();
        if (task.reminder != null) {
          final updatedRem = task.reminder!.toIsar();
          if (existingReminder != null) {
            updatedRem.id = existingReminder.id;
          }
          await isar.reminderCollections.put(updatedRem);
        } else if (existingReminder != null) {
          await isar.reminderCollections.delete(existingReminder.id);
        }
      });
      return Success(task);
    } catch (e) {
      return StorageFailure(StorageException('Failed to update task', cause: e));
    }
  }

  @override
  Future<Result<void>> delete(String id) async {
    try {
      await _dbService.write((isar) async {
        final existing = await isar.taskCollections.filter().uuidEqualTo(id).findFirst();
        if (existing != null) {
          await isar.taskCollections.delete(existing.id);
          final existingReminder = await isar.reminderCollections.filter().taskIdEqualTo(id).findFirst();
          if (existingReminder != null) {
            await isar.reminderCollections.delete(existingReminder.id);
          }
        }
      });
      return const Success(null);
    } catch (e) {
      return StorageFailure(StorageException('Failed to delete task permanently', cause: e));
    }
  }

  @override
  Future<Result<void>> softDelete(String id) async {
    try {
      await _dbService.write((isar) async {
        final existing = await isar.taskCollections.filter().uuidEqualTo(id).findFirst();
        if (existing != null) {
          existing.status = TaskStatus.archived;
          await isar.taskCollections.put(existing);
        }
      });
      return const Success(null);
    } catch (e) {
      return StorageFailure(StorageException('Failed to soft delete task', cause: e));
    }
  }

  @override
  Future<Result<void>> archive(String id) async {
    try {
      await _dbService.write((isar) async {
        final existing = await isar.taskCollections.filter().uuidEqualTo(id).findFirst();
        if (existing != null) {
          existing.isArchived = true;
          existing.status = TaskStatus.archived;
          await isar.taskCollections.put(existing);
        }
      });
      return const Success(null);
    } catch (e) {
      return StorageFailure(StorageException('Failed to archive task', cause: e));
    }
  }

  @override
  Future<Result<void>> restore(String id) async {
    try {
      await _dbService.write((isar) async {
        final existing = await isar.taskCollections.filter().uuidEqualTo(id).findFirst();
        if (existing != null) {
          existing.isArchived = false;
          existing.status = TaskStatus.pending;
          await isar.taskCollections.put(existing);
        }
      });
      return const Success(null);
    } catch (e) {
      return StorageFailure(StorageException('Failed to restore task', cause: e));
    }
  }

  @override
  Future<Result<Task?>> getById(String id) async {
    try {
      return await _dbService.read((isar) async {
        final taskColl = await isar.taskCollections.filter().uuidEqualTo(id).findFirst();
        if (taskColl == null) return const Success(null);
        return Success(await _mapTask(isar, taskColl));
      });
    } catch (e) {
      return StorageFailure(StorageException('Failed to get task by id', cause: e));
    }
  }

  @override
  Future<Result<List<Task>>> getAll() async {
    try {
      return await _dbService.read((isar) async {
        final tasksColl = await isar.taskCollections.where().sortByPosition().findAll();
        final domainTasks = <Task>[];
        for (final t in tasksColl) {
          domainTasks.add(await _mapTask(isar, t));
        }
        return Success(domainTasks);
      });
    } catch (e) {
      return StorageFailure(StorageException('Failed to get all tasks', cause: e));
    }
  }

  @override
  Future<Result<void>> pin(String id) async {
    try {
      await _dbService.write((isar) async {
        final existing = await isar.taskCollections.filter().uuidEqualTo(id).findFirst();
        if (existing != null) {
          existing.isPinned = true;
          await isar.taskCollections.put(existing);
        }
      });
      return const Success(null);
    } catch (e) {
      return StorageFailure(StorageException('Failed to pin task', cause: e));
    }
  }

  @override
  Future<Result<void>> unpin(String id) async {
    try {
      await _dbService.write((isar) async {
        final existing = await isar.taskCollections.filter().uuidEqualTo(id).findFirst();
        if (existing != null) {
          existing.isPinned = false;
          await isar.taskCollections.put(existing);
        }
      });
      return const Success(null);
    } catch (e) {
      return StorageFailure(StorageException('Failed to unpin task', cause: e));
    }
  }

  @override
  Future<Result<void>> reorder(List<String> orderedIds) async {
    try {
      await _dbService.write((isar) async {
        for (var i = 0; i < orderedIds.length; i++) {
          final id = orderedIds[i];
          final existing = await isar.taskCollections.filter().uuidEqualTo(id).findFirst();
          if (existing != null) {
            existing.position = i.toDouble();
            await isar.taskCollections.put(existing);
          }
        }
      });
      return const Success(null);
    } catch (e) {
      return StorageFailure(StorageException('Failed to reorder tasks', cause: e));
    }
  }

  @override
  Future<Result<int>> countActive() async {
    try {
      return await _dbService.read((isar) async {
        final count = await isar.taskCollections
            .filter()
            .statusEqualTo(TaskStatus.pending)
            .and()
            .isArchivedEqualTo(false)
            .count();
        return Success(count);
      });
    } catch (e) {
      return StorageFailure(StorageException('Failed to count active tasks', cause: e));
    }
  }

  @override
  Future<Result<int>> countCompleted() async {
    try {
      return await _dbService.read((isar) async {
        final count = await isar.taskCollections
            .filter()
            .statusEqualTo(TaskStatus.completed)
            .count();
        return Success(count);
      });
    } catch (e) {
      return StorageFailure(StorageException('Failed to count completed tasks', cause: e));
    }
  }

  @override
  Stream<Result<Task?>> watchTask(String id) {
    try {
      final isar = _dbService.instanceOrThrow;
      final query = isar.taskCollections.filter().uuidEqualTo(id).build();
      return query.watch(fireImmediately: true).asyncMap((results) async {
        if (results.isEmpty) return const Success(null);
        return Success(await _mapTask(isar, results.first));
      });
    } catch (e) {
      return Stream.value(StorageFailure(StorageException('Failed to watch task', cause: e)));
    }
  }

  @override
  Stream<Result<List<Task>>> watchAll() {
    try {
      final isar = _dbService.instanceOrThrow;
      return isar.taskCollections
          .where()
          .sortByPosition()
          .watch(fireImmediately: true)
          .asyncMap((tasks) async {
            final domainTasks = <Task>[];
            for (final t in tasks) {
              domainTasks.add(await _mapTask(isar, t));
            }
            return Success(domainTasks);
          });
    } catch (e) {
      return Stream.value(StorageFailure(StorageException('Failed to watch all tasks', cause: e)));
    }
  }

  @override
  Future<Result<void>> bulkUpdate(List<Task> tasks) async {
    try {
      await _dbService.write((isar) async {
        for (final task in tasks) {
          final existing = await isar.taskCollections.filter().uuidEqualTo(task.id).findFirst();
          if (existing != null) {
            final updated = task.toIsar()..id = existing.id;
            await isar.taskCollections.put(updated);
            
            final existingReminder = await isar.reminderCollections.filter().taskIdEqualTo(task.id).findFirst();
            if (task.reminder != null) {
              final updatedRem = task.reminder!.toIsar();
              if (existingReminder != null) {
                updatedRem.id = existingReminder.id;
              }
              await isar.reminderCollections.put(updatedRem);
            } else if (existingReminder != null) {
              await isar.reminderCollections.delete(existingReminder.id);
            }
          }
        }
      });
      return const Success(null);
    } catch (e) {
      return StorageFailure(StorageException('Failed to bulk update tasks', cause: e));
    }
  }

  @override
  Future<Result<void>> bulkDelete(List<String> ids) async {
    try {
      await _dbService.write((isar) async {
        for (final id in ids) {
          final existing = await isar.taskCollections.filter().uuidEqualTo(id).findFirst();
          if (existing != null) {
            await isar.taskCollections.delete(existing.id);
            final existingReminder = await isar.reminderCollections.filter().taskIdEqualTo(id).findFirst();
            if (existingReminder != null) {
              await isar.reminderCollections.delete(existingReminder.id);
            }
          }
        }
      });
      return const Success(null);
    } catch (e) {
      return StorageFailure(StorageException('Failed to bulk delete tasks', cause: e));
    }
  }
}
