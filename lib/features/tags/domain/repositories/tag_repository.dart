import 'package:pastel_tasks/core/result/result.dart';
import 'package:pastel_tasks/features/tags/domain/models/tag.dart';

/// Repository interface for tag management.
abstract class TagRepository {
  /// Watches all tags, ordered by position.
  Stream<List<Tag>> watchTags();

  /// Gets all tags synchronously.
  Future<List<Tag>> getTags();

  /// Creates a new tag.
  Future<Result<Tag>> create(Tag tag);

  /// Updates an existing tag.
  Future<Result<Tag>> update(Tag tag);

  /// Deletes a tag by its UUID.
  Future<Result<void>> delete(String uuid);
}
