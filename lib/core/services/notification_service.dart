import 'package:pastel_tasks/core/logging/app_logger.dart';

/// Root notification service structure.
final class NotificationService {
  NotificationService._();

  /// Shared notification service instance.
  static final instance = NotificationService._();

  /// Registers notification service structure for the app shell.
  Future<void> initialize() async {
    appLogger.info('Notification service structure registered.');
  }
}
