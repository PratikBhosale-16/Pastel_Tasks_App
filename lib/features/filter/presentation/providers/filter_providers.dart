import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pastel_tasks/core/providers/core_providers.dart';
import 'package:pastel_tasks/features/filter/data/repositories/filter_repository.dart';
import 'package:pastel_tasks/features/filter/domain/models/task_filter.dart';
import 'package:pastel_tasks/features/tasks/domain/models/task.dart';
import 'package:pastel_tasks/features/tasks/presentation/providers/task_providers.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/task_status.dart';
import 'package:pastel_tasks/features/filter/domain/enums/smart_date_filter.dart';

/// Provider for the FilterRepository.
final filterRepositoryProvider = Provider<FilterRepository>((ref) {
  final prefs = ref.watch(preferencesProvider);
  return FilterRepository(prefs);
});

/// Notifier for the active TaskFilter.
class FilterNotifier extends AsyncNotifier<TaskFilter> {
  @override
  Future<TaskFilter> build() async {
    return await ref.watch(filterRepositoryProvider).loadFilter();
  }

  /// Updates the active filter and saves it.
  Future<void> updateFilter(TaskFilter filter) async {
    state = AsyncData(filter);
    await ref.read(filterRepositoryProvider).saveFilter(filter);
  }

  /// Clears all filters.
  Future<void> clearAll() async {
    state = const AsyncData(TaskFilter.empty);
    await ref.read(filterRepositoryProvider).saveFilter(TaskFilter.empty);
  }
}

/// Provider for the active TaskFilter.
final filterProvider = AsyncNotifierProvider<FilterNotifier, TaskFilter>(() {
  return FilterNotifier();
});

/// Provider for the filtered list of tasks.
final filteredTasksProvider = Provider<AsyncValue<List<Task>>>((ref) {
  final tasksAsync = ref.watch(taskListProvider);
  final filterAsync = ref.watch(filterProvider);

  if (filterAsync.isLoading) {
    return const AsyncLoading();
  }
  if (filterAsync.hasError) {
    return AsyncError(filterAsync.error!, filterAsync.stackTrace!);
  }

  final filter = filterAsync.value ?? TaskFilter.empty;

  return tasksAsync.whenData((tasks) {
    return tasks.where((task) {
      // Tags
      if (filter.tags != null && filter.tags!.isNotEmpty) {
        final hasAnyTag = filter.tags!.any((t) => task.tags.contains(t));
        if (!hasAnyTag) return false;
      }
      
      // HasTags boolean check
      if (filter.hasTags != null) {
        if (task.tags.isEmpty == filter.hasTags) return false;
      }

      // Priorities
      if (filter.priorities != null && filter.priorities!.isNotEmpty) {
        if (!filter.priorities!.contains(task.priority)) return false;
      }

      // Statuses
      if (filter.statuses != null && filter.statuses!.isNotEmpty) {
        if (!filter.statuses!.contains(task.status)) return false;
      }

      // Pinned
      if (filter.isPinned != null) {
        if (task.isPinned != filter.isPinned) return false;
      }

      // Due Date (simple boolean check for now, can be expanded to ranges)
      if (filter.hasDueDate != null) {
        final taskHasDueDate = task.dueDate != null;
        if (taskHasDueDate != filter.hasDueDate) return false;
      }

      // Reminder
      if (filter.hasReminder != null) {
        final taskHasReminder = task.reminder != null;
        if (taskHasReminder != filter.hasReminder) return false;
      }

      // Repeat Rules
      if (filter.repeatRules != null && filter.repeatRules!.isNotEmpty) {
        if (!filter.repeatRules!.contains(task.repeatRule)) return false;
      }

      // Colors
      if (filter.colors != null && filter.colors!.isNotEmpty) {
        if (!filter.colors!.contains(task.color)) return false;
      }

      // Completed
      if (filter.isCompleted != null) {
        final taskIsCompleted = task.status == TaskStatus.completed;
        if (taskIsCompleted != filter.isCompleted) return false;
      }

      // Archived
      if (filter.isArchived != null) {
        if (task.isArchived != filter.isArchived) return false;
      } else {
        // By default, hide archived tasks from the general filtered view
        if (task.isArchived) return false;
      }

      // Smart Date Filters
      if (filter.smartDateFilter != null) {
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final tomorrow = today.add(const Duration(days: 1));
        
        switch (filter.smartDateFilter!) {
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
        }
      }

      return true;
    }).toList();
  });
});
