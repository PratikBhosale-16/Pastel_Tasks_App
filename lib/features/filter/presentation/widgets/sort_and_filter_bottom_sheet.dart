import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pastel_tasks/app/theme/colors.dart';
import 'package:pastel_tasks/features/filter/domain/enums/smart_date_filter.dart';
import 'package:pastel_tasks/features/filter/domain/models/task_filter.dart';
import 'package:pastel_tasks/features/filter/presentation/providers/filter_providers.dart';
import 'package:pastel_tasks/features/sorting/domain/enums/sort_option.dart';
import 'package:pastel_tasks/features/sorting/domain/enums/sort_order.dart';
import 'package:pastel_tasks/features/sorting/presentation/providers/sort_providers.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/priority.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/repeat_rule.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/task_status.dart';
import 'package:pastel_tasks/features/tasks/presentation/providers/tag_providers.dart';

final sortingExpandedProvider = StateProvider<bool>((ref) => false);

/// Unified bottom sheet for selecting task sorting and filtering options.
class SortAndFilterBottomSheet extends ConsumerWidget {
  const SortAndFilterBottomSheet({super.key});

  /// Shows the bottom sheet.
  static Future<void> show(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => const SortAndFilterBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final sortPrefs = ref.watch(sortPreferencesProvider);
    final filterAsync = ref.watch(filterProvider);
    final filter = filterAsync.valueOrNull ?? TaskFilter.empty;

    void updateFilter(TaskFilter newFilter) {
      ref.read(filterProvider.notifier).updateFilter(newFilter);
    }

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.9,
      ),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 16),
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sort & Filter',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    ref.read(sortPreferencesProvider.notifier).reset();
                    ref.read(filterProvider.notifier).clearAll();
                  },
                  child: const Text('Clear All'),
                ),
              ],
            ),
          ),
          const Divider(),
          // Content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                // SORTING
                ExpansionTile(
                  title: const Text('Sorting', style: TextStyle(fontWeight: FontWeight.w600)),
                  initiallyExpanded: ref.watch(sortingExpandedProvider),
                  onExpansionChanged: (expanded) {
                    ref.read(sortingExpandedProvider.notifier).state = expanded;
                  },
                  childrenPadding: const EdgeInsets.all(16),
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: TaskSortOption.values.map((option) {
                        final isSelected = sortPrefs.option == option;
                        return FilterChip(
                          label: Text(_getSortOptionLabel(option)),
                          selected: isSelected,
                          onSelected: (_) {
                            ref.read(sortPreferencesProvider.notifier).setSortOption(option);
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: FilterChip(
                            label: const Center(child: Text('Ascending')),
                            selected: sortPrefs.order == TaskSortOrder.ascending,
                            onSelected: (_) {
                              ref.read(sortPreferencesProvider.notifier).setSortOrder(TaskSortOrder.ascending);
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: FilterChip(
                            label: const Center(child: Text('Descending')),
                            selected: sortPrefs.order == TaskSortOrder.descending,
                            onSelected: (_) {
                              ref.read(sortPreferencesProvider.notifier).setSortOrder(TaskSortOrder.descending);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                
                // STATUS
                ExpansionTile(
                  title: const Text('Status', style: TextStyle(fontWeight: FontWeight.w600)),
                  childrenPadding: const EdgeInsets.all(16),
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: TaskStatus.values.map((status) {
                        final isSelected = filter.statuses?.contains(status) ?? false;
                        return FilterChip(
                          label: Text(status.name[0].toUpperCase() + status.name.substring(1)),
                          selected: isSelected,
                          onSelected: (selected) {
                            final current = List<TaskStatus>.from(filter.statuses ?? []);
                            if (selected) current.add(status);
                            else current.remove(status);
                            updateFilter(filter.copyWith(statuses: current, clearStatuses: current.isEmpty));
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),

                // PROPERTIES
                ExpansionTile(
                  title: const Text('Properties', style: TextStyle(fontWeight: FontWeight.w600)),
                  childrenPadding: const EdgeInsets.all(16),
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        FilterChip(
                          label: const Text('Archived'),
                          selected: filter.isArchived == true,
                          onSelected: (selected) {
                            updateFilter(filter.copyWith(isArchived: selected ? true : null, clearArchived: !selected));
                          },
                        ),
                        FilterChip(
                          label: const Text('Repeating'),
                          selected: filter.repeatRules != null && filter.repeatRules!.isNotEmpty,
                          onSelected: (selected) {
                            if (selected) {
                              updateFilter(filter.copyWith(repeatRules: [RepeatRule.daily, RepeatRule.weekly, RepeatRule.monthly, RepeatRule.yearly]));
                            } else {
                              updateFilter(filter.copyWith(clearRepeatRules: true));
                            }
                          },
                        ),
                        FilterChip(
                          label: const Text('No Due Date'),
                          selected: filter.hasDueDate == false,
                          onSelected: (selected) {
                            updateFilter(filter.copyWith(hasDueDate: selected ? false : null, clearDueDate: !selected));
                          },
                        ),
                        FilterChip(
                          label: const Text('Pinned'),
                          selected: filter.isPinned == true,
                          onSelected: (selected) {
                            updateFilter(filter.copyWith(isPinned: selected ? true : null, clearPinned: !selected));
                          },
                        ),
                      ],
                    ),
                  ],
                ),

                // PRIORITY
                ExpansionTile(
                  title: const Text('Priority', style: TextStyle(fontWeight: FontWeight.w600)),
                  childrenPadding: const EdgeInsets.all(16),
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: Priority.values.map((priority) {
                        final isSelected = filter.priorities?.contains(priority) ?? false;
                        return FilterChip(
                          label: Text(priority.name[0].toUpperCase() + priority.name.substring(1)),
                          selected: isSelected,
                          onSelected: (selected) {
                            final current = List<Priority>.from(filter.priorities ?? []);
                            if (selected) current.add(priority);
                            else current.remove(priority);
                            updateFilter(filter.copyWith(priorities: current, clearPriorities: current.isEmpty));
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),

                // COLOR
                ExpansionTile(
                  title: const Text('Color', style: TextStyle(fontWeight: FontWeight.w600)),
                  childrenPadding: const EdgeInsets.all(16),
                  children: [
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: AppColors.taskColors.map((colorValue) {
                        final colorStr = colorValue.value.toRadixString(16);
                        final isSelected = filter.colors?.contains(colorStr) ?? false;
                        return GestureDetector(
                          onTap: () {
                            final current = List<String>.from(filter.colors ?? []);
                            if (!isSelected) current.add(colorStr);
                            else current.remove(colorStr);
                            updateFilter(filter.copyWith(colors: current, clearColors: current.isEmpty));
                          },
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: colorValue,
                              shape: BoxShape.circle,
                              border: isSelected ? Border.all(color: theme.colorScheme.primary, width: 3) : null,
                            ),
                            child: isSelected ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),

                // TAGS
                ExpansionTile(
                  title: const Text('Categories', style: TextStyle(fontWeight: FontWeight.w600)),
                  childrenPadding: const EdgeInsets.all(16),
                  children: [
                    Consumer(
                      builder: (context, ref, child) {
                        final tagsAsync = ref.watch(tagListProvider);
                        return tagsAsync.when(
                          data: (tags) {
                            if (tags.isEmpty) return const Text('No tags created yet.');
                            return Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: tags.map((tag) {
                                final isSelected = filter.tags?.contains(tag.id) ?? false;
                                return FilterChip(
                                  label: Text('#${tag.name}'),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    final current = List<String>.from(filter.tags ?? []);
                                    if (selected) current.add(tag.id);
                                    else current.remove(tag.id);
                                    updateFilter(filter.copyWith(tags: current, clearTags: current.isEmpty));
                                  },
                                );
                              }).toList(),
                            );
                          },
                          loading: () => const CircularProgressIndicator(),
                          error: (err, stack) => const Text('Error loading tags'),
                        );
                      },
                    ),
                  ],
                ),

                // DATES
                ExpansionTile(
                  title: const Text('Dates', style: TextStyle(fontWeight: FontWeight.w600)),
                  childrenPadding: const EdgeInsets.all(16),
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: SmartDateFilter.values.map((dFilter) {
                        final isSelected = filter.smartDateFilter == dFilter;
                        return FilterChip(
                          label: Text(_getDateFilterLabel(dFilter)),
                          selected: isSelected,
                          onSelected: (selected) {
                            updateFilter(filter.copyWith(
                              smartDateFilter: selected ? dFilter : null,
                              clearSmartDate: !selected,
                            ));
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),

                // REPEAT
                ExpansionTile(
                  title: const Text('Repeat', style: TextStyle(fontWeight: FontWeight.w600)),
                  childrenPadding: const EdgeInsets.all(16),
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: RepeatRule.values.where((r) => r != RepeatRule.none).map((rule) {
                        final isSelected = filter.repeatRules?.contains(rule) ?? false;
                        return FilterChip(
                          label: Text(rule.name[0].toUpperCase() + rule.name.substring(1)),
                          selected: isSelected,
                          onSelected: (selected) {
                            final current = List<RepeatRule>.from(filter.repeatRules ?? []);
                            if (selected) current.add(rule);
                            else current.remove(rule);
                            updateFilter(filter.copyWith(repeatRules: current, clearRepeatRules: current.isEmpty));
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
                
                // QUICK FILTERS
                ExpansionTile(
                  title: const Text('Quick Filters', style: TextStyle(fontWeight: FontWeight.w600)),
                  childrenPadding: const EdgeInsets.all(16),
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        FilterChip(
                          label: const Text('Pinned'),
                          selected: filter.isPinned == true,
                          onSelected: (selected) {
                            updateFilter(filter.copyWith(
                              isPinned: selected ? true : null,
                              clearPinned: !selected,
                            ));
                          },
                        ),
                        FilterChip(
                          label: const Text('Unpinned'),
                          selected: filter.isPinned == false,
                          onSelected: (selected) {
                            updateFilter(filter.copyWith(
                              isPinned: selected ? false : null,
                              clearPinned: !selected,
                            ));
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Done',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getSortOptionLabel(TaskSortOption option) {
    switch (option) {
      case TaskSortOption.manual:
        return 'Manual';
      case TaskSortOption.createdDate:
        return 'Created Date';
      case TaskSortOption.updatedDate:
        return 'Updated Date';
      case TaskSortOption.dueDate:
        return 'Due Date';
      case TaskSortOption.reminderDate:
        return 'Reminder Date';
      case TaskSortOption.priority:
        return 'Priority';
      case TaskSortOption.alphabetical:
        return 'Alphabetical';
      case TaskSortOption.pinnedFirst:
        return 'Pinned First';
      case TaskSortOption.completedLast:
        return 'Completed Last';
      case TaskSortOption.color:
        return 'Color';
      case TaskSortOption.tag:
        return 'Category';
      case TaskSortOption.repeat:
        return 'Repeat';
    }
  }

  String _getDateFilterLabel(SmartDateFilter filter) {
    switch (filter) {
      case SmartDateFilter.today: return 'Today';
      case SmartDateFilter.tomorrow: return 'Tomorrow';
      case SmartDateFilter.upcoming: return 'Upcoming';
      case SmartDateFilter.overdue: return 'Overdue';
      case SmartDateFilter.completedToday: return 'Completed Today';
      case SmartDateFilter.thisWeek: return 'This Week';
      case SmartDateFilter.thisMonth: return 'This Month';
    }
  }
}
