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

    // Helper to map tasks to JSON
    List<Map<String, dynamic>> mapTasks(List<TaskCollection> tasks) {
      return tasks.map((t) => {
        'id': t.uuid,
        'title': t.title,
        'priority': t.priority.index,
        'dueDate': t.dueDate?.millisecondsSinceEpoch,
        'hasReminder': t.reminderId != null,
        'isRepeat': t.repeatRule != RepeatRule.none,
        'isPinned': t.isPinned,
        'status': t.status.index,
        'tags': t.tags.toList(),
      }).toList();
    }

    // 1. Fetch Today's Tasks
    final todaysTasks = await _isar.taskCollections.filter()
        .statusEqualTo(TaskStatus.pending)
        .dueDateBetween(todayStart, todayEnd)
        .sortByPriorityDesc()
        .limit(10)
        .findAll();

    // 2. Fetch Upcoming Tasks
    final upcomingTasks = await _isar.taskCollections.filter()
        .statusEqualTo(TaskStatus.pending)
        .dueDateGreaterThan(todayEnd)
        .sortByDueDate()
        .limit(10)
        .findAll();

    // 3. Fetch Completed Today
    final completedToday = await _isar.taskCollections.filter()
        .statusEqualTo(TaskStatus.completed)
        .updatedAtBetween(todayStart, todayEnd)
        .sortByUpdatedAtDesc()
        .limit(10)
        .findAll();

    // 4. Fetch Pinned Tasks
    final pinnedTasks = await _isar.taskCollections.filter()
        .statusEqualTo(TaskStatus.pending)
        .isPinnedEqualTo(true)
        .sortByPriorityDesc()
        .limit(10)
        .findAll();

    // 5. Fetch Overdue Tasks
    final overdueTasks = await _isar.taskCollections.filter()
        .statusEqualTo(TaskStatus.pending)
        .dueDateLessThan(todayStart)
        .sortByDueDate()
        .limit(10)
        .findAll();

    // 6. Progress Widget Data
    final allTodayTasks = await _isar.taskCollections.filter()
        .dueDateBetween(todayStart, todayEnd)
        .findAll();
    
    final todayCompleted = allTodayTasks.where((t) => t.status == TaskStatus.completed).length;
    final todayTotal = allTodayTasks.length;

    try {
      await HomeWidget.saveWidgetData('todays_tasks', jsonEncode(mapTasks(todaysTasks)));
      await HomeWidget.saveWidgetData('upcoming_tasks', jsonEncode(mapTasks(upcomingTasks)));
      await HomeWidget.saveWidgetData('completed_tasks', jsonEncode(mapTasks(completedToday)));
      await HomeWidget.saveWidgetData('pinned_tasks', jsonEncode(mapTasks(pinnedTasks)));
      await HomeWidget.saveWidgetData('overdue_tasks', jsonEncode(mapTasks(overdueTasks)));
      
      await HomeWidget.saveWidgetData('progress_completed', todayCompleted);
      await HomeWidget.saveWidgetData('progress_total', todayTotal);
      await HomeWidget.saveWidgetData('count_today', allTodayTasks.where((t) => t.status == TaskStatus.pending).length);
      await HomeWidget.saveWidgetData('count_overdue', overdueTasks.length);
      
      // We will only update our new unified WidgetProvider
      await HomeWidget.updateWidget(androidName: 'WidgetProvider');
    } on Exception {
      // Ignore in tests
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
