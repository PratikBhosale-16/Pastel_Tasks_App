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
          GestureDetector(
            onTap: () async {
              final selectedDate = await showDialog<DateTime>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Select Year'),
                    content: SizedBox(
                      width: 300,
                      height: 300,
                      child: YearPicker(
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        initialDate: viewingMonth,
                        selectedDate: viewingMonth,
                        onChanged: (DateTime dateTime) {
                          Navigator.pop(context, dateTime);
                        },
                      ),
                    ),
                  );
                },
              );
              if (selectedDate != null) {
                ref.read(viewingMonthProvider.notifier).update((state) => 
                  DateTime(selectedDate.year, state.month, 1));
              }
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  monthFormat.format(viewingMonth),
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.arrow_drop_down, color: theme.colorScheme.onSurfaceVariant),
              ],
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
