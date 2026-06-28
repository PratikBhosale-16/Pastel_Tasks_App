import 'package:pastel_tasks/features/tasks/domain/enums/task_status.dart';
import 'package:pastel_tasks/features/tasks/domain/models/task.dart';

/// Validates business rules for Task entities.
class TaskValidator {
  const TaskValidator();

  /// Validates a task entity based on domain rules.
  /// Throws [ArgumentError] if validation fails.
  void validate(Task task) {
    if (task.title.trim().isEmpty) {
      throw ArgumentError('Title cannot be empty.');
    }

    if (task.title.length > 150) {
      throw ArgumentError('Title length cannot exceed 150 characters.');
    }

    if (task.description.length > 5000) {
      throw ArgumentError('Description length cannot exceed 5000 characters.');
    }

    if (task.dueDate != null) {
      if (task.dueDate!.isBefore(task.createdAt)) {
        throw ArgumentError('Due date cannot be before creation date.');
      }
    }

    if (task.reminder != null) {
      if (task.reminder!.triggerTime.isBefore(task.createdAt)) {
        throw ArgumentError('Reminder cannot be scheduled before creation date.');
      }
    }

    if (task.isArchived && task.isPinned) {
      throw ArgumentError('An archived task cannot be pinned.');
    }

    if (task.isArchived && task.status != TaskStatus.completed && task.status != TaskStatus.archived) {
      throw ArgumentError('Only completed or archived tasks can have isArchived set to true.');
    }
  }
}
