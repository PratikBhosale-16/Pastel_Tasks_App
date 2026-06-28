import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pastel_tasks/core/providers/core_providers.dart';
import 'package:pastel_tasks/features/tasks/data/repositories/reminder_repository_impl.dart';
import 'package:pastel_tasks/features/tasks/data/repositories/tag_repository_impl.dart';
import 'package:pastel_tasks/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:pastel_tasks/features/tasks/domain/repositories/reminder_repository.dart';
import 'package:pastel_tasks/features/tasks/domain/repositories/tag_repository.dart';
import 'package:pastel_tasks/features/tasks/domain/repositories/task_repository.dart';

/// Provides the TaskRepository.
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final dbService = ref.watch(databaseProvider);
  return TaskRepositoryImpl(dbService: dbService);
});

/// Provides the TagRepository.
final tagRepositoryProvider = Provider<TagRepository>((ref) {
  final dbService = ref.watch(databaseProvider);
  return TagRepositoryImpl(dbService: dbService);
});

/// Provides the ReminderRepository.
final reminderRepositoryProvider = Provider<ReminderRepository>((ref) {
  final dbService = ref.watch(databaseProvider);
  return ReminderRepositoryImpl(dbService: dbService);
});
