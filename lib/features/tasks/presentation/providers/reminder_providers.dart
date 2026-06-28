import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pastel_tasks/core/errors/failure.dart';
import 'package:pastel_tasks/core/result/result.dart';
import 'package:pastel_tasks/features/tasks/domain/models/reminder.dart';
import 'package:pastel_tasks/features/tasks/presentation/providers/repository_providers.dart';

/// Streams the list of all reminders.
final reminderListProvider = StreamProvider<List<Reminder>>((ref) async* {
  final repository = ref.watch(reminderRepositoryProvider);
  await for (final result in repository.watchAll()) {
    if (result is Success<List<Reminder>>) {
      yield result.value;
    } else if (result is Failure<List<Reminder>>) {
      throw result.exception;
    }
  }
});

/// Provides upcoming enabled reminders.
final upcomingReminderProvider = FutureProvider<List<Reminder>>((ref) async {
  final repository = ref.watch(reminderRepositoryProvider);
  final result = await repository.getUpcoming();
  if (result is Success<List<Reminder>>) return result.value;
  throw (result as Failure).exception;
});
