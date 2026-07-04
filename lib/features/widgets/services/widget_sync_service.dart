import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';
import 'package:isar/isar.dart';
import 'package:pastel_tasks/core/providers/core_providers.dart';
import 'package:pastel_tasks/infrastructure/database/isar/collections/task_collection.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/task_status.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/repeat_rule.dart';

class WidgetSyncService {
  final Isar _isar;

  WidgetSyncService(this._isar);

  Future<void> syncAllWidgets() async {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(const Duration(days: 1));

    // 1. Fetch Today's Tasks
    final todaysTasks = await _isar.taskCollections.filter()
        .statusEqualTo(TaskStatus.pending)
        .dueDateBetween(todayStart, todayEnd)
        .sortByPriorityDesc()
        .limit(5)
        .findAll();

    final todaysTasksJson = jsonEncode(todaysTasks.map((t) => {
      'id': t.uuid,
      'title': t.title,
      'priority': t.priority.index,
      'dueDate': t.dueDate?.millisecondsSinceEpoch,
      'hasReminder': t.reminderId != null,
      'isRepeat': t.repeatRule != RepeatRule.none,
      'isPinned': t.isPinned,
      'tags': t.tags.toList(),
    }).toList());

    // 2. Fetch Upcoming Tasks (Next 5 tasks after today)
    final upcomingTasks = await _isar.taskCollections.filter()
        .statusEqualTo(TaskStatus.pending)
        .dueDateGreaterThan(todayEnd)
        .sortByDueDate()
        .limit(5)
        .findAll();

    final upcomingTasksJson = jsonEncode(upcomingTasks.map((t) => {
      'id': t.uuid,
      'title': t.title,
      'priority': t.priority.index,
      'dueDate': t.dueDate?.millisecondsSinceEpoch,
      'hasReminder': t.reminderId != null,
      'isRepeat': t.repeatRule != RepeatRule.none,
      'isPinned': t.isPinned,
      'tags': t.tags.toList(),
    }).toList());

    // 3. Progress Widget Data
    final allTodayTasks = await _isar.taskCollections.filter()
        .dueDateBetween(todayStart, todayEnd)
        .findAll();
    
    final todayCompleted = allTodayTasks.where((t) => t.status == TaskStatus.completed).length;
    final todayTotal = allTodayTasks.length;

    try {
      await HomeWidget.saveWidgetData('todays_tasks', todaysTasksJson);
      await HomeWidget.saveWidgetData('upcoming_tasks', upcomingTasksJson);
      await HomeWidget.saveWidgetData('progress_completed', todayCompleted);
      await HomeWidget.saveWidgetData('progress_total', todayTotal);
    } on Exception {
      // Ignore in tests
    }

    // 4. Smart Lists Counts
    final overdueCount = await _isar.taskCollections.filter()
        .statusEqualTo(TaskStatus.pending)
        .dueDateLessThan(todayStart)
        .count();
        
    try {
      await HomeWidget.saveWidgetData('count_today', allTodayTasks.where((t) => t.status == TaskStatus.pending).length);
      await HomeWidget.saveWidgetData('count_overdue', overdueCount);
    } on Exception {
      // Ignore in tests
    }

    // 5. Trigger Updates for Responsive Widget
    try {
      await HomeWidget.updateWidget(androidName: 'ResponsiveWidgetProvider');
    } on Exception {
      // Ignore for tests
    }
  }

  void listenToChanges() {
    _isar.taskCollections.watchLazy().listen((_) {
      syncAllWidgets();
    });
  }
}

final widgetSyncServiceProvider = Provider<WidgetSyncService>((ref) {
  final isar = ref.watch(databaseProvider).instanceOrThrow;
  final service = WidgetSyncService(isar);
  service.listenToChanges();
  return service;
});
