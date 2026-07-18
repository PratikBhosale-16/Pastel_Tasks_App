import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pastel_tasks/app/providers/date_time_format_provider.dart';
import 'package:pastel_tasks/features/settings/presentation/providers/settings_provider.dart';
import 'package:pastel_tasks/app/theme/radius.dart';
import 'package:pastel_tasks/app/theme/spacing.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/priority.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/repeat_rule.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/task_status.dart';
import 'package:pastel_tasks/features/tasks/domain/models/task.dart';
import 'package:pastel_tasks/features/tasks/domain/models/reminder.dart';
import 'package:uuid/uuid.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:pastel_tasks/features/tasks/presentation/providers/task_notifier.dart';
import 'package:pastel_tasks/features/tasks/presentation/widgets/add_task_bottom_sheet/add_task_bottom_sheet.dart';
import 'package:pastel_tasks/features/search/presentation/providers/search_providers.dart';
import 'package:pastel_tasks/features/search/presentation/widgets/highlight_text.dart';
import 'package:pastel_tasks/features/selection/presentation/providers/selection_providers.dart';
import 'package:pastel_tasks/features/tags/presentation/providers/tag_notifier.dart';
import 'package:pastel_tasks/shared/widgets/dialogs/confirmation_dialog.dart';
import 'package:pastel_tasks/shared/widgets/swipeable/swipeable_card.dart';
import 'package:go_router/go_router.dart';
import 'package:pastel_tasks/app/router/route_names.dart';

final _audioPlayer = AudioPlayer();

/// Reusable Task Card component for the application.
class TaskCard extends ConsumerWidget {
  const TaskCard({
    required this.task,
    this.showProject = true,
    this.showTimeline = false,
    super.key,
  });

  /// The task domain model to display.
  final Task task;

  /// Whether to show the project tag.
  final bool showProject;
  
  /// Whether to show a timeline indicator on the left side with the creation date/time.
  final bool showTimeline;

  String _formatRelativeDate(DateTime date, DateTimeFormatter formatter) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(date.year, date.month, date.day);
    
    if (targetDate == today) {
      return 'Today';
    } else if (targetDate == today.add(const Duration(days: 1))) {
      return 'Tomorrow';
    } else if (targetDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else if (date.year == now.year) {
      return formatter.formatShortDate(date);
    } else {
      return formatter.formatDate(date);
    }
  }

  String _getRepeatLabel(RepeatRule rule) {
    switch (rule) {
      case RepeatRule.hourly: return 'Hourly';
      case RepeatRule.daily: return 'Daily';
      case RepeatRule.weekly: return 'Weekly';
      case RepeatRule.monthly: return 'Monthly';
      case RepeatRule.yearly: return 'Yearly';
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



    Reminder? generateReminder(String taskId) {
      if (formData.reminder == null) return null;
      final baseDate = formData.dueDate ?? DateTime.now();
      var triggerTime = DateTime(
        baseDate.year,
        baseDate.month,
        baseDate.day,
        formData.reminder!.hour,
        formData.reminder!.minute,
      );
      if (formData.dueDate == null && triggerTime.isBefore(DateTime.now())) {
        triggerTime = triggerTime.add(const Duration(days: 1));
      }
      return Reminder(
        id: task.reminder?.id ?? const Uuid().v4(),
        taskId: taskId,
        triggerTime: triggerTime,
        repeatRule: formData.repeatRule,
        enabled: true,
      );
    }

    final updatedTask = task.copyWith(
      title: formData.title,
      note: formData.note,
      priority: formData.priority,
      tags: formData.tag != null ? [formData.tag!] : [],
      subTasks: formData.subTasks,
      updatedAt: DateTime.now().toUtc(),
      dueDate: formData.dueDate,
      clearDueDate: formData.dueDate == null,
      reminder: generateReminder(task.id),
      clearReminder: formData.reminder == null,
      repeatRule: formData.repeatRule,
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

  void _toggleStatus(BuildContext context, WidgetRef ref) async {
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
      
      final toneSelection = ref.read(settingDropdownProvider(taskCompletionToneDropdown)).value ?? 'None';
      if (toneSelection != 'None') {
        try {
          if (toneSelection == 'Correct Answer') {
            await _audioPlayer.play(AssetSource('sounds/correct_answer_tone.wav'));
          } else if (toneSelection == 'Long Pop') {
            await _audioPlayer.play(AssetSource('sounds/long_pop.wav'));
          }
        } catch (e) {
          debugPrint('Failed to play completion tone: $e');
        }
      }
    } else {
      SemanticsService.announce('Task restored', ui.TextDirection.ltr);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final formatter = ref.watch(dateTimeFormatterProvider);
    
    final isCompleted = task.status == TaskStatus.completed;
    final isArchived = task.isArchived;
    final searchQuery = ref.watch(debouncedSearchQueryProvider);
    
    final now = DateTime.now();
    final isOverdue = !isCompleted && 
                      task.dueDate != null && 
                      task.dueDate!.isBefore(DateTime(now.year, now.month, now.day));

    final isSelectionMode = ref.watch(isSelectionModeProvider);
    final isSelected = ref.watch(selectionProvider).contains(task.id);

    // Base card color based on states
    Color cardColor = colorScheme.surface;
    if (isSelected) {
      cardColor = colorScheme.secondaryContainer;
    } else if (isArchived) {
      cardColor = colorScheme.surfaceVariant.withValues(alpha: 0.5);
    }
    
    final tagsList = ref.watch(tagNotifierProvider).valueOrNull ?? [];
    
    // Priority color should always be used for the indicator dot.
    final priorityColor = _getPriorityColor(task.priority, colorScheme);
    
    Color? parsedTaskColor;
    if (task.color.isNotEmpty) {
      try {
        parsedTaskColor = Color(int.parse(task.color, radix: 16));
      } catch (_) {}
    }

    if (!isArchived && !isSelected && parsedTaskColor != null) {
      cardColor = Color.alphaBlend(
        parsedTaskColor.withValues(alpha: 0.05), 
        cardColor
      );
    }

    final cardContent = AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: (isCompleted && !isSelected) ? 0.6 : 1.0,
      child: Card(
        elevation: 2,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        color: cardColor,
        child: InkWell(
          onTap: isSelectionMode 
            ? () => ref.read(selectionProvider.notifier).toggle(task.id)
            : () => context.pushNamed(RouteNames.taskDetails, pathParameters: {'id': task.id}),
          onDoubleTap: isSelectionMode 
            ? null 
            : () => ref.read(selectionProvider.notifier).toggle(task.id),
          onLongPress: null, // Let native drag handle long press
          borderRadius: BorderRadius.circular(AppRadius.xl),
          child: Container(
            constraints: const BoxConstraints(minHeight: 80),
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
            padding: const EdgeInsets.all(AppSpacing.md),
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
                        width: 36,
                        height: 36,
                        child: isSelectionMode 
                          ? Icon(
                              isSelected ? Icons.check_circle_rounded : Icons.circle_outlined,
                              color: isSelected ? colorScheme.primary : colorScheme.outline,
                            )
                          : (isArchived 
                            ? const Icon(Icons.archive_outlined, size: 24, color: Colors.grey)
                            : Checkbox(
                                value: isCompleted,
                                onChanged: (_) => _toggleStatus(context, ref),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(AppRadius.sm),
                                ),
                              )),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.sm),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                if (task.isPinned)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 6.0),
                                    child: Icon(
                                      Icons.push_pin_rounded,
                                      size: 16,
                                      color: isArchived ? colorScheme.onSurfaceVariant.withValues(alpha: 0.6) : colorScheme.primary,
                                    ),
                                  ),
                                if (task.note.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 6.0),
                                    child: Icon(
                                      Icons.chat_bubble_outline,
                                      size: 14,
                                      color: isArchived ? colorScheme.onSurfaceVariant.withValues(alpha: 0.6) : colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                if (task.attachments.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 6.0),
                                    child: Icon(
                                      Icons.attach_file,
                                      size: 14,
                                      color: isArchived ? colorScheme.onSurfaceVariant.withValues(alpha: 0.6) : colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                Expanded(
                                  child: AnimatedDefaultTextStyle(
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
                                ),
                              ],
                            ),
                            if (task.subTasks.isNotEmpty)
                              _SubtasksSection(
                                task: task,
                                isSelectionMode: isSelectionMode,
                                isArchived: isArchived,
                                colorScheme: colorScheme,
                                theme: theme,
                              ),
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
                    children: [
                      // LEFT: Tag Chip
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Wrap(
                            spacing: AppSpacing.xs,
                            runSpacing: AppSpacing.xs,
                            children: task.tags.where((tagId) {
                              return tagsList.any((t) => t.id == tagId);
                            }).map((tagId) {
                              final tagModel = tagsList.firstWhere((t) => t.id == tagId);
                              final displayName = tagModel.name;
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: isArchived 
                                    ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.5) 
                                    : colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(AppRadius.sm),
                                ),
                                child: Text(
                                  displayName,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: isArchived ? colorScheme.onSurfaceVariant.withValues(alpha: 0.6) : colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      // CENTER: Repeat indicator icon
                      if (task.repeatRule != RepeatRule.none)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.repeat, 
                                size: 14, 
                                color: isArchived ? colorScheme.primary.withValues(alpha: 0.6) : colorScheme.primary
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _getRepeatLabel(task.repeatRule),
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: isArchived ? colorScheme.primary.withValues(alpha: 0.6) : colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        const SizedBox(width: 20),
                      
                      // RIGHT: Due Date / Time
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Wrap(
                            alignment: WrapAlignment.end,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 4,
                            runSpacing: 2,
                            children: [
                              if (task.dueDate != null)
                                Text(
                                  '${_formatRelativeDate(task.dueDate!, formatter)}${(task.reminder != null || (task.dueDate != null && (task.dueDate!.hour != 0 || task.dueDate!.minute != 0))) ? ',' : ''}',
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: isArchived 
                                        ? colorScheme.onSurfaceVariant.withValues(alpha: 0.6) 
                                        : (isOverdue ? colorScheme.error : colorScheme.onSurfaceVariant),
                                    fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                              if (task.reminder != null || (task.dueDate != null && (task.dueDate!.hour != 0 || task.dueDate!.minute != 0)))
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      task.dueDate != null
                                          ? formatter.formatTime((task.dueDate!.hour != 0 || task.dueDate!.minute != 0) ? task.dueDate! : task.reminder!.triggerTime)
                                          : '${_formatRelativeDate(task.reminder!.triggerTime, formatter)} • ${formatter.formatTime(task.reminder!.triggerTime)}',
                                      style: theme.textTheme.labelMedium?.copyWith(
                                        color: isArchived ? colorScheme.onSurfaceVariant.withValues(alpha: 0.6) : colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(
                                      Icons.alarm,
                                      size: 14,
                                      color: isArchived 
                                          ? colorScheme.onSurfaceVariant.withValues(alpha: 0.6) 
                                          : colorScheme.onSurfaceVariant,
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
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

    final swipeableCard = SwipeableCard(
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

    if (showTimeline) {
      final now = DateTime.now();
      final isToday = task.createdAt.year == now.year &&
                      task.createdAt.month == now.month &&
                      task.createdAt.day == now.day;
      final timeText = isToday
          ? formatter.formatTime(task.createdAt)
          : formatter.formatShortDate(task.createdAt);

      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 65,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _DottedLinePainter(
                        color: colorScheme.outlineVariant.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 28.0), // Align nicely with card text
                    child: Container(
                      color: theme.scaffoldBackgroundColor, // Break the dotted line
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Text(
                        timeText,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: isArchived
                              ? colorScheme.onSurfaceVariant.withValues(alpha: 0.5)
                              : colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8), // Gap before card
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: swipeableCard,
              ),
            ),
          ],
        ),
      );
    }

    return swipeableCard;
  }

  Color _getPriorityColor(Priority priority, ColorScheme colorScheme) {
    switch (priority) {
      case Priority.high:
        return Colors.red;
      case Priority.medium:
        return Colors.orange;
      case Priority.low:
        return Colors.green;
    }
  }
}

class _SubtasksSection extends ConsumerStatefulWidget {
  final Task task;
  final bool isSelectionMode;
  final bool isArchived;
  final ColorScheme colorScheme;
  final ThemeData theme;

  const _SubtasksSection({
    required this.task,
    required this.isSelectionMode,
    required this.isArchived,
    required this.colorScheme,
    required this.theme,
  });

  @override
  ConsumerState<_SubtasksSection> createState() => _SubtasksSectionState();
}

class _SubtasksSectionState extends ConsumerState<_SubtasksSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    final colorScheme = widget.colorScheme;
    final theme = widget.theme;
    final isSelectionMode = widget.isSelectionMode;
    final isArchived = widget.isArchived;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: AppSpacing.xs),
        InkWell(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.account_tree_outlined,
                  size: 16,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  '${task.subTasks.where((s) => s.isCompleted).length}/${task.subTasks.length} Subtasks',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  size: 16,
                  color: colorScheme.primary,
                ),
              ],
            ),
          ),
        ),
        if (_isExpanded) ...[
          const SizedBox(height: AppSpacing.xs),
          ...task.subTasks.map((subTask) {
            return Row(
              children: [
                SizedBox(
                  width: 32,
                  height: 32,
                  child: Checkbox(
                    value: subTask.isCompleted,
                    onChanged: isSelectionMode || isArchived ? null : (bool? val) {
                      if (val != null) {
                        final updatedSubTasks = task.subTasks.map((st) {
                          if (st.id == subTask.id) {
                            return st.copyWith(isCompleted: val);
                          }
                          return st;
                        }).toList();
                        
                        var updatedTask = task.copyWith(
                          subTasks: updatedSubTasks,
                          updatedAt: DateTime.now().toUtc(),
                        );
                        
                        // Auto-sync parent task status based on subtasks
                        final allCompleted = updatedSubTasks.every((st) => st.isCompleted);
                        if (allCompleted && updatedTask.status != TaskStatus.completed) {
                          updatedTask = updatedTask.copyWith(
                            status: TaskStatus.completed,
                            completedAt: DateTime.now().toUtc(),
                          );
                        } else if (!allCompleted && updatedTask.status == TaskStatus.completed) {
                          updatedTask = updatedTask.copyWith(
                            status: TaskStatus.pending,
                            clearCompletedAt: true,
                          );
                        }
                        
                        ref.read(taskNotifierProvider.notifier).updateTask(updatedTask);
                      }
                    },
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
                Expanded(
                  child: Text(
                    subTask.title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      decoration: subTask.isCompleted ? TextDecoration.lineThrough : null,
                      color: isArchived || subTask.isCompleted 
                          ? colorScheme.onSurfaceVariant.withValues(alpha: 0.6) 
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ],
    );
  }
}

class _DottedLinePainter extends CustomPainter {
  final Color color;

  _DottedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    const dashHeight = 4.0;
    const dashSpace = 4.0;
    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _DottedLinePainter oldDelegate) => oldDelegate.color != color;
}
