import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pastel_tasks/app/theme/radius.dart';
import 'package:pastel_tasks/app/theme/spacing.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/priority.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/task_status.dart';
import 'package:pastel_tasks/features/tasks/domain/models/task.dart';
import 'package:pastel_tasks/shared/widgets/swipeable/swipeable_card.dart';

/// Reusable Task Card component for the application.
class TaskCard extends StatelessWidget {
  const TaskCard({
    required this.task,
    this.onTap,
    this.onLongPress,
    this.onSwipeRight,
    this.onEdit,
    this.onArchive,
    this.onDelete,
    super.key,
  });

  /// The task domain model to display.
  final Task task;

  /// Callback when the card is tapped.
  final VoidCallback? onTap;

  /// Callback when the card is long-pressed (custom override).
  final VoidCallback? onLongPress;

  /// Callback when swiped right (e.g., Complete).
  final VoidCallback? onSwipeRight;

  /// Callback when Edit is selected.
  final VoidCallback? onEdit;

  /// Callback when Archive is selected.
  final VoidCallback? onArchive;

  /// Callback when Delete is selected.
  final VoidCallback? onDelete;

  void _showLongPressMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.edit_rounded, color: colorScheme.primary),
                title: const Text('Edit Task'),
                onTap: () {
                  Navigator.pop(context);
                  onEdit?.call();
                },
              ),
              ListTile(
                leading: const Icon(Icons.archive_outlined, color: Colors.orange),
                title: const Text('Archive Task'),
                onTap: () {
                  Navigator.pop(context);
                  onArchive?.call();
                },
              ),
              ListTile(
                leading: Icon(Icons.delete_outline_rounded, color: colorScheme.error),
                title: const Text('Delete Task'),
                onTap: () {
                  Navigator.pop(context);
                  onDelete?.call();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final isCompleted = task.status == TaskStatus.completed;
    final isArchived = task.isArchived;
    
    final now = DateTime.now();
    final isOverdue = !isCompleted && 
                      task.dueDate != null && 
                      task.dueDate!.isBefore(DateTime(now.year, now.month, now.day));

    // Base card color based on states
    Color cardColor = colorScheme.surface;
    if (isArchived) {
      cardColor = colorScheme.surfaceVariant.withValues(alpha: 0.5);
    }
    
    // Convert hex string to Color if task.color is a valid hex, otherwise default.
    // For now we'll just use primary color if it's set to "default"
    final priorityColor = _getPriorityColor(task.priority, colorScheme);

    final cardContent = AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: isCompleted ? 0.6 : 1.0,
      child: Card(
        elevation: 2,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        color: cardColor,
        child: InkWell(
        onTap: onTap,
        onLongPress: () {
          onLongPress?.call();
          _showLongPressMenu(context);
        },
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Semantics(
                    label: isCompleted ? 'Mark incomplete' : 'Mark complete',
                    button: true,
                    child: SizedBox(
                      width: 48,
                      height: 48,
                      child: Checkbox(
                        value: isCompleted,
                        onChanged: (_) {
                          if (onSwipeRight != null) onSwipeRight!();
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.sm),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 300),
                            style: theme.textTheme.titleMedium!.copyWith(
                              decoration: isCompleted ? TextDecoration.lineThrough : null,
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                            child: Text(task.title),
                          ),
                          if (task.description.isNotEmpty) ...[
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              task.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.sm),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (task.reminder != null)
                          Icon(Icons.alarm_rounded, size: 20, color: colorScheme.primary),
                        if (task.isPinned)
                          Icon(Icons.push_pin_rounded, size: 20, color: colorScheme.secondary),
                        const SizedBox(width: AppSpacing.xs),
                        Icon(
                          Icons.circle,
                          size: 16,
                          color: priorityColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (task.dueDate != null || task.tags.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.md),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (task.dueDate != null) ...[
                      Icon(
                        Icons.calendar_today_rounded,
                        size: 14,
                        color: isOverdue ? colorScheme.error : colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        DateFormat.yMMMd().format(task.dueDate!),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isOverdue ? colorScheme.error : colorScheme.onSurfaceVariant,
                          fontWeight: isOverdue ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.lg),
                    ],
                    Expanded(
                      child: Wrap(
                        spacing: AppSpacing.xs,
                        runSpacing: AppSpacing.xs,
                        children: task.tags.map((tagId) {
                          // NOTE: In M4.1 Tags, we will load tag names. For now, it's just ID.
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
                            decoration: BoxDecoration(
                              color: colorScheme.secondaryContainer.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(AppRadius.sm),
                            ),
                            child: Text(
                              tagId,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSecondaryContainer,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    ));

    return SwipeableCard(
      onSwipeRight: onSwipeRight,
      rightActionBackground: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: Colors.green.shade300,
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        child: const Icon(Icons.check_rounded, color: Colors.white, size: 32),
      ),
      leftActionPaneBuilder: (context, close) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.edit_rounded),
                color: colorScheme.primary,
                onPressed: () {
                  close();
                  onEdit?.call();
                },
              ),
              IconButton(
                icon: const Icon(Icons.archive_outlined),
                color: Colors.orange,
                onPressed: () {
                  close();
                  onArchive?.call();
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded),
                color: colorScheme.error,
                onPressed: () {
                  close();
                  onDelete?.call();
                },
              ),
            ],
          ),
        );
      },
      child: cardContent,
    );
  }

  Color _getPriorityColor(Priority priority, ColorScheme colorScheme) {
    switch (priority) {
      case Priority.high:
        return colorScheme.error;
      case Priority.medium:
        return Colors.orange;
      case Priority.low:
        return Colors.blue;
      case Priority.critical:
        return Colors.redAccent.shade700;
      default:
        return colorScheme.onSurfaceVariant.withValues(alpha: 0.3);
    }
  }
}
