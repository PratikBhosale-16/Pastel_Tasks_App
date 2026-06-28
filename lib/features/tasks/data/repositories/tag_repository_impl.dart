import 'package:isar/isar.dart';
import 'package:pastel_tasks/core/errors/app_exception.dart';
import 'package:pastel_tasks/core/errors/failure.dart';
import 'package:pastel_tasks/core/result/result.dart';
import 'package:pastel_tasks/features/tasks/data/mappers/tag_mapper.dart';
import 'package:pastel_tasks/features/tasks/domain/models/tag.dart';
import 'package:pastel_tasks/features/tasks/domain/repositories/tag_repository.dart';
import 'package:pastel_tasks/infrastructure/database/isar/collections/tag_collection.dart';
import 'package:pastel_tasks/infrastructure/database/isar/database_service.dart';

/// Isar implementation of [TagRepository].
class TagRepositoryImpl implements TagRepository {
  /// Creates a new [TagRepositoryImpl].
  TagRepositoryImpl({DatabaseService? dbService})
      : _dbService = dbService ?? DatabaseService.instance;

  final DatabaseService _dbService;

  @override
  Future<Result<Tag>> create(Tag tag) async {
    try {
      final collection = tag.toIsar();
      await _dbService.write((isar) async {
        await isar.tagCollections.put(collection);
      });
      return Success(tag);
    } catch (e) {
      return StorageFailure(StorageException('Failed to create tag', cause: e));
    }
  }

  @override
  Future<Result<Tag>> update(Tag tag) async {
    try {
      await _dbService.write((isar) async {
        final existing = await isar.tagCollections.filter().uuidEqualTo(tag.id).findFirst();
        if (existing == null) throw const StorageException('Tag not found');

        final updated = tag.toIsar()..id = existing.id;
        await isar.tagCollections.put(updated);
      });
      return Success(tag);
    } catch (e) {
      return StorageFailure(StorageException('Failed to update tag', cause: e));
    }
  }

  @override
  Future<Result<void>> delete(String id) async {
    try {
      await _dbService.write((isar) async {
        final existing = await isar.tagCollections.filter().uuidEqualTo(id).findFirst();
        if (existing != null) {
          await isar.tagCollections.delete(existing.id);
        }
      });
      return const Success(null);
    } catch (e) {
      return StorageFailure(StorageException('Failed to delete tag', cause: e));
    }
  }

  @override
  Future<Result<Tag?>> getById(String id) async {
    try {
      return await _dbService.read((isar) async {
        final tag = await isar.tagCollections.filter().uuidEqualTo(id).findFirst();
        return Success(tag?.toDomain());
      });
    } catch (e) {
      return StorageFailure(StorageException('Failed to get tag by id', cause: e));
    }
  }

  @override
  Future<Result<List<Tag>>> getAll() async {
    try {
      return await _dbService.read((isar) async {
        final tags = await isar.tagCollections.where().sortByPosition().findAll();
        return Success(tags.map((e) => e.toDomain()).toList());
      });
    } catch (e) {
      return StorageFailure(StorageException('Failed to get all tags', cause: e));
    }
  }

  @override
  Future<Result<List<Tag>>> search(String query) async {
    try {
      return await _dbService.read((isar) async {
        final tags = await isar.tagCollections
            .filter()
            .nameContains(query, caseSensitive: false)
            .sortByPosition()
            .findAll();
        return Success(tags.map((e) => e.toDomain()).toList());
      });
    } catch (e) {
      return StorageFailure(StorageException('Failed to search tags', cause: e));
    }
  }

  @override
  Future<Result<void>> reorder(List<String> orderedIds) async {
    try {
      await _dbService.write((isar) async {
        for (var i = 0; i < orderedIds.length; i++) {
          final id = orderedIds[i];
          final existing = await isar.tagCollections.filter().uuidEqualTo(id).findFirst();
          if (existing != null) {
            existing.position = i.toDouble();
            await isar.tagCollections.put(existing);
          }
        }
      });
      return const Success(null);
    } catch (e) {
      return StorageFailure(StorageException('Failed to reorder tags', cause: e));
    }
  }

  @override
  Future<Result<int>> count() async {
    try {
      return await _dbService.read((isar) async {
        final count = await isar.tagCollections.count();
        return Success(count);
      });
    } catch (e) {
      return StorageFailure(StorageException('Failed to count tags', cause: e));
    }
  }

  @override
  Stream<Result<List<Tag>>> watchAll() {
    try {
      final isar = _dbService.instanceOrThrow;
      return isar.tagCollections
          .where()
          .sortByPosition()
          .watch(fireImmediately: true)
          .map((tags) => Success(tags.map((e) => e.toDomain()).toList()));
    } catch (e) {
      return Stream.value(StorageFailure(StorageException('Failed to watch tags', cause: e)));
    }
  }

  @override
  Stream<Result<Tag?>> watchTag(String id) {
    try {
      final isar = _dbService.instanceOrThrow;
      final query = isar.tagCollections.filter().uuidEqualTo(id).build();
      return query.watch(fireImmediately: true).map((results) {
        if (results.isEmpty) return const Success(null);
        return Success(results.first.toDomain());
      });
    } catch (e) {
      return Stream.value(StorageFailure(StorageException('Failed to watch tag', cause: e)));
    }
  }
}
