import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pastel_tasks/app/app.dart';
import 'package:pastel_tasks/core/logging/app_logger.dart';
import 'package:pastel_tasks/core/logging/logger_service.dart';
import 'package:pastel_tasks/infrastructure/database/isar/isar_service.dart';
import 'package:pastel_tasks/core/services/notification_service.dart';

/// Starts the PastelTasks application shell.
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  final logger = AppLogger.instance;

  await runZonedGuarded<Future<void>>(
    () async {

      logger.initialize();
      await IsarService.instance.initialize();
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
