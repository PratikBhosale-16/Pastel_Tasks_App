import 'package:flutter/material.dart';
import 'package:pastel_tasks/app/config/app_config.dart';
import 'package:pastel_tasks/app/router/app_router.dart';
import 'package:pastel_tasks/app/theme/theme.dart';
import 'package:pastel_tasks/features/dev_preview/dev_preview_screen.dart';


/// Root application shell for PastelTasks.
class App extends StatelessWidget {
  /// Creates the PastelTasks application shell.
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: devThemeMode,
      builder: (context, themeMode, _) {
        return MaterialApp.router(
          title: appConfig.applicationName,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeMode,
          routerConfig: appRouter,
        );
      },
    );
  }
}
