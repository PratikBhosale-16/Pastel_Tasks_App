import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pastel_tasks/core/errors/failure.dart';
import 'package:pastel_tasks/features/tasks/domain/models/reminder.dart';
import 'package:pastel_tasks/features/tasks/presentation/providers/repository_providers.dart';

/// Notifier handling reminder state mutations.
class ReminderNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  /// Creates a reminder.
  Future<void> create(Reminder reminder) async {
    state = const AsyncLoading();
    final repo = ref.read(reminderRepositoryProvider);
    final result = await repo.create(reminder);
    if (result is Failure) {
      state = AsyncError((result as Failure).exception, StackTrace.current);
    } else {
      state = const AsyncData(null);
    }
  }

  /// Updates a reminder.
  Future<void> updateReminder(Reminder reminder) async {
    state = const AsyncLoading();
    final repo = ref.read(reminderRepositoryProvider);
    final result = await repo.update(reminder);
    if (result is Failure) {
      state = AsyncError((result as Failure).exception, StackTrace.current);
    } else {
      state = const AsyncData(null);
    }
  }

  /// Deletes a reminder.
  Future<void> delete(String id) async {
    state = const AsyncLoading();
    final repo = ref.read(reminderRepositoryProvider);
    final result = await repo.delete(id);
    if (result is Failure) {
      state = AsyncError((result as Failure).exception, StackTrace.current);
    } else {
      state = const AsyncData(null);
    }
  }
}

/// Provides the reminder notifier.
final reminderNotifierProvider = AsyncNotifierProvider<ReminderNotifier, void>(ReminderNotifier.new);
