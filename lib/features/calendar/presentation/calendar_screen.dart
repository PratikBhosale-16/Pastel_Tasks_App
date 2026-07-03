import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pastel_tasks/features/calendar/presentation/providers/calendar_providers.dart';
import 'package:pastel_tasks/features/calendar/presentation/widgets/agenda_list.dart';
import 'package:pastel_tasks/features/calendar/presentation/widgets/calendar_header.dart';
import 'package:pastel_tasks/features/calendar/presentation/widgets/month_calendar.dart';
import 'package:pastel_tasks/features/search/presentation/providers/search_providers.dart';
import 'package:pastel_tasks/features/search/presentation/widgets/task_search_bar.dart';
import 'package:pastel_tasks/features/tasks/presentation/widgets/task_card/task_card.dart';
import 'package:pastel_tasks/shared/layout/app_scaffold.dart';
import 'package:pastel_tasks/features/smart_lists/presentation/widgets/smart_lists_drawer.dart';

import 'package:go_router/go_router.dart';
import 'package:pastel_tasks/app/router/route_names.dart';
import 'package:pastel_tasks/features/tasks/presentation/widgets/add_task_bottom_sheet/add_task_bottom_sheet.dart';
import 'package:pastel_tasks/features/tasks/presentation/utils/task_creation_helper.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(searchQueryProvider);
    final searchResults = ref.watch(searchedTasksProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppScaffold(
      drawer: const SmartListsDrawer(),
      appBar: AppBar(
        title: _isSearching
            ? const TaskSearchBar()
            : Text(
                'Calendar',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: colorScheme.onSurfaceVariant,
            ),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  ref.read(searchQueryProvider.notifier).clear();
                }
              });
            },
          ),
          const SizedBox(width: 8),
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  // Main Calendar View
                  CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Column(
                          children: const [
                            CalendarHeader(),
                            MonthCalendar(),
                            AgendaList(),
                            SizedBox(height: 100), // padding for FAB
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  // Search Results Overlay
                  if (_isSearching && query.isNotEmpty)
                    Positioned.fill(
                      child: Container(
                        color: theme.scaffoldBackgroundColor,
                        child: (searchResults.value ?? []).isEmpty
                            ? const Center(child: Text('No matching tasks'))
                            : ListView.builder(
                                padding: const EdgeInsets.all(16.0),
                                itemCount: (searchResults.value ?? []).length,
                                itemBuilder: (context, index) {
                                  final task = (searchResults.value ?? [])[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        // Tap result -> scroll to corresponding date
                                        if (task.dueDate != null) {
                                          final date = task.dueDate!;
                                          ref.read(selectedDateProvider.notifier).state =
                                              DateTime(date.year, date.month, date.day);
                                          ref.read(viewingMonthProvider.notifier).state =
                                              DateTime(date.year, date.month, 1);
                                        }
                                        setState(() {
                                          _isSearching = false;
                                          ref.read(searchQueryProvider.notifier).clear();
                                        });
                                      },
                                      child: AbsorbPointer(
                                        child: TaskCard(task: task),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final selectedDate = ref.read(selectedDateProvider);
          TaskCreationHelper.showAddTask(
            context,
            ref,
            initialDate: selectedDate,
            useRootNavigator: true,
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('New Task'),
        elevation: 2,
      ),
    );
  }
}
