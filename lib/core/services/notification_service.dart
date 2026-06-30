import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pastel_tasks/core/logging/app_logger.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Background entry point for notification actions
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  appLogger.info('Background notification action received: ${notificationResponse.actionId}');
  // We'll implement background handling for "Complete" and "Snooze" here
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
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) {
        appLogger.info('Foreground notification action received: ${notificationResponse.actionId}');
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
      id,
      title,
      body,
      tzScheduledDate,
      const NotificationDetails(
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
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
    appLogger.info('Scheduled notification $id for $tzScheduledDate');
  }

  Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
    appLogger.info('Cancelled notification $id');
  }

  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
