import 'package:equatable/equatable.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/priority.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/repeat_rule.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/task_status.dart';
import 'package:pastel_tasks/features/filter/domain/enums/smart_date_filter.dart';

/// Represents a set of filtering criteria for tasks.
class TaskFilter extends Equatable {
  const TaskFilter({
    this.tags,
    this.priorities,
    this.statuses,
    this.isPinned,
    this.hasDueDate,
    this.hasReminder,
    this.repeatRules,
    this.colors,
    this.isArchived,
    this.isCompleted,
    this.smartDateFilter,
    this.hasTags,
  });

  /// Specific tags to filter by. If empty or null, matches all tags.
  final List<String>? tags;

  /// Whether the task has any tags.
  final bool? hasTags;

  /// Specific priorities to filter by.
  final List<Priority>? priorities;

  /// Specific statuses to filter by.
  final List<TaskStatus>? statuses;

  /// Filter by pinned status.
  final bool? isPinned;

  /// Filter by whether the task has a due date.
  final bool? hasDueDate;

  /// Filter by whether the task has a reminder.
  final bool? hasReminder;

  /// Specific repeat rules to filter by.
  final List<RepeatRule>? repeatRules;

  /// Specific custom colors to filter by.
  final List<String>? colors;

  /// Filter by archived status. Default is usually false for active views.
  final bool? isArchived;

  /// Filter by completion status (shorthand for checking TaskStatus.completed).
  final bool? isCompleted;

  /// Dynamic filter for relative dates (e.g. today, overdue).
  final SmartDateFilter? smartDateFilter;

  /// Creates a copy of this filter with the given fields replaced with the new values.
  TaskFilter copyWith({
    List<String>? tags,
    List<Priority>? priorities,
    List<TaskStatus>? statuses,
    bool? isPinned,
    bool? hasDueDate,
    bool? hasReminder,
    List<RepeatRule>? repeatRules,
    List<String>? colors,
    bool? isArchived,
    bool? isCompleted,
    bool? hasTags,
    bool clearTags = false,
    bool clearPriorities = false,
    bool clearStatuses = false,
    bool clearPinned = false,
    bool clearDueDate = false,
    bool clearReminder = false,
    bool clearRepeatRules = false,
    bool clearColors = false,
    bool clearArchived = false,
    bool clearCompleted = false,
    bool clearSmartDate = false,
    bool clearHasTags = false,
    SmartDateFilter? smartDateFilter,
  }) {
    return TaskFilter(
      tags: clearTags ? null : tags ?? this.tags,
      priorities: clearPriorities ? null : priorities ?? this.priorities,
      statuses: clearStatuses ? null : statuses ?? this.statuses,
      isPinned: clearPinned ? null : isPinned ?? this.isPinned,
      hasDueDate: clearDueDate ? null : hasDueDate ?? this.hasDueDate,
      hasReminder: clearReminder ? null : hasReminder ?? this.hasReminder,
      repeatRules: clearRepeatRules ? null : repeatRules ?? this.repeatRules,
      colors: clearColors ? null : colors ?? this.colors,
      isArchived: clearArchived ? null : isArchived ?? this.isArchived,
      isCompleted: clearCompleted ? null : isCompleted ?? this.isCompleted,
      smartDateFilter: clearSmartDate ? null : smartDateFilter ?? this.smartDateFilter,
      hasTags: clearHasTags ? null : hasTags ?? this.hasTags,
    );
  }

  /// Converts this filter to a JSON map for persistence.
  Map<String, dynamic> toJson() {
    return {
      'tags': tags,
      'priorities': priorities?.map((e) => e.name).toList(),
      'statuses': statuses?.map((e) => e.name).toList(),
      'isPinned': isPinned,
      'hasDueDate': hasDueDate,
      'hasReminder': hasReminder,
      'repeatRules': repeatRules?.map((e) => e.name).toList(),
      'colors': colors,
      'isArchived': isArchived,
      'isCompleted': isCompleted,
      'smartDateFilter': smartDateFilter?.name,
      'hasTags': hasTags,
    };
  }

  /// Creates a filter from a JSON map.
  factory TaskFilter.fromJson(Map<String, dynamic> json) {
    return TaskFilter(
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      priorities: (json['priorities'] as List<dynamic>?)
          ?.map((e) => Priority.values.firstWhere((p) => p.name == e))
          .toList(),
      statuses: (json['statuses'] as List<dynamic>?)
          ?.map((e) => TaskStatus.values.firstWhere((s) => s.name == e))
          .toList(),
      isPinned: json['isPinned'] as bool?,
      hasDueDate: json['hasDueDate'] as bool?,
      hasReminder: json['hasReminder'] as bool?,
      repeatRules: (json['repeatRules'] as List<dynamic>?)
          ?.map((e) => RepeatRule.values.firstWhere((r) => r.name == e))
          .toList(),
      colors: (json['colors'] as List<dynamic>?)?.map((e) => e as String).toList(),
      isArchived: json['isArchived'] as bool?,
      isCompleted: json['isCompleted'] as bool?,
      smartDateFilter: json['smartDateFilter'] != null
          ? SmartDateFilter.values.firstWhere((e) => e.name == json['smartDateFilter'])
          : null,
      hasTags: json['hasTags'] as bool?,
    );
  }

  /// Returns an empty filter (all nulls).
  static const empty = TaskFilter();

  /// Evaluates whether a given task matches this filter.
  bool matches(dynamic taskObj) {
    final task = taskObj; // Assuming passed object has the task properties
    
    // Tags
    if (tags != null && tags!.isNotEmpty) {
      final hasAnyTag = tags!.any((t) => (task.tags as List).contains(t));
      if (!hasAnyTag) return false;
    }
    
    // HasTags boolean check
    if (hasTags != null) {
      if ((task.tags as List).isEmpty == hasTags) return false;
    }

    // Priorities
    if (priorities != null && priorities!.isNotEmpty) {
      if (!priorities!.contains(task.priority)) return false;
    }

    // Statuses
    if (statuses != null && statuses!.isNotEmpty) {
      bool statusMatch = statuses!.contains(task.status);
      if (statuses!.contains(TaskStatus.archived) && task.isArchived) {
        statusMatch = true;
      }
      if (!statusMatch) return false;
    }

    // Pinned
    if (isPinned != null) {
      if (task.isPinned != isPinned) return false;
    }

    // Due Date
    if (hasDueDate != null) {
      final taskHasDueDate = task.dueDate != null;
      if (taskHasDueDate != hasDueDate) return false;
    }

    // Reminder
    if (hasReminder != null) {
      final taskHasReminder = task.reminder != null;
      if (taskHasReminder != hasReminder) return false;
    }

    // Repeat Rules
    if (repeatRules != null && repeatRules!.isNotEmpty) {
      if (!repeatRules!.contains(task.repeatRule)) return false;
    }

    // Colors
    if (colors != null && colors!.isNotEmpty) {
      if (!colors!.contains(task.color)) return false;
    }

    // Completed
    if (isCompleted != null) {
      final taskIsCompleted = task.status == TaskStatus.completed;
      if (taskIsCompleted != isCompleted) return false;
    }

    // Archived
    if (isArchived != null) {
      if (task.isArchived != isArchived) return false;
    } else {
      final isFilteringByArchivedStatus = statuses?.contains(TaskStatus.archived) ?? false;
      if (task.isArchived && !isFilteringByArchivedStatus) {
        return false;
      }
    }

    // Smart Date Filters
    if (smartDateFilter != null) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final tomorrow = today.add(const Duration(days: 1));
      
      switch (smartDateFilter!) {
        case SmartDateFilter.today:
          if (task.dueDate == null) return false;
          final taskDate = DateTime(task.dueDate!.year, task.dueDate!.month, task.dueDate!.day);
          if (taskDate != today) return false;
          break;
        case SmartDateFilter.tomorrow:
          if (task.dueDate == null) return false;
          final taskDate = DateTime(task.dueDate!.year, task.dueDate!.month, task.dueDate!.day);
          if (taskDate != tomorrow) return false;
          break;
        case SmartDateFilter.upcoming:
          if (task.dueDate == null) return false;
          final taskDate = DateTime(task.dueDate!.year, task.dueDate!.month, task.dueDate!.day);
          if (!taskDate.isAfter(today)) return false;
          break;
        case SmartDateFilter.overdue:
          if (task.dueDate == null) return false;
          if (task.status == TaskStatus.completed) return false;
          final taskDate = DateTime(task.dueDate!.year, task.dueDate!.month, task.dueDate!.day);
          if (!taskDate.isBefore(today)) return false;
          break;
        case SmartDateFilter.completedToday:
          if (task.status != TaskStatus.completed) return false;
          if (task.completedAt == null) return false;
          final compDate = DateTime(task.completedAt!.year, task.completedAt!.month, task.completedAt!.day);
          if (compDate != today) return false;
          break;
        case SmartDateFilter.thisWeek:
          if (task.dueDate == null) return false;
          final taskDate = DateTime(task.dueDate!.year, task.dueDate!.month, task.dueDate!.day);
          // Assuming week starts on Monday
          final weekStart = today.subtract(Duration(days: today.weekday - 1));
          final weekEnd = weekStart.add(const Duration(days: 6));
          if (taskDate.isBefore(weekStart) || taskDate.isAfter(weekEnd)) return false;
          break;
        case SmartDateFilter.thisMonth:
          if (task.dueDate == null) return false;
          if (task.dueDate!.year != today.year || task.dueDate!.month != today.month) return false;
          break;
      }
    }

    return true;
  }

  /// Checks if this filter has any active criteria (ignoring default isArchived).
  bool get hasActiveFilters {
    return (tags?.isNotEmpty ?? false) ||
        (priorities?.isNotEmpty ?? false) ||
        (statuses?.isNotEmpty ?? false) ||
        isPinned != null ||
        hasDueDate != null ||
        hasReminder != null ||
        (repeatRules?.isNotEmpty ?? false) ||
        (colors?.isNotEmpty ?? false) ||
        isCompleted != null ||
        isArchived != null ||
        smartDateFilter != null ||
        hasTags != null;
  }

  @override
  List<Object?> get props => [
        tags,
        priorities,
        statuses,
        isPinned,
        hasDueDate,
        hasReminder,
        repeatRules,
        colors,
        isArchived,
        isCompleted,
        smartDateFilter,
        hasTags,
      ];
}
