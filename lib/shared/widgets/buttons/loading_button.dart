import 'package:flutter/material.dart';
import 'package:pastel_tasks/shared/widgets/buttons/primary_button.dart';

/// A convenience button for primary actions that frequently enter 
/// a loading state.
/// 
/// This is a wrapper around [PrimaryButton] that explicitly highlights
/// the loading state capability.
class LoadingButton extends StatelessWidget {
  /// Creates a loading button.
  const LoadingButton({
    required this.label,
    required this.isLoading,
    super.key,
    this.onPressed,
  });

  /// The text label to display on the button.
  final String label;

  /// Whether the button is currently in a loading state.
  final bool isLoading;

  /// The callback when the button is pressed. If null, the button is disabled.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      label: label,
      isLoading: isLoading,
      onPressed: onPressed,
    );
  }
}
