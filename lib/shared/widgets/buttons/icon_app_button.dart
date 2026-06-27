import 'package:flutter/material.dart';

/// A button that displays only an icon.
class IconAppButton extends StatelessWidget {
  /// Creates an icon button.
  const IconAppButton({
    required this.icon,
    super.key,
    this.onPressed,
    this.tooltip,
    this.isLoading = false,
  });

  /// The icon to display.
  final IconData icon;

  /// The callback when the button is pressed. If null, the button is disabled.
  final VoidCallback? onPressed;

  /// Optional tooltip for accessibility.
  final String? tooltip;
  
  /// Whether the button is in a loading state. Displays a spinner if true.
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      final theme = Theme.of(context);
      return IconButton(
        onPressed: null,
        tooltip: tooltip,
        icon: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: theme.colorScheme.primary,
          ),
        ),
      );
    }

    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
      tooltip: tooltip,
    );
  }
}
