import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pastel_tasks/app/theme/radius.dart';
import 'package:pastel_tasks/app/theme/spacing.dart';

/// A card with a frosted glass effect.
class GlassCard extends StatelessWidget {
  /// Creates a frosted glass card.
  const GlassCard({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.margin = EdgeInsets.zero,
    this.sigma = 10.0,
  });

  /// The content of the card.
  final Widget child;

  /// Internal padding for the card.
  final EdgeInsetsGeometry padding;

  /// External margin for the card.
  final EdgeInsetsGeometry margin;
  
  /// Determines the blur intensity.
  final double sigma;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withAlpha(150),
              borderRadius: BorderRadius.circular(AppRadius.xl),
              border: Border.all(
                color: theme.colorScheme.outlineVariant.withAlpha(100),
              ),
            ),
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}
