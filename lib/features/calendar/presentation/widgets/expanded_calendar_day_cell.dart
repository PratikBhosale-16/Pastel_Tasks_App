import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pastel_tasks/features/calendar/presentation/providers/calendar_providers.dart';
import 'package:pastel_tasks/features/settings/presentation/providers/settings_providers.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/priority.dart';
import 'package:pastel_tasks/features/tasks/domain/models/task.dart';
import 'package:pastel_tasks/features/tasks/presentation/widgets/add_task_bottom_sheet/add_task_bottom_sheet.dart';
import 'package:go_router/go_router.dart';
import 'package:pastel_tasks/app/router/route_names.dart';

class ExpandedCalendarDayCell extends ConsumerStatefulWidget {
  const ExpandedCalendarDayCell({
    super.key,
    required this.date,
    required this.isCurrentMonth,
  });

  final DateTime date;
  final bool isCurrentMonth;

  @override
  ConsumerState<ExpandedCalendarDayCell> createState() => _ExpandedCalendarDayCellState();
}

class _ExpandedCalendarDayCellState extends ConsumerState<ExpandedCalendarDayCell> {

  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(selectedDateProvider);
    final monthTasksMap = ref.watch(monthTasksProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final accent = ref.watch(calendarAccentProvider);

    final isSelected = widget.date.year == selectedDate.year &&
        widget.date.month == selectedDate.month &&
        widget.date.day == selectedDate.day;

    final now = DateTime.now();
    final isToday = widget.date.year == now.year &&
        widget.date.month == now.month &&
        widget.date.day == now.day;

    final tasksForDay = monthTasksMap[DateTime(widget.date.year, widget.date.month, widget.date.day)] ?? [];

    Color textColor = colorScheme.onSurface;
    if (!widget.isCurrentMonth) {
      textColor = colorScheme.onSurfaceVariant.withValues(alpha: 0.5);
    }
    if (isSelected) {
      textColor = accent.color;
    }

    return GestureDetector(
      onTap: () {
        ref.read(selectedDateProvider.notifier).state = widget.date;
        if (tasksForDay.isNotEmpty) {
          _showExpandedCellDialog(context, theme, textColor, accent.color, tasksForDay);
        }
      },
      onLongPress: () {
        ref.read(selectedDateProvider.notifier).state = widget.date;
        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => const AddTaskBottomSheet(),
        );
      },
      child: Container(
        height: 140,
        margin: const EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          color: isSelected ? accent.color.withValues(alpha: 0.15) : (widget.isCurrentMonth ? colorScheme.surface : colorScheme.surfaceContainerLowest),
          borderRadius: BorderRadius.circular(8.0),
          border: isToday && !isSelected
              ? Border.all(color: accent.color.withValues(alpha: 0.5), width: 1.5)
              : Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 2.0),
              child: Text(
                '${widget.date.day}',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: textColor,
                  fontWeight: isSelected || isToday ? FontWeight.bold : null,
                ),
              ),
            ),
            Expanded(
              child: _buildTasksList(tasksForDay, theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTasksList(List<Task> tasks, ThemeData theme) {
    if (tasks.isEmpty) return const SizedBox.shrink();

    final int maxVisible = 3;
    final bool hasOverflow = tasks.length > maxVisible;

    final visibleTasks = tasks.take(maxVisible).toList();
    final overflowCount = tasks.length - maxVisible;

    return Column(
      children: [
        ...visibleTasks.map((t) => _buildTaskBlock(t, theme)),
        if (hasOverflow)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Text(
              '+$overflowCount more',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }

  void _showExpandedCellDialog(BuildContext context, ThemeData theme, Color textColor, Color accentColor, List<Task> tasksForDay) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(color: accentColor.withValues(alpha: 0.5), width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    '${widget.date.day}',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8.0),
                    itemCount: tasksForDay.length,
                    itemBuilder: (context, index) {
                      final task = tasksForDay[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          context.pushNamed(RouteNames.taskDetails, pathParameters: {'id': task.id});
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 6.0),
                          child: _buildTaskBlock(task, theme, isDialog: true),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8.0),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTaskBlock(Task task, ThemeData theme, {bool isDialog = false}) {
    Color? parsedTaskColor;
    if (task.color.isNotEmpty) {
      try {
        parsedTaskColor = Color(int.parse(task.color, radix: 16));
      } catch (_) {}
    }
    
    // Priority fallback color
    Color fallbackColor = theme.colorScheme.surfaceContainerHighest;
    switch (task.priority) {
      case Priority.high:
        fallbackColor = Colors.red.shade100;
        break;
      case Priority.medium:
        fallbackColor = Colors.orange.shade100;
        break;
      case Priority.low:
        fallbackColor = Colors.green.shade100;
        break;
    }

    final bgColor = parsedTaskColor ?? fallbackColor;
    final textColor = ThemeData.estimateBrightnessForColor(bgColor) == Brightness.light ? Colors.black87 : Colors.white;

    return Container(
      margin: const EdgeInsets.only(bottom: 2.0, left: 2.0, right: 2.0),
      padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: isDialog ? 6.0 : 2.0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(isDialog ? 6.0 : 4.0),
      ),
      child: Row(
        children: [
          Icon(Icons.circle, size: isDialog ? 8 : 6, color: textColor.withValues(alpha: 0.7)),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              task.title,
              style: theme.textTheme.labelSmall?.copyWith(
                color: textColor,
                fontSize: isDialog ? 12 : 9,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
