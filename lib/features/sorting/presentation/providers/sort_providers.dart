import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pastel_tasks/core/providers/core_providers.dart';
import 'package:pastel_tasks/features/search/presentation/providers/search_providers.dart';
import 'package:pastel_tasks/features/sorting/data/repositories/sort_repository.dart';
import 'package:pastel_tasks/features/sorting/domain/enums/sort_option.dart';
import 'package:pastel_tasks/features/sorting/domain/enums/sort_order.dart';
import 'package:pastel_tasks/features/sorting/domain/models/sort_preferences.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/task_status.dart';
import 'package:pastel_tasks/features/tasks/domain/models/task.dart';

/// Provides the SortRepository.
final sortRepositoryProvider = Provider<SortRepository>((ref) {
  return SortRepository(ref.watch(preferencesProvider));
});

/// Manages the active sort preferences.
final sortPreferencesProvider = NotifierProvider<SortNotifier, SortPreferences>(
  SortNotifier.new,
);

class SortNotifier extends Notifier<SortPreferences> {
  @override
  SortPreferences build() {
    _loadPreferences();
    return const SortPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await ref.read(sortRepositoryProvider).loadPreferences();
    state = prefs;
  }

  Future<void> setSortOption(TaskSortOption option) async {
    final newPrefs = state.copyWith(option: option);
    state = newPrefs;
    await ref.read(sortRepositoryProvider).savePreferences(newPrefs);
  }

  Future<void> setSortOrder(TaskSortOrder order) async {
    final newPrefs = state.copyWith(order: order);
    state = newPrefs;
    await ref.read(sortRepositoryProvider).savePreferences(newPrefs);
  }

  Future<void> reset() async {
    const newPrefs = SortPreferences();
    state = newPrefs;
    await ref.read(sortRepositoryProvider).savePreferences(newPrefs);
  }
}

/// Provides the fully filtered, searched, and sorted list of tasks.
final sortedTasksProvider = Provider<AsyncValue<List<Task>>>((ref) {
  final searchedTasksAsync = ref.watch(searchedTasksProvider);
  final sortPrefs = ref.watch(sortPreferencesProvider);

  return searchedTasksAsync.whenData((tasks) {
    if (sortPrefs.option == TaskSortOption.manual) {
      // Manual sorting respects the original ordering (which is already position-based in Isar).
      // However, we should ensure they are sorted by position just in case.
      final manualSorted = List<Task>.from(tasks)
        ..sort((a, b) => a.position.compareTo(b.position));
      
      // If we need to reverse for some reason (usually manual doesn't use descending, but just in case)
      if (sortPrefs.order == TaskSortOrder.descending) {
        return manualSorted.reversed.toList();
      }
      return manualSorted;
    }

    final sorted = List<Task>.from(tasks);
    final isAscending = sortPrefs.order == TaskSortOrder.ascending;

    sorted.sort((a, b) {
      int comparison = 0;

      switch (sortPrefs.option) {
        case TaskSortOption.createdDate:
          comparison = a.createdAt.compareTo(b.createdAt);
          break;
        case TaskSortOption.updatedDate:
          comparison = a.updatedAt.compareTo(b.updatedAt);
          break;
        case TaskSortOption.dueDate:
          if (a.dueDate == null && b.dueDate == null) {
            comparison = 0;
          } else if (a.dueDate == null) {
            comparison = 1; // nulls last
          } else if (b.dueDate == null) {
            comparison = -1;
          } else {
            comparison = a.dueDate!.compareTo(b.dueDate!);
          }
          break;
        case TaskSortOption.reminderDate:
          if (a.reminder == null && b.reminder == null) {
            comparison = 0;
          } else if (a.reminder == null) {
            comparison = 1;
          } else if (b.reminder == null) {
            comparison = -1;
          } else {
            comparison = a.reminder!.triggerTime.compareTo(b.reminder!.triggerTime);
          }
          break;
        case TaskSortOption.priority:
          comparison = a.priority.index.compareTo(b.priority.index);
          break;
        case TaskSortOption.alphabetical:
          comparison = a.title.toLowerCase().compareTo(b.title.toLowerCase());
          break;
        case TaskSortOption.pinnedFirst:
          if (a.isPinned == b.isPinned) {
            comparison = 0;
          } else if (a.isPinned) {
            comparison = -1;
          } else {
            comparison = 1;
          }
          break;
        case TaskSortOption.completedLast:
          final aIsCompleted = a.status == TaskStatus.completed;
          final bIsCompleted = b.status == TaskStatus.completed;
          if (aIsCompleted == bIsCompleted) {
            comparison = 0;
          } else if (aIsCompleted) {
            comparison = 1;
          } else {
            comparison = -1;
          }
          break;
        case TaskSortOption.color:
          comparison = a.color.compareTo(b.color);
          break;
        case TaskSortOption.tag:
          final aTag = a.tags.isNotEmpty ? a.tags.first.toLowerCase() : '';
          final bTag = b.tags.isNotEmpty ? b.tags.first.toLowerCase() : '';
          comparison = aTag.compareTo(bTag);
          break;
        case TaskSortOption.repeat:
          comparison = a.repeatRule.index.compareTo(b.repeatRule.index);
          break;
        case TaskSortOption.manual:
          // Handled above.
          break;
      }

      // If comparison is equal, fallback to manual position to maintain stability
      if (comparison == 0) {
        return a.position.compareTo(b.position);
      }

      return isAscending ? comparison : -comparison;
    });

    return sorted;
  });
});
