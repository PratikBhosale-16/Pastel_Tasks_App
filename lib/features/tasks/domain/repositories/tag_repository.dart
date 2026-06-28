import 'package:pastel_tasks/core/result/result.dart';
import 'package:pastel_tasks/features/tasks/domain/models/tag.dart';

/// Interface for tag data operations.
abstract class TagRepository {
  /// Creates a new tag.
  Future<Result<Tag>> create(Tag tag);

  /// Updates an existing tag.
  Future<Result<Tag>> update(Tag tag);

  /// Deletes a tag by its ID.
  Future<Result<void>> delete(String id);

  /// Gets a tag by its ID.
  Future<Result<Tag?>> getById(String id);

  /// Gets all tags.
  Future<Result<List<Tag>>> getAll();

  /// Searches for tags matching a query.
  Future<Result<List<Tag>>> search(String query);

  /// Reorders tags based on the provided list of IDs.
  Future<Result<void>> reorder(List<String> orderedIds);

  /// Counts the total number of tags.
  Future<Result<int>> count();

  /// Watches all tags for changes.
  Stream<Result<List<Tag>>> watchAll();

  /// Watches a specific tag for changes.
  Stream<Result<Tag?>> watchTag(String id);
}
