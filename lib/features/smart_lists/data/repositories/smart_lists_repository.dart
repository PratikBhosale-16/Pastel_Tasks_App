import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pastel_tasks/features/filter/domain/enums/smart_date_filter.dart';
import 'package:pastel_tasks/features/filter/domain/models/task_filter.dart';
import 'package:pastel_tasks/features/smart_lists/domain/models/smart_list.dart';
import 'package:pastel_tasks/features/sorting/domain/enums/sort_option.dart';
import 'package:pastel_tasks/features/sorting/domain/models/sort_preferences.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/priority.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/repeat_rule.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/task_status.dart';

class SmartListsRepository {
  /// Provides the static definitions of all default Smart Lists.
  List<SmartList> getDefaultSmartLists() {
    return [
      const SmartList(
        id: 'inbox',
        title: 'Inbox',
        icon: Icons.inbox_outlined,
        color: Color(0xFF81D4FA),
        filter: TaskFilter.empty,
      ),
      const SmartList(
        id: 'today',
        title: 'Today',
        icon: Icons.wb_sunny_outlined,
        color: Color(0xFFFFD3B6), // Pastel Peach
        filter: TaskFilter(smartDateFilter: SmartDateFilter.today),
      ),
      const SmartList(
        id: 'tomorrow',
        title: 'Tomorrow',
        icon: Icons.wb_twilight_outlined,
        color: Color(0xFFB8A8FF), // Pastel Lavender
        filter: TaskFilter(smartDateFilter: SmartDateFilter.tomorrow),
      ),
      const SmartList(
        id: 'upcoming',
        title: 'Upcoming',
        icon: Icons.calendar_today_outlined,
        color: Color(0xFFA8E6CF), // Pastel Mint
        filter: TaskFilter(smartDateFilter: SmartDateFilter.upcoming),
      ),
      const SmartList(
        id: 'overdue',
        title: 'Overdue',
        icon: Icons.warning_amber_rounded,
        color: Color(0xFFEF9A9A), // Error Red
        filter: TaskFilter(smartDateFilter: SmartDateFilter.overdue),
      ),
      const SmartList(
        id: 'completed_today',
        title: 'Completed Today',
        icon: Icons.check_circle_outline,
        color: Color(0xFFA5D6A7), // Success Green
        filter: TaskFilter(
          statuses: [TaskStatus.completed],
          smartDateFilter: SmartDateFilter.completedToday,
        ),
      ),
      const SmartList(
        id: 'high_priority',
        title: 'High Priority',
        icon: Icons.priority_high_rounded,
        color: Color(0xFFFFE082), // Warning Yellow
        filter: TaskFilter(priorities: [Priority.high, Priority.critical]),
      ),
      const SmartList(
        id: 'pinned',
        title: 'Pinned',
        icon: Icons.push_pin_outlined,
        color: Color(0xFFB8A8FF),
        filter: TaskFilter(isPinned: true),
      ),
      const SmartList(
        id: 'repeating',
        title: 'Repeating',
        icon: Icons.repeat_rounded,
        color: Color(0xFFA8E6CF),
        filter: TaskFilter(repeatRules: [
          RepeatRule.daily,
          RepeatRule.weekly,
          RepeatRule.monthly,
          RepeatRule.yearly,
        ]),
      ),
      const SmartList(
        id: 'no_due_date',
        title: 'No Due Date',
        icon: Icons.event_busy_outlined,
        color: Color(0xFFE0E0E0),
        filter: TaskFilter(hasDueDate: false),
      ),
      const SmartList(
        id: 'untagged',
        title: 'Untagged',
        icon: Icons.label_off_outlined,
        color: Color(0xFFE0E0E0),
        filter: TaskFilter(hasTags: false),
      ),
      const SmartList(
        id: 'archived',
        title: 'Archived',
        icon: Icons.archive_outlined,
        color: Color(0xFFB0BEC5),
        filter: TaskFilter(isArchived: true),
      ),
    ];
  }
}

final smartListsRepositoryProvider = Provider((ref) => SmartListsRepository());

final smartListsProvider = Provider<List<SmartList>>((ref) {
  return ref.watch(smartListsRepositoryProvider).getDefaultSmartLists();
});
