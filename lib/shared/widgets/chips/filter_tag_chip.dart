import 'package:flutter/material.dart';

/// A filter chip used to toggle a specific tag filter on or off.
class FilterTagChip extends StatelessWidget {
  /// Creates a filter tag chip.
  const FilterTagChip({
    required this.label,
    required this.isSelected,
    super.key,
    this.onSelected,
    this.icon,
  });

  /// The text label for the filter tag.
  final String label;

  /// Whether the filter is currently selected.
  final bool isSelected;

  /// Callback when the filter selection changes.
  final ValueChanged<bool>? onSelected;

  /// Optional icon to display.
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      avatar: icon != null ? Icon(icon, size: 16) : null,
      showCheckmark: true,
    );
  }
}
