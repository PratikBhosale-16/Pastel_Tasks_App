import 'package:flutter/material.dart';

/// The status type for a [StatusChip].
enum ChipStatus {
  /// General information status.
  info,
  /// Success status.
  success,
  /// Warning status.
  warning,
  /// Error or critical status.
  error,
}

/// A read-only chip used to display a semantic status.
class StatusChip extends StatelessWidget {
  /// Creates a status chip.
  const StatusChip({
    required this.label,
    required this.status,
    super.key,
    this.icon,
  });

  /// The text label for the status.
  final String label;

  /// The semantic status of the chip, determining its color.
  final ChipStatus status;

  /// Optional icon to display.
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    Color backgroundColor;
    Color foregroundColor;

    switch (status) {
      case ChipStatus.success:
        backgroundColor = theme.colorScheme.tertiaryContainer;
        foregroundColor = theme.colorScheme.onTertiaryContainer;
      case ChipStatus.warning:
        // Using secondary container for warning in this theme setup
        // as a fallback, unless custom warning extensions exist.
        backgroundColor = theme.colorScheme.secondaryContainer;
        foregroundColor = theme.colorScheme.onSecondaryContainer;
      case ChipStatus.error:
        backgroundColor = theme.colorScheme.errorContainer;
        foregroundColor = theme.colorScheme.onErrorContainer;
      case ChipStatus.info:
        backgroundColor = theme.colorScheme.primaryContainer;
        foregroundColor = theme.colorScheme.onPrimaryContainer;
    }
    
    return Chip(
      label: Text(
        label,
        style: TextStyle(color: foregroundColor, fontWeight: FontWeight.w600),
      ),
      avatar: icon != null 
          ? Icon(icon, size: 16, color: foregroundColor) 
          : null,
      backgroundColor: backgroundColor,
      side: BorderSide.none,
    );
  }
}
