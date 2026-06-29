import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pastel_tasks/app/theme/colors.dart';
import 'package:pastel_tasks/features/calendar/presentation/providers/calendar_providers.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/priority.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/task_status.dart';
import 'package:pastel_tasks/features/tasks/domain/models/task.dart';
import 'package:pastel_tasks/features/tasks/presentation/widgets/add_task_bottom_sheet/add_task_bottom_sheet.dart';

class CalendarDayCell extends ConsumerWidget {
  const CalendarDayCell({
    super.key,
    required this.date,
    required this.isCurrentMonth,
  });

  final DateTime date;
  final bool isCurrentMonth;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final monthTasksMap = ref.watch(monthTasksProvider);
    final theme = Theme.of(context);

    final isSelected = date.year == selectedDate.year &&
        date.month == selectedDate.month &&
        date.day == selectedDate.day;

    final now = DateTime.now();
    final isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;

    final tasksForDay = monthTasksMap[DateTime(date.year, date.month, date.day)] ?? [];

    Color textColor = theme.colorScheme.onSurface;
    if (!isCurrentMonth) {
      textColor = theme.colorScheme.onSurfaceVariant.withOpacity(0.5);
    }
    if (isSelected) {
      textColor = theme.colorScheme.primary;
    }

    return GestureDetector(
      onTap: () {
        ref.read(selectedDateProvider.notifier).state = date;
      },
      onLongPress: () {
        ref.read(selectedDateProvider.notifier).state = date;
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => const AddTaskBottomSheet(),
        );
      },
      child: AnimatedScale(
        scale: isSelected ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutBack,
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? theme.colorScheme.primaryContainer : Colors.transparent,
            borderRadius: BorderRadius.circular(12.0),
            border: isToday && !isSelected
                ? Border.all(color: theme.colorScheme.primary.withOpacity(0.5), width: 1.5)
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${date.day}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: textColor,
                  fontWeight: isSelected || isToday ? FontWeight.bold : null,
                ),
              ),
              const SizedBox(height: 4),
              if (tasksForDay.isNotEmpty)
                _buildTaskIndicators(theme, tasksForDay),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskIndicators(ThemeData theme, List<Task> tasks) {
    final displayTasks = tasks.take(3).toList();
    final overflow = tasks.length > 3 ? tasks.length - 3 : 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...displayTasks.map((t) {
          if (t.isPinned) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1.0),
              child: Icon(Icons.push_pin, size: 8, color: theme.colorScheme.primary),
            );
          }
          final isCompleted = t.status == TaskStatus.completed;
          Color dotColor = theme.colorScheme.outline;
          switch (t.priority) {
            case Priority.critical:
              dotColor = AppColors.error;
              break;
            case Priority.high:
              dotColor = AppColors.warning;
              break;
            case Priority.medium:
              dotColor = AppColors.success;
              break;
            case Priority.low:
              dotColor = AppColors.info;
              break;
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1.5),
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted ? Colors.transparent : dotColor,
                border: isCompleted ? Border.all(color: dotColor, width: 1) : null,
              ),
            ),
          );
        }),
        if (overflow > 0)
          Padding(
            padding: const EdgeInsets.only(left: 2.0),
            child: Text(
              '+$overflow',
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 8,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
      ],
    );
  }
}
