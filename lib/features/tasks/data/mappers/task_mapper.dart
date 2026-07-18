import 'package:pastel_tasks/features/tasks/domain/models/task.dart';
import 'package:pastel_tasks/features/tasks/domain/models/sub_task.dart';
import 'package:pastel_tasks/infrastructure/database/isar/collections/task_collection.dart';

/// Extension methods to map between Task domain model and TaskCollection.
extension TaskMapper on Task {
  /// Converts a domain Task to an Isar TaskCollection.
  TaskCollection toIsar() {
    return TaskCollection()
      ..uuid = id
      ..title = title
      ..note = note
      ..status = status
      ..priority = priority
      ..tags = tags
      ..subTasks = subTasks.map((st) => SubTaskCollection()
        ..uuid = st.id
        ..title = st.title
        ..isCompleted = st.isCompleted).toList()
      ..createdAt = createdAt
      ..updatedAt = updatedAt
      ..dueDate = dueDate
      ..completedAt = completedAt
      ..repeatRule = repeatRule
      ..repeatEndDate = repeatEndDate
      ..repeatCount = repeatCount
      ..position = position
      ..isPinned = isPinned
      ..isArchived = isArchived
      ..color = color
      ..attachments = attachments
      ..richText = notes;
  }
}

extension TaskCollectionMapper on TaskCollection {
  /// Converts an Isar TaskCollection to a domain Task.
  Task toDomain() {
    return Task(
      id: uuid,
      title: title,
      note: note,
      status: status,
      priority: priority,
      tags: tags,
      subTasks: subTasks.map((st) => SubTask(
        id: st.uuid,
        title: st.title,
        isCompleted: st.isCompleted,
      )).toList(),
      createdAt: createdAt,
      updatedAt: updatedAt,
      dueDate: dueDate,
      completedAt: completedAt,
      repeatRule: repeatRule,
      repeatEndDate: repeatEndDate,
      repeatCount: repeatCount,
      position: position,
      isPinned: isPinned,
      isArchived: isArchived,
      color: color,
      attachments: attachments,
      notes: richText,
    );
  }
}
