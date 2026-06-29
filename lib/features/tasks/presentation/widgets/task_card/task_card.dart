import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pastel_tasks/app/theme/radius.dart';
import 'package:pastel_tasks/app/theme/spacing.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/priority.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/repeat_rule.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/task_status.dart';
import 'package:pastel_tasks/features/tasks/domain/models/task.dart';
import 'package:pastel_tasks/features/tasks/presentation/providers/task_notifier.dart';
import 'package:pastel_tasks/features/tasks/presentation/widgets/add_task_bottom_sheet/add_task_bottom_sheet.dart';
import 'package:pastel_tasks/features/search/presentation/providers/search_providers.dart';
import 'package:pastel_tasks/features/search/presentation/widgets/highlight_text.dart';
import 'package:pastel_tasks/shared/widgets/dialogs/confirmation_dialog.dart';
import 'package:pastel_tasks/shared/widgets/swipeable/swipeable_card.dart';

/// Reusable Task Card component for the application.
class TaskCard extends ConsumerWidget {
  const TaskCard({
    required this.task,
    super.key,
  });

  /// The task domain model to display.
  final Task task;

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

  Future<void> _editTask(BuildContext context, WidgetRef ref) async {
    final formData = await AddTaskBottomSheet.show(context, existingTask: task);
    if (formData == null || !context.mounted) return;

    if (formData.isDelete) {
      _confirmAndDeleteTask(context, ref);
      return;
    }
    if (formData.isArchive) {
      _archiveTask(context, ref);
      return;
    }
    if (formData.isRestore) {
      ref.read(taskNotifierProvider.notifier).restore(task.id);
      return;
    }

    Priority parsePriority(String p) {
      switch (p) {
        case 'Low': return Priority.low;
        case 'High': return Priority.high;
        case 'Critical': return Priority.critical;
        case 'Medium':
        default: return Priority.medium;
      }
    }

    RepeatRule parseRepeatRule(String r) {
      switch (r) {
        case 'Daily': return RepeatRule.daily;
        case 'Weekly': return RepeatRule.weekly;
        case 'Monthly': return RepeatRule.monthly;
        case 'Yearly': return RepeatRule.yearly;
        case 'None':
        default: return RepeatRule.none;
      }
    }

    final updatedTask = task.copyWith(
      title: formData.title,
      description: formData.description,
      priority: parsePriority(formData.priority),
      tags: formData.tag != null ? [formData.tag!] : [],
      updatedAt: DateTime.now().toUtc(),
      dueDate: formData.dueDate,
      repeatRule: parseRepeatRule(formData.repeatRule),
      isPinned: formData.isPinned,
      color: formData.color?.value.toRadixString(16) ?? '',
    );

    await ref.read(taskNotifierProvider.notifier).updateTask(updatedTask);
    if (!context.mounted) return;

    final state = ref.read(taskNotifierProvider);
    if (state.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update task')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task updated successfully')),
      );
    }
  }

  Future<void> _confirmAndDeleteTask(BuildContext context, WidgetRef ref) async {
    final confirm = await ConfirmationDialog.show(
      context: context,
      title: 'Delete Task',
      message: 'Delete this task?\nThis action cannot be undone after the timeout.',
      confirmText: 'Delete',
      cancelText: 'Cancel',
      isDestructive: true,
    );

    if (confirm && context.mounted) {
      final taskCopy = task;
      final messenger = ScaffoldMessenger.of(context);
      final themeContext = Theme.of(context);
      final notifier = ref.read(taskNotifierProvider.notifier);
      
      await notifier.delete(task.id);
      
      messenger.clearSnackBars();
      messenger.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Text('Task deleted'),
              const Spacer(),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: themeContext.colorScheme.inversePrimary,
                ),
                onPressed: () {
                  messenger.hideCurrentSnackBar();
                  notifier.create(taskCopy);
                },
                child: const Text('UNDO'),
              ),
            ],
          ),
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  Future<void> _archiveTask(BuildContext context, WidgetRef ref) async {
    final taskCopy = task;
    final messenger = ScaffoldMessenger.of(context);
    final themeContext = Theme.of(context);
    final notifier = ref.read(taskNotifierProvider.notifier);

    await notifier.archive(task.id);
    
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Text('Task archived'),
            const Spacer(),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: themeContext.colorScheme.inversePrimary,
              ),
              onPressed: () {
                messenger.hideCurrentSnackBar();
                notifier.restore(taskCopy.id);
              },
              child: const Text('UNDO'),
            ),
          ],
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  void _toggleStatus(BuildContext context, WidgetRef ref) {
    final newStatus = task.status == TaskStatus.completed 
        ? TaskStatus.pending 
        : TaskStatus.completed;
    
    final updatedTask = task.copyWith(
      status: newStatus,
      updatedAt: DateTime.now().toUtc(),
      completedAt: newStatus == TaskStatus.completed 
          ? DateTime.now().toUtc() 
          : null,
      clearCompletedAt: newStatus != TaskStatus.completed,
    );
    
    ref.read(taskNotifierProvider.notifier).updateTask(updatedTask);

    if (newStatus == TaskStatus.completed) {
      SemanticsService.announce('Task completed', ui.TextDirection.ltr);
    } else {
      SemanticsService.announce('Task restored', ui.TextDirection.ltr);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final isCompleted = task.status == TaskStatus.completed;
    final isArchived = task.isArchived;
    final searchQuery = ref.watch(debouncedSearchQueryProvider);
    
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
          onTap: () => _editTask(context, ref),
          borderRadius: BorderRadius.circular(AppRadius.xl),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.xl),
              border: !isArchived
                  ? Border(
                      left: BorderSide(
                        color: parsedTaskColor ?? colorScheme.outlineVariant, 
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
                              onChanged: (_) => _toggleStatus(context, ref),
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
                              child: HighlightText(
                                text: task.title,
                                query: searchQuery,
                              ),
                            ),
                            if (task.description.isNotEmpty) ...[
                              const SizedBox(height: AppSpacing.xs),
                              HighlightText(
                                text: task.description,
                                query: searchQuery,
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
                      padding: const EdgeInsets.only(top: AppSpacing.md),
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: isArchived ? Colors.grey : priorityColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
                if (task.tags.isNotEmpty || task.dueDate != null || task.reminder != null || task.repeatRule != RepeatRule.none) ...[
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Wrap(
                          spacing: AppSpacing.xs,
                          runSpacing: AppSpacing.xs,
                          children: task.tags.map((tag) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: isArchived 
                                  ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.5) 
                                  : colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(AppRadius.sm),
                              ),
                              child: Text(
                                tag,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: isArchived ? colorScheme.onSurfaceVariant.withValues(alpha: 0.6) : colorScheme.onSurfaceVariant,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (task.repeatRule != RepeatRule.none)
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                _getRepeatLabel(task.repeatRule),
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: isArchived ? colorScheme.primary.withValues(alpha: 0.6) : colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          if (task.dueDate != null)
                            Text(
                              DateFormat.MMMd().format(task.dueDate!),
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: isArchived 
                                    ? colorScheme.onSurfaceVariant.withValues(alpha: 0.6) 
                                    : (isOverdue ? colorScheme.error : colorScheme.onSurfaceVariant),
                                fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
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
      ),
    );

    return SwipeableCard(
      onSwipeRight: () {
        if (isArchived) {
          ref.read(taskNotifierProvider.notifier).restore(task.id);
          SemanticsService.announce('Task restored', ui.TextDirection.ltr);
        } else {
          _toggleStatus(context, ref);
        }
      },
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
                  _editTask(context, ref);
                },
              ),
              if (isArchived)
                IconButton(
                  icon: const Icon(Icons.unarchive_outlined),
                  color: Colors.green,
                  onPressed: () {
                    close();
                    ref.read(taskNotifierProvider.notifier).restore(task.id);
                  },
                )
              else
                IconButton(
                  icon: const Icon(Icons.archive_outlined),
                  color: Colors.orange,
                  onPressed: () {
                    close();
                    _archiveTask(context, ref);
                  },
                ),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded),
                color: colorScheme.error,
                onPressed: () {
                  close();
                  _confirmAndDeleteTask(context, ref);
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
        return Colors.green;
      case Priority.critical:
        return Colors.redAccent.shade700;
      default:
        return colorScheme.onSurfaceVariant.withValues(alpha: 0.3);
    }
  }
}
