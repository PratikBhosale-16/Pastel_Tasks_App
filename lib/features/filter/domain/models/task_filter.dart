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
