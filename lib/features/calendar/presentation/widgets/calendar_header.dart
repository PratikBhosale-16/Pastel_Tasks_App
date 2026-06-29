import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pastel_tasks/features/calendar/presentation/providers/calendar_providers.dart';

class CalendarHeader extends ConsumerWidget {
  const CalendarHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewingMonth = ref.watch(viewingMonthProvider);
    final monthFormat = DateFormat('MMMM yyyy');
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 12.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            monthFormat.format(viewingMonth),
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.chevron_left, color: theme.colorScheme.onSurfaceVariant),
                onPressed: () {
                  ref.read(viewingMonthProvider.notifier).update((state) =>
                      DateTime(state.year, state.month - 1, 1));
                },
              ),
              IconButton(
                icon: Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
                onPressed: () {
                  ref.read(viewingMonthProvider.notifier).update((state) =>
                      DateTime(state.year, state.month + 1, 1));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
