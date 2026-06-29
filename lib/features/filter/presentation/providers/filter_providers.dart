import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pastel_tasks/core/providers/core_providers.dart';
import 'package:pastel_tasks/features/filter/data/repositories/filter_repository.dart';
import 'package:pastel_tasks/features/filter/domain/models/task_filter.dart';
import 'package:pastel_tasks/features/tasks/domain/models/task.dart';
import 'package:pastel_tasks/features/tasks/presentation/providers/task_providers.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/task_status.dart';

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

      return true;
    }).toList();
  });
});
