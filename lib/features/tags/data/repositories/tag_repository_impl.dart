import 'package:isar/isar.dart';
import 'package:pastel_tasks/core/result/result.dart';
import 'package:pastel_tasks/core/errors/failure.dart';
import 'package:pastel_tasks/core/errors/app_exception.dart';
import 'package:pastel_tasks/features/tags/domain/models/tag.dart';
import 'package:pastel_tasks/features/tags/domain/repositories/tag_repository.dart';
import 'package:pastel_tasks/infrastructure/database/isar/collections/tag_collection.dart';
import 'package:pastel_tasks/infrastructure/database/isar/collections/task_collection.dart';

class TagRepositoryImpl implements TagRepository {
  TagRepositoryImpl(this._isar);

  final Isar _isar;

  Tag _mapToDomain(TagCollection collection) {
    return Tag(
      id: collection.uuid,
      name: collection.name,
      color: collection.color,
      icon: collection.icon,
      position: collection.position,
      createdAt: collection.createdAt,
    );
  }

  TagCollection _mapToCollection(Tag tag) {
    return TagCollection()
      ..uuid = tag.id
      ..name = tag.name
      ..color = tag.color
      ..icon = tag.icon
      ..position = tag.position
      ..createdAt = tag.createdAt;
  }

  @override
  Stream<List<Tag>> watchTags() {
    return _isar.tagCollections
        .where()
        .sortByPosition()
        .watch(fireImmediately: true)
        .map((collections) => collections.map(_mapToDomain).toList());
  }

  @override
  Future<List<Tag>> getTags() async {
    final collections =
        await _isar.tagCollections.where().sortByPosition().findAll();
    return collections.map(_mapToDomain).toList();
  }

  @override
  Future<Result<Tag>> create(Tag tag) async {
    try {
      final existingName =
          await _isar.tagCollections.filter().nameEqualTo(tag.name).findFirst();
      if (existingName != null) {
        return const StorageFailure(
          StorageException('A tag with this name already exists.'),
        );
      }

      final collection = _mapToCollection(tag);
      await _isar.writeTxn(() async {
        await _isar.tagCollections.put(collection);
      });
      return Success(tag);
    } catch (e) {
      return StorageFailure(
        StorageException('Failed to create tag', cause: e),
      );
    }
  }

  @override
  Future<Result<Tag>> update(Tag tag) async {
    try {
      final existing =
          await _isar.tagCollections.filter().uuidEqualTo(tag.id).findFirst();
      if (existing == null) {
        return const StorageFailure(
          StorageException('Tag not found'),
        );
      }
      
      // Check for name duplicates if name changed
      if (existing.name != tag.name) {
         final duplicateName = await _isar.tagCollections.filter().nameEqualTo(tag.name).findFirst();
         if (duplicateName != null) {
            return const StorageFailure(
              StorageException('A tag with this name already exists.'),
            );
         }
      }

      final collection = _mapToCollection(tag);
      collection.id = existing.id; // Preserve Isar auto-increment ID

      await _isar.writeTxn(() async {
        await _isar.tagCollections.put(collection);
      });
      return Success(tag);
    } catch (e) {
      return StorageFailure(
        StorageException('Failed to update tag', cause: e),
      );
    }
  }

  @override
  Future<Result<void>> delete(String uuid) async {
    try {
      final existing =
          await _isar.tagCollections.filter().uuidEqualTo(uuid).findFirst();
      if (existing == null) {
        return const StorageFailure(
          StorageException('Tag not found'),
        );
      }

      await _isar.writeTxn(() async {
        // Delete tag
        await _isar.tagCollections.delete(existing.id);

        // Remove tag reference from all tasks
        final tasksWithTag = await _isar.taskCollections
            .filter()
            .tagsElementEqualTo(uuid)
            .findAll();

        for (final task in tasksWithTag) {
          final newTags = List<String>.from(task.tags)..remove(uuid);
          task.tags = newTags;
          task.updatedAt = DateTime.now().toUtc();
          await _isar.taskCollections.put(task);
        }
      });
      return const Success(null);
    } catch (e) {
      return StorageFailure(
        StorageException('Failed to delete tag', cause: e),
      );
    }
  }
}
