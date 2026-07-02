import 'dart:io';
import 'package:flutter/widgets.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pastel_tasks/core/logging/app_logger.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pastel_tasks/infrastructure/database/isar/database_service.dart';
import 'package:pastel_tasks/features/tasks/presentation/providers/task_notifier.dart';
import 'package:pastel_tasks/features/tasks/presentation/providers/repository_providers.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/task_status.dart';
import 'package:pastel_tasks/core/result/result.dart';
import 'package:pastel_tasks/features/tasks/domain/models/task.dart';

/// Background entry point for notification actions
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) async {
  appLogger.info('Background notification action received: ${notificationResponse.actionId}');
  final taskId = notificationResponse.payload;
  if (taskId == null || taskId.isEmpty) return;
  
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();

  await DatabaseService.instance.initialize();
  final container = ProviderContainer();

  final taskRepo = container.read(taskRepositoryProvider);
  final taskResult = await taskRepo.getById(taskId);
  
  if (taskResult is Success<Task?> && taskResult.value != null) {
    final task = taskResult.value!;

    if (notificationResponse.actionId == 'action_complete') {
      final updatedTask = task.copyWith(
        status: TaskStatus.completed,
        updatedAt: DateTime.now().toUtc(),
        completedAt: DateTime.now().toUtc(),
        clearCompletedAt: false,
      );
      await container.read(taskNotifierProvider.notifier).updateTask(updatedTask);
    } else if (notificationResponse.actionId == 'action_snooze') {
      if (task.reminder != null) {
        final newTriggerTime = DateTime.now().add(const Duration(minutes: 15));
        final updatedTask = task.copyWith(
          reminder: task.reminder!.copyWith(
            triggerTime: newTriggerTime,
          ),
          updatedAt: DateTime.now().toUtc(),
        );
        await container.read(taskNotifierProvider.notifier).updateTask(updatedTask);
      }
    }
  }
}

/// Root notification service structure.
final class NotificationService {
  NotificationService._();

  static final instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    // Setup iOS/macOS initialization if needed in future
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) {
        appLogger.info('Foreground notification action received: ${notificationResponse.actionId}');
        notificationTapBackground(notificationResponse);
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
    
    appLogger.info('Notification service initialized.');
  }

  Future<void> requestPermissions() async {
    if (Platform.isAndroid) {
      final androidImplementation = _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      await androidImplementation?.requestNotificationsPermission();
      await androidImplementation?.requestExactAlarmsPermission();
    }
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    required String payload,
  }) async {
    final tz.TZDateTime tzScheduledDate = tz.TZDateTime.from(scheduledDate, tz.local);
    
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: tzScheduledDate,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'pastel_tasks_reminders',
          'Reminders',
          channelDescription: 'Notifications for task reminders',
          importance: Importance.max,
          priority: Priority.high,
          groupKey: 'pastel_tasks_group',
          actions: <AndroidNotificationAction>[
            AndroidNotificationAction(
              'action_complete',
              'Complete',
              showsUserInterface: false,
            ),
            AndroidNotificationAction(
              'action_snooze',
              'Snooze',
              showsUserInterface: true,
            ),
          ],
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: payload,
    );
    appLogger.info('Scheduled notification $id for $tzScheduledDate');
  }

  Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id: id);
    appLogger.info('Cancelled notification $id');
  }

  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
