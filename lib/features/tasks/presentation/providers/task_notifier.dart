import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pastel_tasks/core/errors/failure.dart';
import 'package:pastel_tasks/features/tasks/domain/models/task.dart';
import 'package:pastel_tasks/features/tasks/presentation/providers/repository_providers.dart';

/// Notifier handling task state mutations.
class TaskNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  /// Creates a task.
  Future<void> create(Task task) async {
    state = const AsyncLoading();
    final repo = ref.read(taskRepositoryProvider);
    final result = await repo.create(task);
    if (result is Failure) {
      state = AsyncError(result.exception, StackTrace.current);
    } else {
      state = const AsyncData(null);
    }
  }

  /// Updates a task.
  Future<void> updateTask(Task task) async {
    state = const AsyncLoading();
    final repo = ref.read(taskRepositoryProvider);
    final result = await repo.update(task);
    if (result is Failure) {
      state = AsyncError(result.exception, StackTrace.current);
    } else {
      state = const AsyncData(null);
    }
  }

  /// Deletes a task.
  Future<void> delete(String id) async {
    state = const AsyncLoading();
    final repo = ref.read(taskRepositoryProvider);
    final result = await repo.delete(id);
    if (result is Failure) {
      state = AsyncError(result.exception, StackTrace.current);
    } else {
      state = const AsyncData(null);
    }
  }

  /// Archives a task.
  Future<void> archive(String id) async {
    state = const AsyncLoading();
    final repo = ref.read(taskRepositoryProvider);
    final result = await repo.archive(id);
    if (result is Failure) {
      state = AsyncError(result.exception, StackTrace.current);
    } else {
      state = const AsyncData(null);
    }
  }

  /// Restores a task.
  Future<void> restore(String id) async {
    state = const AsyncLoading();
    final repo = ref.read(taskRepositoryProvider);
    final result = await repo.restore(id);
    if (result is Failure) {
      state = AsyncError(result.exception, StackTrace.current);
    } else {
      state = const AsyncData(null);
    }
  }

  /// Pins a task.
  Future<void> pin(String id) async {
    state = const AsyncLoading();
    final repo = ref.read(taskRepositoryProvider);
    final result = await repo.pin(id);
    if (result is Failure) {
      state = AsyncError(result.exception, StackTrace.current);
    } else {
      state = const AsyncData(null);
    }
  }

  /// Unpins a task.
  Future<void> unpin(String id) async {
    state = const AsyncLoading();
    final repo = ref.read(taskRepositoryProvider);
    final result = await repo.unpin(id);
    if (result is Failure) {
      state = AsyncError(result.exception, StackTrace.current);
    } else {
      state = const AsyncData(null);
    }
  }

  /// Reorders tasks.
  Future<void> reorder(List<String> ids) async {
    state = const AsyncLoading();
    final repo = ref.read(taskRepositoryProvider);
    final result = await repo.reorder(ids);
    if (result is Failure) {
      state = AsyncError(result.exception, StackTrace.current);
    } else {
      state = const AsyncData(null);
    }
  }
}

/// Provides the task notifier.
final taskNotifierProvider = AsyncNotifierProvider<TaskNotifier, void>(TaskNotifier.new);
