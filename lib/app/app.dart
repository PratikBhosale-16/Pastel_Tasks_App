import 'package:flutter/material.dart';
import 'package:pastel_tasks/app/config/app_config.dart';
import 'package:pastel_tasks/app/router/app_router.dart';
import 'package:pastel_tasks/app/theme/theme.dart';


/// Root application shell for PastelTasks.
class App extends StatelessWidget {
  /// Creates the PastelTasks application shell.
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: appConfig.applicationName,
      theme: AppTheme.light,
      routerConfig: appRouter,
    );
  }
}
