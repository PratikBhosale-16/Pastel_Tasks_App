import 'package:flutter/material.dart';
import 'package:pastel_tasks/app/theme/radius.dart';
import 'package:pastel_tasks/app/theme/spacing.dart';

/// A foundational card component that standardizes radius, elevation,
/// and padding.
class BaseCard extends StatelessWidget {
  /// Creates a standard base card.
  const BaseCard({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.margin = EdgeInsets.zero,
    this.elevation = 0,
    this.color,
    this.onTap,
  });

  /// The content of the card.
  final Widget child;

  /// Internal padding for the card. Defaults to large spacing (16dp).
  final EdgeInsetsGeometry padding;

  /// External margin for the card. Defaults to zero.
  final EdgeInsetsGeometry margin;

  /// The elevation of the card. Defaults to 0 (flat).
  final double elevation;

  /// Background color of the card.
  final Color? color;
  
  /// Callback for when the card is tapped.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      margin: margin,
      color: color,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
