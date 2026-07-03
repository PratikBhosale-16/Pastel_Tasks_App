import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/repeat_rule.dart';
import 'package:pastel_tasks/features/tasks/domain/models/task.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/task_status.dart';
import 'package:pastel_tasks/features/tasks/presentation/providers/task_providers.dart';
import 'package:pastel_tasks/features/settings/presentation/providers/settings_provider.dart';

/// The date currently selected by the user in the calendar.
final selectedDateProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
});

/// The month currently being viewed in the calendar.
final viewingMonthProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, 1);
});

/// A helper to check if a task falls on a specific date, including repeat logic.
bool _doesTaskOccurOnDate(Task task, DateTime targetDate) {
  if (task.dueDate == null) return false;

  final taskDate =
      DateTime(task.dueDate!.year, task.dueDate!.month, task.dueDate!.day);
  final target = DateTime(targetDate.year, targetDate.month, targetDate.day);

  if (target.isBefore(taskDate)) return false;

  if (target.isAtSameMomentAs(taskDate)) return true;

  switch (task.repeatRule) {
    case RepeatRule.none:
      return false;
    case RepeatRule.daily:
      return true;
    case RepeatRule.weekly:
      return target.weekday == taskDate.weekday;
    case RepeatRule.monthly:
      return target.day == taskDate.day;
    case RepeatRule.yearly:
      return target.month == taskDate.month && target.day == taskDate.day;
  }
}

/// Provides all tasks that occur in the currently viewing month.
/// This projects repeating tasks onto all their occurrences in the month.
final monthTasksProvider = Provider<Map<DateTime, List<Task>>>((ref) {
  final allTasksAsync = ref.watch(taskListProvider);
  final showCompletedAsync = ref.watch(settingSwitchProvider(calendarShowCompletedSwitch));
  final showCompleted = showCompletedAsync.value ?? false;
  final tasks = (allTasksAsync.value ?? [])
      .where((t) => !t.isArchived && (showCompleted || t.status != TaskStatus.completed))
      .toList();
  final viewingMonth = ref.watch(viewingMonthProvider);

  final map = <DateTime, List<Task>>{};

  // Iterate over all days in the viewing month
  final daysInMonth = DateTime(viewingMonth.year, viewingMonth.month + 1, 0).day;

  for (int day = 1; day <= daysInMonth; day++) {
    final date = DateTime(viewingMonth.year, viewingMonth.month, day);
    final dayTasks = tasks.where((t) => _doesTaskOccurOnDate(t, date)).toList();
    if (dayTasks.isNotEmpty) {
      map[date] = dayTasks;
    }
  }

  return map;
});

/// Provides the sorted list of tasks for the currently selected date in the agenda.
final agendaTasksProvider = Provider<List<Task>>((ref) {
  final selectedDate = ref.watch(selectedDateProvider);
  final allTasksAsync = ref.watch(taskListProvider);
  final showCompletedAsync = ref.watch(settingSwitchProvider(calendarShowCompletedSwitch));
  final showCompleted = showCompletedAsync.value ?? false;
  final tasks = (allTasksAsync.value ?? [])
      .where((t) => !t.isArchived && (showCompleted || t.status != TaskStatus.completed))
      .toList();

  final dayTasks = tasks.where((t) => _doesTaskOccurOnDate(t, selectedDate)).toList();

  dayTasks.sort((a, b) {
    // Pinned tasks first
    if (a.isPinned && !b.isPinned) return -1;
    if (!a.isPinned && b.isPinned) return 1;

    // 1. Reminder time (if any)
    if (a.reminder != null && b.reminder != null) {
      final aRem = a.reminder!.triggerTime;
      final bRem = b.reminder!.triggerTime;
      final aRemDT = DateTime(0, 1, 1, aRem.hour, aRem.minute);
      final bRemDT = DateTime(0, 1, 1, bRem.hour, bRem.minute);
      final cmp = aRemDT.compareTo(bRemDT);
      if (cmp != 0) return cmp;
    } else if (a.reminder != null && b.reminder == null) {
      return -1;
    } else if (a.reminder == null && b.reminder != null) {
      return 1;
    }

    // 2. Due Time (if any)
    if (a.dueDate != null && b.dueDate != null) {
      final aDueTime = DateTime(0, 1, 1, a.dueDate!.hour, a.dueDate!.minute);
      final bDueTime = DateTime(0, 1, 1, b.dueDate!.hour, b.dueDate!.minute);
      final cmp = aDueTime.compareTo(bDueTime);
      if (cmp != 0) return cmp;
    }

    // 3. Priority (Critical > High > Medium > Low)
    // Priority enum is low, medium, high, critical.
    // So we want descending order of index.
    return b.priority.index.compareTo(a.priority.index);
  });

  return dayTasks;
});
