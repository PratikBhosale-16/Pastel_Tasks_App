import 'package:flutter/material.dart';

/// A read-only chip used to display a tag.
class TagChip extends StatelessWidget {
  /// Creates a tag chip.
  const TagChip({
    required this.label,
    super.key,
    this.icon,
    this.color,
  });

  /// The text label for the tag.
  final String label;

  /// Optional icon to display before the label.
  final IconData? icon;
  
  /// Optional color for the tag. Falls back to primary container.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = color ?? theme.colorScheme.primaryContainer;
    
    // Using Chip since it's read-only
    return Chip(
      label: Text(label),
      avatar: icon != null ? Icon(icon, size: 16) : null,
      backgroundColor: backgroundColor,
      side: BorderSide.none,
    );
  }
}
