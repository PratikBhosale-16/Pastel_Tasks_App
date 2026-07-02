import 'package:flutter/material.dart';

/// A card that displays a statistic with an animated number counter.
class AnimatedStatCard extends StatelessWidget {
  const AnimatedStatCard({
    required this.title,
    required this.value,
    required this.icon,
    this.color,
    super.key,
  });

  /// The title of the statistic
  final String title;

  /// The numeric value to display and animate to
  final int value;

  /// The icon representing the statistic
  final IconData icon;

  /// Optional custom color for the icon and text
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = color ?? theme.colorScheme.primary;

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 24, color: cardColor),
            const SizedBox(height: 8),
            Text(
              title,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            TweenAnimationBuilder<int>(
              tween: IntTween(begin: 0, end: value),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutCubic,
              builder: (context, currentValue, child) {
                return Text(
                  currentValue.toString(),
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
