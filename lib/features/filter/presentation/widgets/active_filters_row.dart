import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pastel_tasks/features/filter/presentation/providers/filter_providers.dart';
import 'package:pastel_tasks/features/filter/domain/enums/smart_date_filter.dart';
import 'package:pastel_tasks/features/sorting/domain/enums/sort_option.dart';
import 'package:pastel_tasks/features/sorting/presentation/providers/sort_providers.dart';
import 'package:pastel_tasks/features/tags/domain/models/tag.dart';
import 'package:pastel_tasks/features/tags/presentation/providers/tag_notifier.dart';

/// A horizontally scrollable row of chips displaying the active filters.
class ActiveFiltersRow extends ConsumerWidget {
  const ActiveFiltersRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterAsync = ref.watch(filterProvider);
    final tagsAsync = ref.watch(tagNotifierProvider);
    final sortPrefs = ref.watch(sortPreferencesProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return filterAsync.when(
      data: (filter) {
        if (!filter.hasActiveFilters && sortPrefs.option == TaskSortOption.manual) {
          return const SizedBox.shrink();
        }

        final chips = <Widget>[];

        // Sort Chip
        if (sortPrefs.option != TaskSortOption.manual) {
          chips.add(_buildFilterChip(
            context,
            label: 'Sort: ${_getSortOptionLabel(sortPrefs.option)}',
            onDeleted: () {
              ref.read(sortPreferencesProvider.notifier).reset();
            },
            colorScheme: colorScheme,
          ));
        }

    // Priority Filters
    if (filter.priorities != null) {
      for (final p in filter.priorities!) {
        chips.add(_buildFilterChip(
          context,
          label: 'Priority: ${p.name}',
          onDeleted: () {
            final updated = List.of(filter.priorities!)..remove(p);
            ref.read(filterProvider.notifier).updateFilter(
                  filter.copyWith(priorities: updated, clearPriorities: updated.isEmpty),
                );
          },
          colorScheme: colorScheme,
        ));
      }
    }

    // Status Filters
    if (filter.statuses != null) {
      for (final s in filter.statuses!) {
        chips.add(_buildFilterChip(
          context,
          label: 'Status: ${s.name}',
          onDeleted: () {
            final updated = List.of(filter.statuses!)..remove(s);
            ref.read(filterProvider.notifier).updateFilter(
                  filter.copyWith(statuses: updated, clearStatuses: updated.isEmpty),
                );
          },
          colorScheme: colorScheme,
        ));
      }
    }

    // Pinned
    if (filter.isPinned == true) {
      chips.add(_buildFilterChip(
        context,
        label: 'Pinned',
        onDeleted: () {
          ref.read(filterProvider.notifier).updateFilter(filter.copyWith(clearPinned: true));
        },
        colorScheme: colorScheme,
      ));
    }

    // Completed
    if (filter.isCompleted == true) {
      chips.add(_buildFilterChip(
        context,
        label: 'Completed',
        onDeleted: () {
          ref.read(filterProvider.notifier).updateFilter(filter.copyWith(clearCompleted: true));
        },
        colorScheme: colorScheme,
      ));
    }
    
    // Smart Date Filter
    if (filter.smartDateFilter != null) {
      chips.add(_buildFilterChip(
        context,
        label: _getSmartDateFilterLabel(filter.smartDateFilter!),
        onDeleted: () {
          ref.read(filterProvider.notifier).updateFilter(filter.copyWith(clearSmartDate: true));
        },
        colorScheme: colorScheme,
      ));
    }
    
    // Has Tags (Untagged)
    if (filter.hasTags == false) {
      chips.add(_buildFilterChip(
        context,
        label: 'Untagged',
        onDeleted: () {
          ref.read(filterProvider.notifier).updateFilter(filter.copyWith(clearHasTags: true));
        },
        colorScheme: colorScheme,
      ));
    }

    if (filter.tags != null && filter.tags!.isNotEmpty) {
      tagsAsync.whenData((allTags) {
        for (final tagId in filter.tags!) {
          final tag = allTags.firstWhere((t) => t.id == tagId, orElse: () => throw Exception('Tag not found'));
          chips.add(_buildFilterChip(
            context,
            label: '#${tag.name}',
            onDeleted: () {
              final updated = List.of(filter.tags!)..remove(tagId);
              ref.read(filterProvider.notifier).updateFilter(
                    filter.copyWith(tags: updated, clearTags: updated.isEmpty),
                  );
            },
            colorScheme: colorScheme,
          ));
        }
      });
    }

    if (chips.isEmpty) {
      return const SizedBox.shrink();
    }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              TextButton.icon(
                onPressed: () {
                  ref.read(filterProvider.notifier).clearAll();
                  ref.read(sortPreferencesProvider.notifier).reset();
                },
                icon: const Icon(Icons.clear_all, size: 18),
                label: const Text('Clear All'),
                style: TextButton.styleFrom(
                  foregroundColor: colorScheme.error,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  minimumSize: const Size(0, 36),
                ),
              ),
              const SizedBox(width: 8),
              ...chips.map((c) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: c,
                  )),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildFilterChip(
    BuildContext context, {
    required String label,
    required VoidCallback onDeleted,
    required ColorScheme colorScheme,
  }) {
    return InputChip(
      label: Text(label),
      onDeleted: onDeleted,
      deleteIconColor: colorScheme.onSecondaryContainer,
      backgroundColor: colorScheme.secondaryContainer,
      labelStyle: TextStyle(
        color: colorScheme.onSecondaryContainer,
        fontSize: 13,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
        return 'Tag';
    }
  }

  String _getSmartDateFilterLabel(SmartDateFilter filter) {
    switch (filter) {
      case SmartDateFilter.today:
        return 'Today';
      case SmartDateFilter.tomorrow:
        return 'Tomorrow';
      case SmartDateFilter.upcoming:
        return 'Upcoming';
      case SmartDateFilter.overdue:
        return 'Overdue';
      case SmartDateFilter.completedToday:
        return 'Completed Today';
    }
  }
}
