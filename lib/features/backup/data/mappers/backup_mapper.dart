import 'dart:convert';
import 'package:pastel_tasks/features/backup/domain/models/backup_payload.dart';
import 'package:pastel_tasks/infrastructure/database/isar/collections/tag_collection.dart';
import 'package:pastel_tasks/infrastructure/database/isar/collections/task_collection.dart';
import 'package:pastel_tasks/infrastructure/database/isar/collections/reminder_collection.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/repeat_rule.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/task_status.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/priority.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class BackupMapper {
  static BackupPayload createPayload({
    required List<TaskCollection> tasks,
    required List<TagCollection> tags,
    required List<ReminderCollection> reminders,
    required SharedPreferences prefs,
  }) {
    final prefsMap = <String, dynamic>{};
    for (final key in prefs.getKeys()) {
      prefsMap[key] = prefs.get(key);
    }

    return BackupPayload(
      version: 1,
      appVersion: '1.0.0', // TODO: get from package_info_plus
      createdAt: DateTime.now(),
      tasksJson: tasks.map(_taskCollectionToJson).toList(),
      tagsJson: tags.map(_tagCollectionToJson).toList(),
      remindersJson: reminders.map(_reminderCollectionToJson).toList(),
      preferencesJson: prefsMap,
    );
  }

  static Map<String, dynamic> _taskCollectionToJson(TaskCollection task) {
    return {
      'id': task.id,
      'uuid': task.uuid,
      'title': task.title,
      'note': task.note,
      'status': task.status.name,
      'priority': task.priority.name,
      'tags': task.tags,
      'createdAt': task.createdAt.toIso8601String(),
      'updatedAt': task.updatedAt.toIso8601String(),
      'dueDate': task.dueDate?.toIso8601String(),
      'completedAt': task.completedAt?.toIso8601String(),
      // 'reminder': task.reminderId, // We might need to handle ReminderCollection if reminders are stored separately
      'repeatRule': task.repeatRule.name,
      'position': task.position,
      'isPinned': task.isPinned,
      'isArchived': task.isArchived,
      'color': task.color,
      'attachments': task.attachments,
    };
  }

  static TaskCollection taskCollectionFromJson(Map<String, dynamic> json) {
    return TaskCollection()
      ..uuid = json['uuid'] as String? ?? const Uuid().v4()
      ..title = json['title'] as String
      ..note = json['note'] as String
      ..status = TaskStatus.values.firstWhere((e) => e.name == json['status'], orElse: () => TaskStatus.pending)
      ..priority = Priority.values.firstWhere((e) => e.name == json['priority'], orElse: () => Priority.medium)
      ..tags = (json['tags'] as List).cast<String>()
      ..createdAt = DateTime.parse(json['createdAt'] as String)
      ..updatedAt = DateTime.parse(json['updatedAt'] as String)
      ..dueDate = json['dueDate'] != null ? DateTime.parse(json['dueDate'] as String) : null
      ..completedAt = json['completedAt'] != null ? DateTime.parse(json['completedAt'] as String) : null
      ..repeatRule = RepeatRule.values.firstWhere((e) => e.name == json['repeatRule'], orElse: () => RepeatRule.none)
      ..position = (json['position'] as num).toDouble()
      ..isPinned = json['isPinned'] as bool
      ..isArchived = json['isArchived'] as bool
      ..color = json['color'] as String
      ..attachments = (json['attachments'] as List).cast<String>();
  }

  static Map<String, dynamic> _tagCollectionToJson(TagCollection tag) {
    return {
      'id': tag.id,
      'uuid': tag.uuid,
      'name': tag.name,
      'color': tag.color,
      'icon': tag.icon,
      'position': tag.position,
      'createdAt': tag.createdAt.toIso8601String(),
    };
  }

  static TagCollection tagCollectionFromJson(Map<String, dynamic> json) {
    return TagCollection()
      ..uuid = json['uuid'] as String? ?? const Uuid().v4()
      ..name = json['name'] as String
      ..color = json['color'] as String
      ..icon = json['icon'] as String
      ..position = (json['position'] as num).toDouble()
      ..createdAt = DateTime.parse(json['createdAt'] as String);
  }

  static Map<String, dynamic> _reminderCollectionToJson(ReminderCollection reminder) {
    return {
      'uuid': reminder.uuid,
      'taskId': reminder.taskId,
      'reminderDate': reminder.reminderDate.toIso8601String(),
      'notificationId': reminder.notificationId,
      'repeatType': reminder.repeatType.name,
      'repeatInterval': reminder.repeatInterval,
      'isEnabled': reminder.isEnabled,
    };
  }

  static ReminderCollection reminderCollectionFromJson(Map<String, dynamic> json) {
    return ReminderCollection()
      ..uuid = json['uuid'] as String? ?? const Uuid().v4()
      ..taskId = json['taskId'] as String
      ..reminderDate = DateTime.parse(json['reminderDate'] as String)
      ..notificationId = json['notificationId'] as int
      ..repeatType = RepeatRule.values.firstWhere((e) => e.name == (json['repeatType'] as String))
      ..repeatInterval = json['repeatInterval'] as int
      ..isEnabled = json['isEnabled'] as bool;
  }
}
