import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pastel_tasks/app/config/app_config.dart';
import 'package:pastel_tasks/app/router/app_router.dart';
import 'package:pastel_tasks/app/theme/theme.dart';
import 'package:pastel_tasks/features/settings/presentation/providers/theme_providers.dart';


/// Root application shell for PastelTasks.
class App extends ConsumerWidget {
  /// Creates the PastelTasks application shell.
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appThemeMode = ref.watch(themeModeProvider);
    final appAccent = ref.watch(appAccentProvider);

    ThemeMode themeMode;
    switch (appThemeMode) {
      case AppThemeMode.light:
        themeMode = ThemeMode.light;
        break;
      case AppThemeMode.dark:
        themeMode = ThemeMode.dark;
        break;
      case AppThemeMode.system:
        themeMode = ThemeMode.system;
        break;
    }

    return MaterialApp.router(
      title: appConfig.applicationName,
      theme: AppTheme.light(seedColor: appAccent.color),
      darkTheme: AppTheme.dark(seedColor: appAccent.color),
      themeMode: themeMode,
      routerConfig: appRouter,
    );
  }
}
