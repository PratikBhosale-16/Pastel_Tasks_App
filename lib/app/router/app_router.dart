import 'package:go_router/go_router.dart';
import 'package:pastel_tasks/app/router/route_names.dart';
import 'package:pastel_tasks/features/dev_preview/dev_preview_screen.dart';
import 'package:pastel_tasks/features/home/presentation/home_screen.dart';
import 'package:pastel_tasks/features/tasks/presentation/archive_screen.dart';
import 'package:pastel_tasks/features/tasks/presentation/screens/task_details_screen.dart';
import 'package:pastel_tasks/features/tasks/presentation/screens/completed_tasks_screen.dart';
import 'package:pastel_tasks/features/tags/presentation/tags_screen.dart';
import 'package:pastel_tasks/features/calendar/presentation/calendar_screen.dart';
import 'package:pastel_tasks/features/settings/presentation/settings_screen.dart';
import 'package:pastel_tasks/features/settings/presentation/notification_settings_screen.dart';
import 'package:pastel_tasks/features/settings/presentation/notification_history_screen.dart';
import 'package:pastel_tasks/features/stats/presentation/mine_screen.dart';
import 'package:pastel_tasks/features/backup/presentation/screens/backup_screen.dart';
import 'package:pastel_tasks/features/widgets/presentation/widget_settings_screen.dart';
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
              path: '/mine',
              builder: (context, state) => const MineScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      name: RouteNames.settings,
      path: RouteNames.settingsPath,
      builder: (context, state) => const SettingsScreen(),
      routes: [
        GoRoute(
          path: 'notification_settings',
          builder: (context, state) => const NotificationSettingsScreen(),
        ),
        GoRoute(
          path: 'notification_history',
          builder: (context, state) => const NotificationHistoryScreen(),
        ),
        GoRoute(
          path: 'backup',
          builder: (context, state) => const BackupScreen(),
        ),
        GoRoute(
          path: 'widget',
          builder: (context, state) => const WidgetSettingsScreen(),
        ),
      ],
    ),
    GoRoute(
      name: RouteNames.archive,
      path: RouteNames.archivePath,
      builder: (context, state) => const ArchiveScreen(),
    ),
    GoRoute(
      name: RouteNames.completedTasks,
      path: RouteNames.completedTasksPath,
      builder: (context, state) => const CompletedTasksScreen(),
    ),
    GoRoute(
      name: RouteNames.taskDetails,
      path: RouteNames.taskDetailsPath,
      builder: (context, state) => TaskDetailsScreen(taskId: state.pathParameters['id']!),
    ),
  ],
);
