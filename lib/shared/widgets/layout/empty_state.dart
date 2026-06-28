import 'package:flutter/material.dart';

/// Reusable empty state representation for lists and dashboards.
class EmptyState extends StatelessWidget {
  /// Creates an empty state widget.
  const EmptyState({
    required this.title,
    required this.subtitle,
    required this.icon,
    super.key,
  });

  /// The title text, e.g., "Nothing here yet."
  final String title;

  /// Subtitle explaining what to do next.
  final String subtitle;

  /// Icon to represent the empty state.
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 64,
              color: colorScheme.outline,
              semanticLabel: title,
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
