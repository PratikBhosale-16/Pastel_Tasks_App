import 'package:flutter/material.dart';

/// Reusable empty state representation for lists and dashboards.
class EmptyState extends StatelessWidget {
  /// Base empty state constructor.
  const EmptyState({
    required this.title,
    required this.subtitle,
    required this.illustration,
    this.primaryActionLabel,
    this.onPrimaryAction,
    this.secondaryActionLabel,
    this.onSecondaryAction,
    this.icon,
    super.key,
  });

  /// Preset: Task List Empty
  const EmptyState.taskList({
    this.onPrimaryAction,
    super.key,
  })  : title = 'Nothing here yet.',
        subtitle = 'Tap the + button to create your first task.',
        illustration = Icons.inbox_rounded,
        primaryActionLabel = 'Create Task',
        secondaryActionLabel = null,
        onSecondaryAction = null,
        icon = null;

  /// Preset: Search Empty
  const EmptyState.search({
    super.key,
  })  : title = 'No results found.',
        subtitle = 'Try adjusting your search terms or filters.',
        illustration = Icons.search_off_rounded,
        primaryActionLabel = null,
        onPrimaryAction = null,
        secondaryActionLabel = null,
        onSecondaryAction = null,
        icon = null;

  /// Preset: Tag Empty
  const EmptyState.tag({
    this.onPrimaryAction,
    super.key,
  })  : title = 'No tags created.',
        subtitle = 'Organize your tasks by creating custom tags.',
        illustration = Icons.local_offer_rounded,
        primaryActionLabel = 'Create Tag',
        secondaryActionLabel = null,
        onSecondaryAction = null,
        icon = null;

  /// Preset: Reminder Empty
  const EmptyState.reminder({
    super.key,
  })  : title = 'No reminders set.',
        subtitle = 'Tasks with reminders will appear here.',
        illustration = Icons.alarm_off_rounded,
        primaryActionLabel = null,
        onPrimaryAction = null,
        secondaryActionLabel = null,
        onSecondaryAction = null,
        icon = null;

  /// Preset: Archive Empty
  const EmptyState.archive({
    super.key,
  })  : title = 'Archive is empty.',
        subtitle = 'Tasks you archive will be stored here.',
        illustration = Icons.archive_rounded,
        primaryActionLabel = null,
        onPrimaryAction = null,
        secondaryActionLabel = null,
        onSecondaryAction = null,
        icon = null;

  /// Preset: Completed Empty
  const EmptyState.completed({
    super.key,
  })  : title = 'No completed tasks.',
        subtitle = 'Your finished tasks will show up here.',
        illustration = Icons.check_circle_outline_rounded,
        primaryActionLabel = null,
        onPrimaryAction = null,
        secondaryActionLabel = null,
        onSecondaryAction = null,
        icon = null;

  /// The title text, e.g., "Nothing here yet."
  final String title;

  /// Subtitle explaining what to do next.
  final String subtitle;

  /// Large central illustration icon.
  final IconData illustration;

  /// Optional text for primary action button.
  final String? primaryActionLabel;

  /// Callback for primary action button.
  final VoidCallback? onPrimaryAction;

  /// Optional text for secondary action button.
  final String? secondaryActionLabel;

  /// Callback for secondary action button.
  final VoidCallback? onSecondaryAction;

  /// Optional smaller icon placed next to the title.
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.95, end: 1.0),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        builder: (context, scale, child) {
          // Calculate opacity from scale (0.95 -> 0, 1.0 -> 1)
          final opacity = ((scale - 0.95) * 20).clamp(0.0, 1.0);
          return Opacity(
            opacity: opacity,
            child: Transform.scale(
              scale: scale,
              child: child,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Semantics(
                label: 'Empty state illustration',
                child: Icon(
                  illustration,
                  size: 80,
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.2),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 24, color: colorScheme.primary),
                    const SizedBox(width: 8),
                  ],
                  Flexible(
                    child: Text(
                      title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              if (primaryActionLabel != null && onPrimaryAction != null) ...[
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: onPrimaryAction,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(120, 48), // Accessibility: 48dp target
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                  ),
                  child: Text(primaryActionLabel!),
                ),
              ],
              if (secondaryActionLabel != null && onSecondaryAction != null) ...[
                const SizedBox(height: 12),
                TextButton(
                  onPressed: onSecondaryAction,
                  style: TextButton.styleFrom(
                    minimumSize: const Size(120, 48), // Accessibility: 48dp target
                    foregroundColor: colorScheme.primary,
                  ),
                  child: Text(secondaryActionLabel!),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
