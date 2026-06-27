import 'package:flutter/material.dart';

/// A choice chip used for single selection from a group of options.
class SelectionChip extends StatelessWidget {
  /// Creates a selection chip.
  const SelectionChip({
    required this.label,
    required this.isSelected,
    super.key,
    this.onSelected,
    this.icon,
  });

  /// The text label for the selection.
  final String label;

  /// Whether the option is currently selected.
  final bool isSelected;

  /// Callback when the option is selected.
  final ValueChanged<bool>? onSelected;

  /// Optional icon to display.
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      avatar: icon != null ? Icon(icon, size: 16) : null,
      showCheckmark: false,
    );
  }
}
