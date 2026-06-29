import 'package:go_router/go_router.dart';
import 'package:pastel_tasks/app/router/route_names.dart';
import 'package:pastel_tasks/features/dev_preview/dev_preview_screen.dart';
import 'package:pastel_tasks/features/home/presentation/home_screen.dart';
import 'package:pastel_tasks/features/tasks/presentation/archive_screen.dart';
import 'package:pastel_tasks/features/tags/presentation/tags_screen.dart';

/// Application router used by the app shell.
final appRouter = GoRouter(
  initialLocation: RouteNames.homePath,
  routes: [
    GoRoute(
      name: RouteNames.splash,
      path: RouteNames.splashPath,
      builder: (context, state) => const DevPreviewScreen(),
    ),
    GoRoute(
      name: RouteNames.home,
      path: RouteNames.homePath,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      name: RouteNames.archive,
      path: RouteNames.archivePath,
      builder: (context, state) => const ArchiveScreen(),
    ),
    GoRoute(
      name: RouteNames.tags,
      path: RouteNames.tagsPath,
      builder: (context, state) => const TagsScreen(),
    ),
  ],
);
