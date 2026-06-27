import 'package:flutter/material.dart';
import 'package:pastel_tasks/shared/layout/gap.dart';

/// A secondary button for alternative actions.
class SecondaryButton extends StatelessWidget {
  /// Creates a secondary button.
  const SecondaryButton({
    required this.label,
    super.key,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = true,
  });

  /// The text label to display on the button.
  final String label;

  /// The callback when the button is pressed. If null, the button is disabled.
  final VoidCallback? onPressed;

  /// An optional leading icon.
  final IconData? icon;

  /// Whether the button is in a loading state. Displays a spinner if true.
  final bool isLoading;

  /// Whether the button should stretch to fill its parent's width.
  final bool isFullWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: theme.colorScheme.onSecondaryContainer,
            ),
          ),
          const Gap.sm(),
        ] else if (icon != null) ...[
          Icon(icon, size: 20),
          const Gap.sm(),
        ],
        Text(label),
      ],
    );

    Widget button = FilledButton.tonal(
      onPressed: isLoading ? null : onPressed,
      child: content,
    );

    if (isFullWidth) {
      button = SizedBox(width: double.infinity, child: button);
    }

    return button;
  }
}
