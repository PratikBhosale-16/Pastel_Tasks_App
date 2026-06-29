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

import 'package:go_router/go_router.dart';
import 'package:pastel_tasks/app/router/route_names.dart';
import 'package:pastel_tasks/features/tasks/presentation/widgets/add_task_bottom_sheet/add_task_bottom_sheet.dart';

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

    return AppScaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header / Search Bar area
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: _isSearching
                        ? const TaskSearchBar()
                        : const SizedBox.shrink(),
                  ),
                  if (!_isSearching)
                    const Spacer(),
                  IconButton(
                    icon: Icon(
                      _isSearching ? Icons.close : Icons.search,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                ],
              ),
            ),
            
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
                        color: Theme.of(context).scaffoldBackgroundColor,
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
                                      // We wrap the TaskCard with AbsorbPointer so tapping 
                                      // anywhere jumps to the date rather than triggering 
                                      // the card's own tap actions immediately in the search list.
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
          // The selected date was `ref.read(selectedDateProvider)`
          // Currently AddTaskBottomSheet does not accept initialDate.
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => const AddTaskBottomSheet(),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('New Task'),
        elevation: 2,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 1,
        onDestinationSelected: (idx) {
          if (idx == 0) {
            context.go(RouteNames.homePath);
          } else if (idx == 2) {
            context.push(RouteNames.tagsPath);
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.inbox_rounded),
            label: 'Inbox',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_rounded),
            label: 'Calendar',
          ),
          NavigationDestination(
            icon: Icon(Icons.tag_rounded),
            label: 'Tags',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_rounded),
            label: 'Stats',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_rounded),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
