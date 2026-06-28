import 'package:pastel_tasks/core/result/result.dart';
import 'package:pastel_tasks/features/tasks/domain/models/task.dart';

/// Interface for task data operations.
abstract class TaskRepository {
  /// Creates a new task.
  Future<Result<Task>> create(Task task);

  /// Updates an existing task.
  Future<Result<Task>> update(Task task);

  /// Deletes a task permanently.
  Future<Result<void>> delete(String id);

  /// Soft deletes a task.
  Future<Result<void>> softDelete(String id);

  /// Archives a task.
  Future<Result<void>> archive(String id);

  /// Restores an archived or soft-deleted task.
  Future<Result<void>> restore(String id);

  /// Gets a task by its ID.
  Future<Result<Task?>> getById(String id);

  /// Gets all tasks.
  Future<Result<List<Task>>> getAll();

  /// Gets active (non-completed, non-archived) tasks.
  Future<Result<List<Task>>> getActive();

  /// Gets completed tasks.
  Future<Result<List<Task>>> getCompleted();

  /// Gets archived tasks.
  Future<Result<List<Task>>> getArchived();

  /// Searches tasks by title, description, or combined query.
  Future<Result<List<Task>>> search(String query);

  /// Gets tasks by a specific tag ID.
  Future<Result<List<Task>>> getByTag(String tagId);

  /// Gets tasks by a specific due date.
  Future<Result<List<Task>>> getByDueDate(DateTime date);

  /// Gets overdue tasks.
  Future<Result<List<Task>>> getOverdue();

  /// Pins a task.
  Future<Result<void>> pin(String id);

  /// Unpins a task.
  Future<Result<void>> unpin(String id);

  /// Reorders tasks based on the provided list of IDs.
  Future<Result<void>> reorder(List<String> orderedIds);

  /// Counts the active tasks.
  Future<Result<int>> countActive();

  /// Counts the completed tasks.
  Future<Result<int>> countCompleted();

  /// Watches a specific task for changes.
  Stream<Result<Task?>> watchTask(String id);

  /// Watches all tasks for changes.
  Stream<Result<List<Task>>> watchAll();
}
