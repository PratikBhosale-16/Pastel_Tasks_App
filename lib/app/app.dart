import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pastel_tasks/app/config/app_config.dart';
import 'package:pastel_tasks/app/router/app_router.dart';
import 'package:pastel_tasks/app/theme/theme.dart';
import 'package:pastel_tasks/features/settings/presentation/providers/theme_providers.dart';
import 'package:pastel_tasks/features/widgets/data/widget_sync_service.dart';
import 'package:pastel_tasks/features/settings/presentation/providers/settings_provider.dart';

/// Root application shell for PastelTasks.
class App extends ConsumerWidget {
  /// Creates the PastelTasks application shell.
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialize Widget Syncing
    ref.watch(widgetSyncServiceProvider);
    
    final appAccent = ref.watch(appAccentProvider);
    
    final themeStr = ref.watch(settingDropdownProvider(themeDropdown)).value ?? '0';
    ThemeMode themeMode;
    switch (themeStr) {
      case '1':
        themeMode = ThemeMode.light;
        break;
      case '2':
        themeMode = ThemeMode.dark;
        break;
      case '0':
      default:
        themeMode = ThemeMode.system;
        break;
    }

    final fontSizeStr = ref.watch(settingDropdownProvider(fontSizeDropdown)).value ?? 'Default';
    double fontScale = 1.0;
    switch (fontSizeStr) {
      case 'Small':
        fontScale = 0.85;
        break;
      case 'Large':
        fontScale = 1.15;
        break;
      case 'Extra Large':
        fontScale = 1.3;
        break;
      case 'Default':
      default:
        fontScale = 1.0;
        break;
    }

    return MaterialApp.router(
      title: appConfig.applicationName,
      theme: AppTheme.light(seedColor: appAccent.color, fontScale: fontScale),
      darkTheme: AppTheme.dark(seedColor: appAccent.color, fontScale: fontScale),
      themeMode: themeMode,
      routerConfig: appRouter,
    );
  }
}
