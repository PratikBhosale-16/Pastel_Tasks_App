import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:pastel_tasks/app/router/route_names.dart';

/// Application router used by the app shell.
final appRouter = GoRouter(
  initialLocation: RouteNames.splashPath,
  routes: [
    GoRoute(
      name: RouteNames.splash,
      path: RouteNames.splashPath,
      builder: (context, state) => const SizedBox.shrink(),
    ),
  ],
);
