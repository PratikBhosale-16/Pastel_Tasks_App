import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

import 'package:pastel_tasks/features/tasks/domain/enums/priority.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/repeat_rule.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/task_status.dart';
import 'package:pastel_tasks/features/tasks/domain/models/task.dart';
import 'package:pastel_tasks/features/tasks/presentation/providers/task_notifier.dart';
import 'package:pastel_tasks/features/tasks/presentation/providers/task_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:pastel_tasks/app/router/route_names.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/priority.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/repeat_rule.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/task_status.dart';
import 'package:pastel_tasks/features/tasks/domain/models/task.dart';
import 'package:pastel_tasks/features/tasks/presentation/providers/task_notifier.dart';
import 'package:pastel_tasks/features/tasks/presentation/providers/task_providers.dart';
import 'package:pastel_tasks/features/tasks/presentation/widgets/add_task_bottom_sheet/add_task_bottom_sheet.dart';
import 'package:pastel_tasks/features/tasks/presentation/widgets/task_card/task_card.dart';
import 'package:pastel_tasks/shared/widgets/dialogs/confirmation_dialog.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/priority.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/repeat_rule.dart';
import 'package:pastel_tasks/features/filter/domain/models/task_filter.dart';
import 'package:pastel_tasks/features/filter/presentation/providers/filter_providers.dart';
import 'package:pastel_tasks/features/filter/presentation/widgets/active_filters_row.dart';
import 'package:pastel_tasks/features/filter/presentation/widgets/filter_bottom_sheet.dart';
import 'package:pastel_tasks/features/search/presentation/providers/search_providers.dart';
import 'package:pastel_tasks/features/search/presentation/widgets/task_search_bar.dart';
import 'package:pastel_tasks/features/sorting/domain/enums/sort_option.dart';
import 'package:pastel_tasks/features/sorting/presentation/providers/sort_providers.dart';
import 'package:pastel_tasks/features/filter/presentation/widgets/sort_and_filter_bottom_sheet.dart';
import 'package:pastel_tasks/features/filter/presentation/widgets/active_filters_row.dart';
import 'package:pastel_tasks/features/smart_lists/presentation/widgets/smart_lists_drawer.dart';
import 'package:pastel_tasks/features/selection/presentation/providers/selection_providers.dart';
import 'package:pastel_tasks/features/selection/presentation/widgets/bulk_actions_bottom_sheet.dart';
import 'package:pastel_tasks/shared/widgets/empty_state/empty_state.dart';
import 'package:uuid/uuid.dart';

/// Primary entry point for the task management application.
class HomeScreen extends ConsumerWidget {
  /// Creates the home screen.
  const HomeScreen({super.key});

  Future<void> _showAddTask(BuildContext context, WidgetRef ref) async {
    final formData = await AddTaskBottomSheet.show(context);
    if (formData == null || !context.mounted) return;

    final now = DateTime.now().toUtc();
    
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
        case 'None':
        default: return RepeatRule.none;
      }
    }

    final task = Task(
      id: const Uuid().v4(),
      title: formData.title,
      description: formData.description,
      status: TaskStatus.pending,
      priority: parsePriority(formData.priority),
      tags: formData.tag != null ? [formData.tag!] : [],
      createdAt: now,
      updatedAt: now,
      dueDate: formData.dueDate,
      completedAt: null,
      reminder: null,
      repeatRule: parseRepeatRule(formData.repeatRule),
      position: now.millisecondsSinceEpoch.toDouble(),
      isPinned: formData.isPinned,
      isArchived: false,
      color: formData.color?.value.toRadixString(16) ?? '',
      attachments: const [],
    );

    await ref.read(taskNotifierProvider.notifier).create(task);
    if (!context.mounted) return;

    final state = ref.read(taskNotifierProvider);
    if (state.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to create task')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task created successfully')),
      );
    }
  }



  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'Good Morning!';
    } else if (hour >= 12 && hour < 17) {
      return 'Good Afternoon!';
    } else if (hour >= 17 && hour < 21) {
      return 'Good Evening!';
    } else {
      return 'Good Night!';
    }
  }

  Widget _proxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final double animValue = Curves.easeInOut.transform(animation.value);
        final double elevation = ui.lerpDouble(0, 4, animValue)!;
        final double scale = ui.lerpDouble(1.0, 1.02, animValue)!;
        return DefaultTextStyle.merge(
          style: Theme.of(context).textTheme.bodyMedium,
          child: Transform.scale(
            scale: scale,
            child: Material(
              elevation: elevation,
              color: Colors.transparent,
              shadowColor: Colors.black12,
              child: child,
            ),
          ),
        );
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final taskListAsync = ref.watch(sortedTasksProvider);
    final sortPrefs = ref.watch(sortPreferencesProvider);
    final isManualSort = sortPrefs.option == TaskSortOption.manual;
    final todayStr = DateFormat.yMMMMd().format(DateTime.now());
    
    final isSelectionMode = ref.watch(isSelectionModeProvider);
    final selectionCount = ref.watch(selectionCountProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: isSelectionMode ? null : const SmartListsDrawer(),
      appBar: isSelectionMode
          ? AppBar(
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => ref.read(selectionProvider.notifier).clear(),
              ),
              title: Text('$selectionCount Selected'),
              actions: [
                TextButton(
                  onPressed: () {
                    final tasks = ref.read(sortedTasksProvider).valueOrNull;
                    if (tasks != null) {
                      final allIds = tasks.where((t) => !t.isArchived).map((t) => t.id).toList();
                      ref.read(selectionProvider.notifier).selectAll(allIds);
                    }
                  },
                  child: const Text('Select All'),
                ),
              ],
            )
          : AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                _getGreeting(),
                maxLines: 1,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            Text(
              todayStr,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.archive_outlined),
            tooltip: 'Archived Tasks',
            onPressed: () {
              context.push(RouteNames.archivePath);
            },
          ),
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            tooltip: 'Sort & Filter Tasks',
            onPressed: () {
              SortAndFilterBottomSheet.show(context);
            },
          ),
          const SizedBox(width: 8),
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          const TaskSearchBar(),
          const ActiveFiltersRow(),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: taskListAsync.when(
          data: (tasks) {
            // Check active/completed tasks only since watchAll doesn't filter.
            // But if the user expects all tasks to be shown here, we'll leave it.
            final displayTasks = tasks.toList();
            if (displayTasks.isEmpty) {
              final filter = ref.read(filterProvider).valueOrNull ?? TaskFilter.empty;
              final searchQuery = ref.read(debouncedSearchQueryProvider);
              final hasActiveFilters = filter != TaskFilter.empty || searchQuery.isNotEmpty;
              
              if (hasActiveFilters) {
                return EmptyState(
                  key: const ValueKey('empty_state_filtered'),
                  title: 'No matching tasks',
                  subtitle: 'Try adjusting your filters or search query.',
                  illustration: Icons.search_off_rounded,
                  primaryActionLabel: 'Clear Filters',
                  onPrimaryAction: () {
                    ref.read(filterProvider.notifier).clearAll();
                    ref.read(searchQueryProvider.notifier).state = '';
                  },
                );
              } else {
                return EmptyState.taskList(
                  key: const ValueKey('empty_state'),
                  onPrimaryAction: () => _showAddTask(context, ref),
                );
              }
            }

            final pinnedTasks = displayTasks.where((t) => t.isPinned && t.status != TaskStatus.completed).toList();
            final pendingTasks = displayTasks.where((t) => !t.isPinned && t.status != TaskStatus.completed).toList();
            final completedTasks = displayTasks.where((t) => t.status == TaskStatus.completed).toList();

            return CustomScrollView(
              key: const ValueKey('home_scroll_view'),
              slivers: [
                const SliverPadding(padding: EdgeInsets.only(top: 24)),
                if (pinnedTasks.isNotEmpty) ...[
                  SliverPadding(
                    padding: const EdgeInsets.only(left: 20, right: 20, bottom: 8),
                    sliver: SliverToBoxAdapter(
                      child: Row(
                        children: [
                          Icon(Icons.push_pin_rounded, size: 18, color: colorScheme.primary),
                          const SizedBox(width: 8),
                          Text('Pinned', style: theme.textTheme.labelLarge?.copyWith(color: colorScheme.primary)),
                        ],
                      ),
                    ),
                  ),
                  SliverReorderableList(
                    proxyDecorator: _proxyDecorator,
                    itemCount: pinnedTasks.length,
                    onReorder: isManualSort ? (oldIndex, newIndex) {
                      if (newIndex > oldIndex) newIndex -= 1;
                      final tasksCopy = List<Task>.from(pinnedTasks);
                      final task = tasksCopy.removeAt(oldIndex);
                      tasksCopy.insert(newIndex, task);
                      final orderedIds = tasksCopy.map((t) => t.id).toList();
                      ref.read(taskNotifierProvider.notifier).reorder(orderedIds);
                    } : (_, __) {},
                    itemBuilder: (context, index) {
                      final task = pinnedTasks[index];
                      final child = Padding(
                        padding: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
                        child: TaskCard(task: task),
                      );
                      if (isSelectionMode) {
                        return KeyedSubtree(key: ValueKey(task.id), child: child);
                      }
                      return ReorderableDelayedDragStartListener(
                        key: ValueKey(task.id),
                        index: index,
                        enabled: isManualSort,
                        child: child,
                      );
                    },
                  ),
                ],
                if (pendingTasks.isNotEmpty) ...[
                  if (pinnedTasks.isNotEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text('Tasks', style: theme.textTheme.labelLarge?.copyWith(color: colorScheme.onSurfaceVariant)),
                      ),
                    ),
                  SliverReorderableList(
                    proxyDecorator: _proxyDecorator,
                    itemCount: pendingTasks.length,
                    onReorder: isManualSort ? (oldIndex, newIndex) {
                      if (newIndex > oldIndex) newIndex -= 1;
                      final tasksCopy = List<Task>.from(pendingTasks);
                      final task = tasksCopy.removeAt(oldIndex);
                      tasksCopy.insert(newIndex, task);
                      final orderedIds = tasksCopy.map((t) => t.id).toList();
                      ref.read(taskNotifierProvider.notifier).reorder(orderedIds);
                    } : (_, __) {},
                    itemBuilder: (context, index) {
                      final task = pendingTasks[index];
                      final child = Padding(
                        padding: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
                        child: TaskCard(task: task),
                      );
                      if (isSelectionMode) {
                        return KeyedSubtree(key: ValueKey(task.id), child: child);
                      }
                      return ReorderableDelayedDragStartListener(
                        key: ValueKey(task.id),
                        index: index,
                        enabled: isManualSort,
                        child: child,
                      );
                    },
                  ),
                ],
                if (completedTasks.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Row(
                        children: [
                          Expanded(child: Divider(color: colorScheme.outlineVariant)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text('Completed', style: theme.textTheme.labelMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
                          ),
                          Expanded(child: Divider(color: colorScheme.outlineVariant)),
                        ],
                      ),
                    ),
                  ),
                  SliverReorderableList(
                    proxyDecorator: _proxyDecorator,
                    itemCount: completedTasks.length,
                    onReorder: isManualSort ? (oldIndex, newIndex) {
                      if (newIndex > oldIndex) newIndex -= 1;
                      final tasksCopy = List<Task>.from(completedTasks);
                      final task = tasksCopy.removeAt(oldIndex);
                      tasksCopy.insert(newIndex, task);
                      final orderedIds = tasksCopy.map((t) => t.id).toList();
                      ref.read(taskNotifierProvider.notifier).reorder(orderedIds);
                    } : (_, __) {},
                    itemBuilder: (context, index) {
                      final task = completedTasks[index];
                      final child = Padding(
                        padding: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
                        child: TaskCard(task: task),
                      );
                      if (isSelectionMode) {
                        return KeyedSubtree(key: ValueKey(task.id), child: child);
                      }
                      return ReorderableDelayedDragStartListener(
                        key: ValueKey(task.id),
                        index: index,
                        enabled: isManualSort,
                        child: child,
                      );
                    },
                  ),
                ],
                const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
              ],
            );
          },
          error: (error, stack) => Center(child: Text('Error: $error')),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    ),
  ],
),
floatingActionButton: isSelectionMode 
    ? FloatingActionButton.extended(
        onPressed: () {
          final tasks = ref.read(sortedTasksProvider).valueOrNull ?? [];
          final selectedTasks = tasks.where((t) => ref.read(selectionProvider).contains(t.id)).toList();
          BulkActionsBottomSheet.show(context, selectedTasks);
        },
        icon: const Icon(Icons.bolt_rounded),
        label: const Text('Actions'),
        elevation: 2,
        backgroundColor: colorScheme.secondaryContainer,
        foregroundColor: colorScheme.onSecondaryContainer,
      )
    : FloatingActionButton.extended(
        onPressed: () => _showAddTask(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('New Task'),
        elevation: 2,
      ),

    );
  }
}

