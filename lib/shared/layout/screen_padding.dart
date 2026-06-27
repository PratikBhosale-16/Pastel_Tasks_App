import 'package:flutter/material.dart';
import 'package:pastel_tasks/app/theme/spacing.dart';

/// Standard padding for screens in the application.
class ScreenPadding extends StatelessWidget {
  /// Creates a standard screen padding wrapper.
  const ScreenPadding({
    required this.child,
    super.key,
    this.bottom = true,
  });

  /// The widget below this widget in the tree.
  final Widget child;

  /// Whether to include bottom padding, helpful for lists with bottom nav.
  final bool bottom;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        bottom ? AppSpacing.x6l : 0,
      ),
      child: child,
    );
  }
}
