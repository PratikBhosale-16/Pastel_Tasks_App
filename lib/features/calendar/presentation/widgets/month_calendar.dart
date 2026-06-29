import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pastel_tasks/features/calendar/presentation/providers/calendar_providers.dart';
import 'package:pastel_tasks/features/calendar/presentation/widgets/calendar_day_cell.dart';

class MonthCalendar extends ConsumerWidget {
  const MonthCalendar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewingMonth = ref.watch(viewingMonthProvider);
    final theme = Theme.of(context);

    return Column(
      children: [
        _buildDaysOfWeek(theme),
        const SizedBox(height: 8.0),
        GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity! < 0) {
              // swipe left -> next month
              ref.read(viewingMonthProvider.notifier).update(
                  (state) => DateTime(state.year, state.month + 1, 1));
            } else if (details.primaryVelocity! > 0) {
              // swipe right -> previous month
              ref.read(viewingMonthProvider.notifier).update(
                  (state) => DateTime(state.year, state.month - 1, 1));
            }
          },
          child: AnimatedSwitcher(
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
            child: _buildMonthGrid(viewingMonth),
          ),
        ),
      ],
    );
  }

  Widget _buildDaysOfWeek(ThemeData theme) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: days.map((day) {
          return Expanded(
            child: Center(
              child: Text(
                day,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMonthGrid(DateTime month) {
    // Determine the days to show in the grid
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    
    // Default week starts on Monday in Dart (weekday 1 = Mon ... 7 = Sun)
    final firstWeekday = firstDayOfMonth.weekday;
    
    // How many days from the previous month to show to fill the first row
    final daysFromPrevMonth = firstWeekday - 1;

    final totalCells = daysInMonth + daysFromPrevMonth;
    final rowsCount = (totalCells / 7).ceil();

    final prevMonth = DateTime(month.year, month.month - 1, 1);
    final daysInPrevMonth = DateTime(prevMonth.year, prevMonth.month + 1, 0).day;

    final List<Widget> rows = [];
    for (int r = 0; r < rowsCount; r++) {
      final List<Widget> cells = [];
      for (int c = 0; c < 7; c++) {
        final cellIndex = r * 7 + c;
        if (cellIndex < daysFromPrevMonth) {
          // Previous month days
          final day = daysInPrevMonth - daysFromPrevMonth + cellIndex + 1;
          cells.add(
            Expanded(
              child: CalendarDayCell(
                date: DateTime(month.year, month.month - 1, day),
                isCurrentMonth: false,
              ),
            ),
          );
        } else if (cellIndex >= daysFromPrevMonth + daysInMonth) {
          // Next month days
          final day = cellIndex - (daysFromPrevMonth + daysInMonth) + 1;
          cells.add(
            Expanded(
              child: CalendarDayCell(
                date: DateTime(month.year, month.month + 1, day),
                isCurrentMonth: false,
              ),
            ),
          );
        } else {
          // Current month days
          final day = cellIndex - daysFromPrevMonth + 1;
          cells.add(
            Expanded(
              child: CalendarDayCell(
                date: DateTime(month.year, month.month, day),
                isCurrentMonth: true,
              ),
            ),
          );
        }
      }
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: cells,
          ),
        ),
      );
    }

    return Container(
      key: ValueKey<String>('${month.year}-${month.month}'),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: rows,
      ),
    );
  }
}
