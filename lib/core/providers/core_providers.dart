import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pastel_tasks/core/logging/app_logger.dart';
import 'package:pastel_tasks/core/services/connectivity_service.dart';
import 'package:pastel_tasks/core/services/notification_service.dart';
import 'package:pastel_tasks/infrastructure/database/isar/database_service.dart';
import 'package:pastel_tasks/infrastructure/local_storage/preferences_service.dart';

/// Provides the application logger.
final loggerProvider = Provider<AppLogger>((ref) {
  return appLogger;
});

/// Provides the Isar database service.
final databaseProvider = Provider<DatabaseService>((ref) {
  return DatabaseService.instance;
});

/// Provides the notification service.
final notificationProvider = Provider<NotificationService>((ref) {
  return NotificationService.instance;
});

/// Provides the preferences service for local storage.
final preferencesProvider = Provider<PreferencesService>((ref) {
  return PreferencesService();
});

/// Provides the connectivity service.
final connectivityProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityService();
});
