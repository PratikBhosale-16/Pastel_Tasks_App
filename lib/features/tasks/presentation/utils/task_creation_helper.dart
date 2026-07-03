import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:pastel_tasks/features/tasks/domain/enums/priority.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/repeat_rule.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/task_status.dart';
import 'package:pastel_tasks/features/tasks/domain/models/task.dart';
import 'package:pastel_tasks/features/tasks/domain/models/reminder.dart';
import 'package:pastel_tasks/features/tasks/presentation/providers/task_notifier.dart';
import 'package:pastel_tasks/features/tasks/presentation/widgets/add_task_bottom_sheet/add_task_bottom_sheet.dart';

class TaskCreationHelper {
  static Future<void> showAddTask(
    BuildContext context,
    WidgetRef ref, {
    DateTime? initialDate,
    String? initialTagId,
    bool useRootNavigator = false,
  }) async {
    final formData = await AddTaskBottomSheet.show(
      context,
      initialDate: initialDate,
      initialTagId: initialTagId,
      useRootNavigator: useRootNavigator,
    );
    if (formData == null || !context.mounted) return;

    final now = DateTime.now().toUtc();

    Priority parsePriority(String p) {
      switch (p) {
        case 'Low':
          return Priority.low;
        case 'High':
          return Priority.high;
        case 'Critical':
          return Priority.critical;
        case 'Medium':
        default:
          return Priority.medium;
      }
    }

    RepeatRule parseRepeatRule(String r) {
      switch (r) {
        case 'Daily':
          return RepeatRule.daily;
        case 'Weekly':
          return RepeatRule.weekly;
        case 'Monthly':
          return RepeatRule.monthly;
        case 'None':
        default:
          return RepeatRule.none;
      }
    }

    Reminder? generateReminder(String taskId) {
      if (formData.reminder == null) return null;
      final baseDate = formData.dueDate ?? DateTime.now();
      var triggerTime = DateTime(
        baseDate.year,
        baseDate.month,
        baseDate.day,
        formData.reminder!.hour,
        formData.reminder!.minute,
      );
      if (formData.dueDate == null && triggerTime.isBefore(DateTime.now())) {
        triggerTime = triggerTime.add(const Duration(days: 1));
      }
      return Reminder(
        id: const Uuid().v4(),
        taskId: taskId,
        triggerTime: triggerTime,
        repeatRule: parseRepeatRule(formData.repeatRule),
        enabled: true,
      );
    }

    final taskId = const Uuid().v4();

    final task = Task(
      id: taskId,
      title: formData.title,
      description: formData.description,
      status: TaskStatus.pending,
      priority: parsePriority(formData.priority),
      tags: formData.tag != null ? [formData.tag!] : [],
      createdAt: now,
      updatedAt: now,
      dueDate: formData.dueDate,
      completedAt: null,
      reminder: generateReminder(taskId),
      repeatRule: parseRepeatRule(formData.repeatRule),
      position: now.millisecondsSinceEpoch.toDouble(),
      isPinned: formData.isPinned,
      isArchived: false,
      color: formData.color?.value.toRadixString(16) ?? '',
      attachments: const [],
    );

    await ref.read(taskNotifierProvider.notifier).create(task);
    if (!context.mounted) return;

    final state = ref.read(taskNotifierProvider);
    if (state.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to create task')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task created successfully')),
      );
    }
  }
}
