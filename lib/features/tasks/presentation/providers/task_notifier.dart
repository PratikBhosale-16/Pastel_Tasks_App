import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pastel_tasks/core/errors/failure.dart';
import 'package:pastel_tasks/features/tasks/domain/models/task.dart';
import 'package:pastel_tasks/features/tasks/domain/models/reminder.dart';
import 'package:pastel_tasks/features/tasks/presentation/providers/repository_providers.dart';
import 'package:pastel_tasks/features/tasks/presentation/providers/task_providers.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/task_status.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/repeat_rule.dart';
import 'package:pastel_tasks/core/result/result.dart';
import 'package:pastel_tasks/core/services/notification_service.dart';
import 'package:uuid/uuid.dart';
import 'package:pastel_tasks/features/settings/presentation/providers/settings_provider.dart';

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
      state = AsyncError((result as Failure).exception, StackTrace.current);
    } else {
      await _syncTaskNotification(task);
      state = const AsyncData(null);
    }
  }

  /// Updates a task.
  Future<void> updateTask(Task task) async {
    state = const AsyncLoading();
    final repo = ref.read(taskRepositoryProvider);



    if (task.status == TaskStatus.completed && task.repeatRule != RepeatRule.none) {
      final oldTaskResult = await repo.getById(task.id);
      if (oldTaskResult is Success<Task?> && oldTaskResult.value != null) {
        final oldTask = oldTaskResult.value!;
        if (oldTask.status != TaskStatus.completed) {
          final nextDueDate = _calculateNextDueDate(task.dueDate ?? DateTime.now(), task.repeatRule);
          
          final nextTaskId = const Uuid().v4();
          Reminder? nextReminder;
          if (task.reminder != null && nextDueDate != null) {
             final diff = nextDueDate.difference(task.dueDate ?? DateTime.now());
             nextReminder = task.reminder!.copyWith(
                id: const Uuid().v4(),
                taskId: nextTaskId,
                triggerTime: task.reminder!.triggerTime.add(diff),
             );
          }

          final nextTask = task.copyWith(
            id: nextTaskId,
            status: TaskStatus.pending,
            dueDate: nextDueDate,
            completedAt: null,
            clearCompletedAt: true,
            createdAt: DateTime.now().toUtc(),
            updatedAt: DateTime.now().toUtc(),
            reminder: nextReminder,
            clearReminder: task.reminder == null,
          );
          await repo.create(nextTask);
        }
      }
    }

    final result = await repo.update(task);
    if (result is Failure) {
      state = AsyncError((result as Failure).exception, StackTrace.current);
    } else {
      await _syncTaskNotification(task);
      state = const AsyncData(null);
    }
  }

  /// Deletes a task.
  Future<void> delete(String id) async {
    state = const AsyncLoading();
    final repo = ref.read(taskRepositoryProvider);
    final result = await repo.delete(id);
    if (result is Failure) {
      state = AsyncError((result as Failure).exception, StackTrace.current);
    } else {
      await _cancelTaskNotification(id);
      state = const AsyncData(null);
    }
  }

  /// Archives a task.
  Future<void> archive(String id) async {
    state = const AsyncLoading();
    final repo = ref.read(taskRepositoryProvider);
    final result = await repo.archive(id);
    if (result is Failure) {
      state = AsyncError((result as Failure).exception, StackTrace.current);
    } else {
      await _cancelTaskNotification(id);
      state = const AsyncData(null);
    }
  }

  /// Restores a task.
  Future<void> restore(String id) async {
    state = const AsyncLoading();
    final repo = ref.read(taskRepositoryProvider);
    final result = await repo.restore(id);
    if (result is Failure) {
      state = AsyncError((result as Failure).exception, StackTrace.current);
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
      state = AsyncError((result as Failure).exception, StackTrace.current);
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
      state = AsyncError((result as Failure).exception, StackTrace.current);
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
      state = AsyncError((result as Failure).exception, StackTrace.current);
    } else {
      state = const AsyncData(null);
    }
  }

  /// Bulk updates tasks.
  Future<void> bulkUpdateTasks(List<Task> tasks) async {
    state = const AsyncLoading();
    final repo = ref.read(taskRepositoryProvider);
    final result = await repo.bulkUpdate(tasks);
    if (result is Failure) {
      state = AsyncError((result as Failure).exception, StackTrace.current);
    } else {
      for (final task in tasks) {
        await _syncTaskNotification(task);
      }
      state = const AsyncData(null);
    }
  }

  /// Bulk deletes tasks.
  Future<void> bulkDeleteTasks(List<String> ids) async {
    state = const AsyncLoading();
    final repo = ref.read(taskRepositoryProvider);
    final result = await repo.bulkDelete(ids);
    if (result is Failure) {
      state = AsyncError((result as Failure).exception, StackTrace.current);
    } else {
      for (final id in ids) {
        await _cancelTaskNotification(id);
      }
      state = const AsyncData(null);
    }
  }

  /// Merges all tasks from oldTagId into newTagId.
  Future<void> mergeTags(String oldTagId, String newTagId) async {
    state = const AsyncLoading();
    try {
      final tasks = await ref.read(taskListProvider.future);
      final tasksToUpdate = tasks.where((t) => t.tags.contains(oldTagId)).toList();
      
      final updatedTasks = tasksToUpdate.map((t) {
        final newTags = List<String>.from(t.tags);
        newTags.remove(oldTagId);
        if (!newTags.contains(newTagId)) {
          newTags.add(newTagId);
        }
        return t.copyWith(tags: newTags);
      }).toList();

      if (updatedTasks.isNotEmpty) {
        final repo = ref.read(taskRepositoryProvider);
        final result = await repo.bulkUpdate(updatedTasks);
        if (result is Failure) {
          state = AsyncError((result as Failure).exception, StackTrace.current);
          return;
        }
        for (final task in updatedTasks) {
          await _syncTaskNotification(task);
        }
      }
      
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
  DateTime? _calculateNextDueDate(DateTime baseDate, RepeatRule rule) {
    switch (rule) {
      case RepeatRule.hourly:
        return baseDate.add(const Duration(hours: 1));
      case RepeatRule.daily:
        return baseDate.add(const Duration(days: 1));
      case RepeatRule.weekly:
        return baseDate.add(const Duration(days: 7));
      case RepeatRule.monthly:
        return DateTime(baseDate.year, baseDate.month + 1, baseDate.day, baseDate.hour, baseDate.minute);
      case RepeatRule.yearly:
        return DateTime(baseDate.year + 1, baseDate.month, baseDate.day, baseDate.hour, baseDate.minute);
      case RepeatRule.none:
        return null;
    }
  }

  Future<void> _syncTaskNotification(Task task) async {
    final notificationId = task.id.hashCode;
    
    // Always cancel existing before re-scheduling or to clean up
    await NotificationService.instance.cancelNotification(notificationId);
    
    if (task.status == TaskStatus.pending && task.reminder != null && task.reminder!.enabled) {
      var triggerTime = task.reminder!.triggerTime;
      final now = DateTime.now();
      
      // If the trigger time is in the past (e.g. missed while app was closed, or created in the past),
      // we bump it to 2 seconds from now so it fires immediately instead of being skipped.
      if (triggerTime.isBefore(now)) {
        triggerTime = now.add(const Duration(seconds: 2));
      }

      if (triggerTime.isAfter(now)) {
        
        // Read notification settings
        final masterSwitch = ref.read(settingSwitchProvider(masterNotificationToggle)).value ?? true;
        
        if (!masterSwitch) {
          return; // Notifications are disabled
        }

        final soundSetting = ref.read(settingDropdownProvider(notificationSoundDropdown)).value ?? 'Default';
        final vibrationSetting = ref.read(settingSwitchProvider(vibrationSwitch)).value ?? true;

        String channelId = 'pastel_tasks_reminders';
        String channelName = 'Reminders';
        String? soundName;
        bool playSound = true;

        switch (soundSetting) {
          case 'Correct Answer':
            channelId = 'pastel_tasks_correct_answer';
            channelName = 'Reminders (Correct Answer)';
            soundName = 'correct_answer_tone';
            break;
          case 'Long Pop':
            channelId = 'pastel_tasks_long_pop';
            channelName = 'Reminders (Long Pop)';
            soundName = 'long_pop';
            break;
          case 'Chime':
            channelId = 'pastel_tasks_chime';
            channelName = 'Reminders (Chime)';
            soundName = 'chime';
            break;
          case 'Bell':
            channelId = 'pastel_tasks_bell';
            channelName = 'Reminders (Bell)';
            soundName = 'bell';
            break;
          case 'None':
            playSound = false;
            break;
          default:
            // Default sound
            break;
        }

        await NotificationService.instance.scheduleNotification(
          id: notificationId,
          title: task.title,
          body: task.note.isNotEmpty ? task.note : 'You have a reminder for this task.',
          scheduledDate: task.reminder!.triggerTime,
          payload: task.id,
          channelId: channelId,
          channelName: channelName,
          soundName: soundName,
          playSound: playSound,
          enableVibration: vibrationSetting,
        );
      }
    }
  }

  Future<void> _cancelTaskNotification(String taskId) async {
    await NotificationService.instance.cancelNotification(taskId.hashCode);
  }
}

/// Provides the task notifier.
final taskNotifierProvider = AsyncNotifierProvider<TaskNotifier, void>(TaskNotifier.new);
