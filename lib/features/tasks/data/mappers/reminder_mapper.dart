import 'package:pastel_tasks/features/tasks/domain/models/reminder.dart';
import 'package:pastel_tasks/infrastructure/database/isar/collections/reminder_collection.dart';

/// Extension methods to map between Reminder domain model and ReminderCollection.
extension ReminderMapper on Reminder {
  /// Converts a domain Reminder to an Isar ReminderCollection.
  ReminderCollection toIsar() {
    return ReminderCollection()
      ..uuid = id
      ..taskId = taskId
      ..reminderDate = triggerTime
      ..repeatType = repeatRule
      ..isEnabled = enabled
      ..notificationId = 0
      ..repeatInterval = 0;
  }
}

extension ReminderCollectionMapper on ReminderCollection {
  /// Converts an Isar ReminderCollection to a domain Reminder.
  Reminder toDomain() {
    return Reminder(
      id: uuid,
      taskId: taskId,
      triggerTime: reminderDate,
      repeatRule: repeatType,
      enabled: isEnabled,
    );
  }
}
