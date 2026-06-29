import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pastel_tasks/features/filter/presentation/providers/filter_providers.dart';
import 'package:pastel_tasks/features/tasks/domain/models/task.dart';

/// Provider for the debounced search query.
final debouncedSearchQueryProvider = StateProvider<String>((ref) => '');

/// Notifier to manage the raw search query and update the debounced query after a delay.
class SearchQueryNotifier extends Notifier<String> {
  Timer? _timer;

  @override
  String build() {
    ref.onDispose(() {
      _timer?.cancel();
    });
    return '';
  }

  void setQuery(String query) {
    if (state == query) return;
    state = query;
    
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 300), () {
      ref.read(debouncedSearchQueryProvider.notifier).state = query;
    });
  }

  void clear() {
    state = '';
    _timer?.cancel();
    ref.read(debouncedSearchQueryProvider.notifier).state = '';
  }
}

/// Provider for the raw search query.
final searchQueryProvider = NotifierProvider<SearchQueryNotifier, String>(() {
  return SearchQueryNotifier();
});

/// Provider that filters the already-filtered tasks based on the debounced search query.
final searchedTasksProvider = Provider<AsyncValue<List<Task>>>((ref) {
  final filteredTasksAsync = ref.watch(filteredTasksProvider);
  final searchQuery = ref.watch(debouncedSearchQueryProvider).trim().toLowerCase();

  if (searchQuery.isEmpty) {
    return filteredTasksAsync;
  }

  return filteredTasksAsync.whenData((tasks) {
    return tasks.where((task) {
      // 1. Title
      if (task.title.toLowerCase().contains(searchQuery)) return true;
      
      // 2. Description
      if (task.description != null && task.description!.toLowerCase().contains(searchQuery)) return true;
      
      // 3. Tags
      if (task.tags.any((tag) => tag.toLowerCase().contains(searchQuery))) return true;
      
      // 4. Repeat Rule
      if (task.repeatRule.name.toLowerCase().contains(searchQuery)) return true;
      
      // 5. Reminder Text
      if (task.reminder != null) {
        final reminderStr = DateFormat.yMMMd().add_jm().format(task.reminder!.triggerTime).toLowerCase();
        if (reminderStr.contains(searchQuery)) return true;
      }
      
      // 6. Due Date Text
      if (task.dueDate != null) {
        final dueStr = DateFormat.yMMMd().format(task.dueDate!).toLowerCase();
        if (dueStr.contains(searchQuery)) return true;
      }
      
      return false;
    }).toList();
  });
});
