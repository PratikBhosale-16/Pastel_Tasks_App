import 'dart:convert';
import 'package:home_widget/home_widget.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/task_status.dart';
import 'package:pastel_tasks/features/tasks/domain/models/task.dart';
import 'package:pastel_tasks/features/tasks/domain/repositories/task_repository.dart';
import 'package:pastel_tasks/features/tasks/presentation/providers/repository_providers.dart';
import 'package:pastel_tasks/core/result/result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'widget_sync_service.g.dart';

@riverpod
class WidgetSyncService extends _$WidgetSyncService {
  @override
  void build() {
    final taskRepo = ref.watch(taskRepositoryProvider);
    
    final subscription = taskRepo.watchAll().listen((result) {
      if (result is Success<List<Task>>) {
        _syncToWidget(result.value);
      }
    });

    ref.onDispose(() {
      subscription.cancel();
    });
  }

  Future<void> _syncToWidget(List<Task> allTasks) async {
    final activeTasks = allTasks.where((t) => t.status != TaskStatus.archived && !t.isArchived).toList();
    
    // Sort logic for widget - pins first, then by date, etc.
    activeTasks.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      
      final aDate = a.dueDate ?? DateTime(2099);
      final bDate = b.dueDate ?? DateTime(2099);
      return aDate.compareTo(bDate);
    });

    final completedCount = activeTasks.where((t) => t.status == TaskStatus.completed).length;
    final totalCount = activeTasks.length;
    final progressPercent = totalCount == 0 ? 0 : ((completedCount / totalCount) * 100).toInt();

    final widgetTasks = activeTasks.take(15).map((t) => {
      'id': t.id,
      'title': t.title,
      'isCompleted': t.status == TaskStatus.completed,
      'dueTime': t.dueDate?.toIso8601String(),
      'priority': t.priority.index,
      'tag': t.tags.isNotEmpty ? t.tags.first : null,
      'hasReminder': t.reminder != null,
      'isPinned': t.isPinned,
      'isRepeat': t.repeatRule.name != 'none',
      'group': t.status == TaskStatus.completed ? 'Completed' : 'Upcoming'
    }).toList();

    await HomeWidget.saveWidgetData<String>('widget_greeting', _getGreeting());
    await HomeWidget.saveWidgetData<String>('widget_date', _getDate());
    await HomeWidget.saveWidgetData<int>('widget_progress_percent', progressPercent);
    await HomeWidget.saveWidgetData<int>('widget_completed_count', completedCount);
    await HomeWidget.saveWidgetData<int>('widget_total_count', totalCount);
    await HomeWidget.saveWidgetData<String>('widget_tasks', jsonEncode(widgetTasks));

    await HomeWidget.updateWidget(
      name: 'PastelTasksWidgetReceiver',
      androidName: 'widget.PastelTasksWidgetReceiver',
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  String _getDate() {
    final now = DateTime.now();
    final weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    final months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    
    final weekday = weekdays[now.weekday - 1];
    final month = months[now.month - 1];
    return '$weekday, $month ${now.day}';
  }
}
