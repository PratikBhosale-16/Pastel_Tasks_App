import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pastel_tasks/app/theme/radius.dart';
import 'package:pastel_tasks/app/theme/spacing.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/priority.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/repeat_rule.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/task_status.dart';
import 'package:pastel_tasks/features/tasks/domain/models/task.dart';
import 'package:pastel_tasks/shared/widgets/swipeable/swipeable_card.dart';

/// Reusable Task Card component for the application.
class TaskCard extends StatelessWidget {
  const TaskCard({
    required this.task,
    this.onTap,
    this.onSwipeRight,
    this.onEdit,
    this.onArchive,
    this.onRestore,
    this.onDelete,
    super.key,
  });

  /// The task domain model to display.
  final Task task;

  /// Callback when the card is tapped.
  final VoidCallback? onTap;

  /// Callback when swiped right (e.g., Complete).
  final VoidCallback? onSwipeRight;

  /// Callback when Edit is selected.
  final VoidCallback? onEdit;

  /// Callback when Archive is selected.
  final VoidCallback? onArchive;

  /// Callback when Restore is selected.
  final VoidCallback? onRestore;

  /// Callback when Delete is selected.
  final VoidCallback? onDelete;

  String _formatReminderTime(DateTime time) {
    final now = DateTime.now();
    if (time.year == now.year && time.month == now.month && time.day == now.day) {
      return 'Today • ${DateFormat.jm().format(time)}';
    }
    return '${DateFormat.MMMd().format(time)} • ${DateFormat.jm().format(time)}';
  }

  String _getRepeatLabel(RepeatRule rule) {
    switch (rule) {
      case RepeatRule.daily: return '🔁 D';
      case RepeatRule.weekly: return '🔁 W';
      case RepeatRule.monthly: return '🔁 M';
      case RepeatRule.yearly: return '🔁 Y';
      case RepeatRule.custom: return '🔁 C';
      case RepeatRule.none: return '';
    }
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
    
    // Priority color should always be used for the indicator dot.
    final priorityColor = _getPriorityColor(task.priority, colorScheme);
    
    Color? parsedTaskColor;
    if (task.color.isNotEmpty) {
      try {
        parsedTaskColor = Color(int.parse(task.color, radix: 16));
      } catch (_) {}
    }

    if (!isArchived && parsedTaskColor != null) {
      cardColor = Color.alphaBlend(
        parsedTaskColor.withValues(alpha: 0.05), 
        cardColor
      );
    }

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
        borderRadius: BorderRadius.circular(AppRadius.xl),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.xl),
              border: !isArchived
                  ? Border(
                      left: BorderSide(
                        color: parsedTaskColor ?? colorScheme.secondary, 
                        width: 4,
                      ),
                    )
                  : null,
            ),
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
                      child: isArchived 
                        ? const Icon(Icons.archive_outlined, size: 24, color: Colors.grey)
                        : Checkbox(
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
                              color: isArchived ? colorScheme.onSurface.withValues(alpha: 0.6) : colorScheme.onSurface,
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
                                color: isArchived ? colorScheme.onSurfaceVariant.withValues(alpha: 0.6) : colorScheme.onSurfaceVariant,
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
                        if (task.isPinned)
                          Icon(Icons.push_pin_rounded, size: 20, color: colorScheme.secondary),
                        if (task.isPinned)
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
              if (task.dueDate != null || task.tags.isNotEmpty || task.reminder != null || task.repeatRule != RepeatRule.none) ...[
                const SizedBox(height: AppSpacing.md),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // LEFT: Tags
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
                    const SizedBox(width: AppSpacing.sm),
                    // RIGHT: Repeat, Due Date, Reminder
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (task.repeatRule != RepeatRule.none) ...[
                          Text(
                            _getRepeatLabel(task.repeatRule),
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: isArchived ? colorScheme.onSurfaceVariant.withValues(alpha: 0.6) : colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                        ],
                        if (task.dueDate != null && task.reminder != null)
                          Text(
                            '${DateFormat.MMMd().format(task.dueDate!)} • ${DateFormat.jm().format(task.reminder!.triggerTime)}',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: isOverdue ? colorScheme.error : (isArchived ? colorScheme.onSurfaceVariant.withValues(alpha: 0.6) : colorScheme.onSurfaceVariant),
                              fontWeight: isOverdue ? FontWeight.w600 : FontWeight.normal,
                            ),
                          )
                        else if (task.dueDate != null)
                          Text(
                            DateFormat.MMMd().format(task.dueDate!),
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: isOverdue ? colorScheme.error : (isArchived ? colorScheme.onSurfaceVariant.withValues(alpha: 0.6) : colorScheme.onSurfaceVariant),
                              fontWeight: isOverdue ? FontWeight.w600 : FontWeight.normal,
                            ),
                          )
                        else if (task.reminder != null)
                          Text(
                            _formatReminderTime(task.reminder!.triggerTime),
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: isArchived ? colorScheme.onSurfaceVariant.withValues(alpha: 0.6) : colorScheme.onSurfaceVariant,
                            ),
                          ),
                      ],
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
        child: Icon(isArchived ? Icons.unarchive_outlined : Icons.check_rounded, color: Colors.white, size: 32),
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
              if (isArchived || onRestore != null)
                IconButton(
                  icon: const Icon(Icons.unarchive_outlined),
                  color: Colors.green,
                  onPressed: () {
                    close();
                    if (onRestore != null) {
                      onRestore?.call();
                    }
                  },
                )
              else
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
