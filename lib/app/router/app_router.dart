import 'package:go_router/go_router.dart';
import 'package:pastel_tasks/app/router/route_names.dart';
import 'package:pastel_tasks/features/dev_preview/dev_preview_screen.dart';
import 'package:pastel_tasks/features/home/presentation/home_screen.dart';
import 'package:pastel_tasks/features/tasks/presentation/archive_screen.dart';
import 'package:pastel_tasks/features/tags/presentation/tags_screen.dart';
import 'package:pastel_tasks/features/calendar/presentation/calendar_screen.dart';
import 'package:pastel_tasks/features/settings/presentation/settings_screen.dart';
import 'package:pastel_tasks/features/stats/presentation/stats_screen.dart';
import 'package:pastel_tasks/shared/layout/app_shell_scaffold.dart';
/// Application router used by the app shell.
final appRouter = GoRouter(
  initialLocation: RouteNames.homePath,
  routes: [
    GoRoute(
      name: RouteNames.splash,
      path: RouteNames.splashPath,
      builder: (context, state) => const DevPreviewScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AppShellScaffold(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: RouteNames.home,
              path: RouteNames.homePath,
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: RouteNames.calendar,
              path: RouteNames.calendarPath,
              builder: (context, state) => const CalendarScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: RouteNames.tags,
              path: RouteNames.tagsPath,
              builder: (context, state) => const TagsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/stats',
              builder: (context, state) => const StatsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: RouteNames.settings,
              path: RouteNames.settingsPath,
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      name: RouteNames.archive,
      path: RouteNames.archivePath,
      builder: (context, state) => const ArchiveScreen(),
    ),
  ],
);
