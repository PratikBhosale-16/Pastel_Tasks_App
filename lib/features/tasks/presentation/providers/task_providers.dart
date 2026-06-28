import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pastel_tasks/core/errors/failure.dart';
import 'package:pastel_tasks/core/result/result.dart';
import 'package:pastel_tasks/features/tasks/domain/models/task.dart';
import 'package:pastel_tasks/features/tasks/presentation/providers/repository_providers.dart';

/// Streams the full list of all tasks.
final taskListProvider = StreamProvider<List<Task>>((ref) async* {
  final repository = ref.watch(taskRepositoryProvider);
  await for (final result in repository.watchAll()) {
    if (result is Success<List<Task>>) {
      yield result.value;
    } else if (result is Failure<List<Task>>) {
      throw result.exception;
    }
  }
});

/// Streams a specific task by its ID.
final taskProvider = StreamProvider.family<Task?, String>((ref, id) async* {
  final repository = ref.watch(taskRepositoryProvider);
  await for (final result in repository.watchTask(id)) {
    if (result is Success<Task?>) {
      yield result.value;
    } else if (result is Failure<Task?>) {
      throw result.exception;
    }
  }
});

/// Provides the list of completed tasks.
final completedTasksProvider = FutureProvider<List<Task>>((ref) async {
  final repository = ref.watch(taskRepositoryProvider);
  final result = await repository.getCompleted();
  if (result is Success<List<Task>>) return result.value;
  throw (result as Failure).exception;
});

/// Provides the list of archived tasks.
final archivedTasksProvider = FutureProvider<List<Task>>((ref) async {
  final repository = ref.watch(taskRepositoryProvider);
  final result = await repository.getArchived();
  if (result is Success<List<Task>>) return result.value;
  throw (result as Failure).exception;
});

/// Provides the list of pinned tasks.
final pinnedTasksProvider = FutureProvider<List<Task>>((ref) async {
  // Uses taskListProvider stream to filter in-memory for reactivity
  final tasks = await ref.watch(taskListProvider.future);
  return tasks.where((t) => t.isPinned && !t.isArchived).toList();
});

/// Provides the list of overdue tasks.
final overdueTasksProvider = FutureProvider<List<Task>>((ref) async {
  final repository = ref.watch(taskRepositoryProvider);
  final result = await repository.getOverdue();
  if (result is Success<List<Task>>) return result.value;
  throw (result as Failure).exception;
});

/// Provides tasks due today.
final todayTasksProvider = FutureProvider<List<Task>>((ref) async {
  final repository = ref.watch(taskRepositoryProvider);
  final now = DateTime.now();
  final result = await repository.getByDueDate(now);
  if (result is Success<List<Task>>) return result.value;
  throw (result as Failure).exception;
});

/// Provides tasks upcoming (after today).
final upcomingTasksProvider = FutureProvider<List<Task>>((ref) async {
  final tasks = await ref.watch(taskListProvider.future);
  final now = DateTime.now();
  final endOfToday = DateTime(now.year, now.month, now.day, 23, 59, 59);
  return tasks.where((t) => t.dueDate != null && t.dueDate!.isAfter(endOfToday) && !t.isArchived).toList();
});

/// Provides a search filtering on tasks.
final searchTasksProvider = FutureProvider.family<List<Task>, String>((ref, query) async {
  final repository = ref.watch(taskRepositoryProvider);
  final result = await repository.search(query);
  if (result is Success<List<Task>>) return result.value;
  throw (result as Failure).exception;
});
