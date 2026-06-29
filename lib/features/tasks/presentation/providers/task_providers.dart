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

