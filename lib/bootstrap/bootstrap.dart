import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pastel_tasks/app/app.dart';
import 'package:pastel_tasks/core/logging/app_logger.dart';
import 'package:pastel_tasks/infrastructure/database/isar/database_service.dart';
import 'package:pastel_tasks/core/services/notification_service.dart';

/// Starts the PastelTasks application shell.
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  final logger = AppLogger.instance;

  await runZonedGuarded<Future<void>>(
    () async {
      logger.initialize();
      
      try {
        await DatabaseService.instance.initialize();
      } catch (e, stack) {
        logger.error('Failed to initialize database during bootstrap', error: e, stackTrace: stack);
      }
      
      await NotificationService.instance.initialize();

      runApp(
        const ProviderScope(
          child: App(),
        ),
      );
    },
    logger.logZoneError,
  );
}
