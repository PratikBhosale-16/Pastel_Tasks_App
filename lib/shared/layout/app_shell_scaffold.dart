import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pastel_tasks/shared/layout/app_bottom_navigation.dart';
import 'package:pastel_tasks/features/smart_lists/presentation/widgets/smart_lists_drawer.dart';

/// The main shell scaffold that wraps the application and provides
/// a persistent bottom navigation bar across top-level destinations.
class AppShellScaffold extends ConsumerWidget {
  /// Creates the app shell scaffold.
  const AppShellScaffold({
    required this.navigationShell,
    super.key,
  });

  /// The navigation shell provided by GoRouter's StatefulShellRoute.
  final StatefulNavigationShell navigationShell;

  void _onDestinationSelected(int index) {
    navigationShell.goBranch(
      index,
      // A common pattern when using bottom navigation bars is to support
      // navigating to the initial location when tapping the item that is
      // already active.
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      drawer: const SmartListsDrawer(),
      body: navigationShell,
      bottomNavigationBar: AppBottomNavigation(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: const [
          AppNavigationDestination(
            icon: Icons.inbox_outlined,
            selectedIcon: Icons.inbox_rounded,
            label: 'Inbox',
          ),
          AppNavigationDestination(
            icon: Icons.calendar_month_outlined,
            selectedIcon: Icons.calendar_month_rounded,
            label: 'Calendar',
          ),
          AppNavigationDestination(
            icon: Icons.tag_outlined,
            selectedIcon: Icons.tag_rounded,
            label: 'Categories',
          ),
        ],
      ),
    );
  }
}
