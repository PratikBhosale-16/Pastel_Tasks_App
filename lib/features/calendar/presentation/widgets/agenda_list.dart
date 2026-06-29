import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pastel_tasks/features/calendar/presentation/providers/calendar_providers.dart';
import 'package:pastel_tasks/features/tasks/presentation/widgets/task_card/task_card.dart';
import 'package:pastel_tasks/features/calendar/presentation/widgets/calendar_empty_state.dart';

class AgendaList extends ConsumerWidget {
  const AgendaList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final tasks = ref.watch(agendaTasksProvider);
    final dateFormat = DateFormat('MMMM d');
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12.0),
          Text(
            'Agenda ${dateFormat.format(selectedDate)}',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12.0),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              final offsetAnimation = Tween<Offset>(
                begin: const Offset(0.0, 0.1),
                end: Offset.zero,
              ).animate(animation);
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: offsetAnimation,
                  child: child,
                ),
              );
            },
            child: tasks.isEmpty
                ? CalendarEmptyState(key: ValueKey('empty-${selectedDate.toIso8601String()}'))
                : Column(
                    key: ValueKey('list-${selectedDate.toIso8601String()}'),
                    children: tasks.map((task) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: TaskCard(task: task),
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }
}
