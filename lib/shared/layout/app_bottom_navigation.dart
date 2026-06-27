import 'package:flutter/material.dart';

/// Represents a single destination in the [AppBottomNavigation].
class AppNavigationDestination {
  /// Creates a navigation destination.
  const AppNavigationDestination({
    required this.icon,
    required this.label,
    this.selectedIcon,
    this.badgeText,
    this.showBadge = false,
  });

  /// The icon for the unselected state.
  final IconData icon;

  /// The text label for the destination.
  final String label;

  /// An optional icon for the selected state.
  final IconData? selectedIcon;

  /// Optional text to show in the badge (e.g., '3' for unread counts).
  final String? badgeText;

  /// Whether to show a small notification badge without text.
  final bool showBadge;
}

/// A custom bottom navigation bar aligning with the design system.
/// Contains no routing logic.
class AppBottomNavigation extends StatelessWidget {
  /// Creates an app bottom navigation bar.
  const AppBottomNavigation({
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    super.key,
  }) : assert(
          destinations.length >= 2 && destinations.length <= 5,
          'Must have between 2 and 5 destinations',
        );

  /// The list of destinations to display.
  final List<AppNavigationDestination> destinations;

  /// The index of the currently selected destination.
  final int selectedIndex;

  /// The callback when a destination is selected.
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      destinations: destinations.map((dest) {
        Widget iconWidget = Icon(dest.icon);
        Widget selectedIconWidget = Icon(dest.selectedIcon ?? dest.icon);

        if (dest.badgeText != null) {
          iconWidget = Badge(
            label: Text(dest.badgeText!),
            child: iconWidget,
          );
          selectedIconWidget = Badge(
            label: Text(dest.badgeText!),
            child: selectedIconWidget,
          );
        } else if (dest.showBadge) {
          iconWidget = Badge(child: iconWidget);
          selectedIconWidget = Badge(child: selectedIconWidget);
        }

        return NavigationDestination(
          icon: iconWidget,
          selectedIcon: selectedIconWidget,
          label: dest.label,
        );
      }).toList(),
    );
  }
}
