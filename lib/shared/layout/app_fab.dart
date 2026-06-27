import 'package:flutter/material.dart';

/// A custom Floating Action Button that conforms to the design system.
class AppFab extends StatelessWidget {
  /// Creates a standard floating action button.
  const AppFab({
    required this.icon,
    required this.onPressed,
    super.key,
    this.label,
    this.isMini = false,
    this.isExtended = false,
    this.isLoading = false,
    this.isDisabled = false,
    this.tooltip,
  });

  /// The icon to display.
  final IconData icon;

  /// The text label to display (only visible if [isExtended] is true).
  final String? label;

  /// The callback when the button is pressed.
  final VoidCallback? onPressed;

  /// Whether the FAB should be mini-sized.
  final bool isMini;

  /// Whether the FAB is extended to show a label.
  final bool isExtended;

  /// Whether the FAB is in a loading state.
  final bool isLoading;

  /// Whether the FAB is disabled.
  final bool isDisabled;

  /// Optional tooltip for accessibility.
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveOnPressed = (isDisabled || isLoading) ? null : onPressed;
    final backgroundColor = isDisabled
        ? theme.colorScheme.surfaceContainerHighest
        : theme.colorScheme.primaryContainer;
    final foregroundColor = isDisabled
        ? theme.colorScheme.onSurface.withValues(alpha: 0.38)
        : theme.colorScheme.onPrimaryContainer;

    final iconWidget = isLoading
        ? SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: foregroundColor,
            ),
          )
        : Icon(icon, color: foregroundColor);

    if (isExtended && label != null) {
      return FloatingActionButton.extended(
        onPressed: effectiveOnPressed,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        tooltip: tooltip,
        elevation: isDisabled ? 0 : 2, // Low elevation matching design system
        icon: iconWidget,
        label: Text(
          label!,
          style: TextStyle(color: foregroundColor, fontWeight: FontWeight.w600),
        ),
      );
    }

    return FloatingActionButton(
      onPressed: effectiveOnPressed,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      mini: isMini,
      tooltip: tooltip,
      elevation: isDisabled ? 0 : 2,
      child: iconWidget,
    );
  }
}
