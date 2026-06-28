import 'package:pastel_tasks/core/result/result.dart';
import 'package:pastel_tasks/features/tasks/domain/models/reminder.dart';

/// Interface for reminder data operations.
abstract class ReminderRepository {
  /// Creates a new reminder.
  Future<Result<Reminder>> create(Reminder reminder);

  /// Updates an existing reminder.
  Future<Result<Reminder>> update(Reminder reminder);

  /// Deletes a reminder by its ID.
  Future<Result<void>> delete(String id);

  /// Gets a reminder by its ID.
  Future<Result<Reminder?>> getById(String id);

  /// Gets upcoming reminders.
  Future<Result<List<Reminder>>> getUpcoming();

  /// Gets all enabled reminders.
  Future<Result<List<Reminder>>> getEnabled();

  /// Watches all reminders for changes.
  Stream<Result<List<Reminder>>> watchAll();
}
