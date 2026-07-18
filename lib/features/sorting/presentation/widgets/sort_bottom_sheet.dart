import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pastel_tasks/features/sorting/domain/enums/sort_option.dart';
import 'package:pastel_tasks/features/sorting/domain/enums/sort_order.dart';
import 'package:pastel_tasks/features/sorting/presentation/providers/sort_providers.dart';

/// Bottom sheet for selecting task sorting options.
class SortBottomSheet extends ConsumerWidget {
  const SortBottomSheet({super.key});

  /// Shows the sort bottom sheet.
  static Future<void> show(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => const SortBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final sortPrefs = ref.watch(sortPreferencesProvider);

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
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
                  'Sort By',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    ref.read(sortPreferencesProvider.notifier).reset();
                  },
                  child: const Text('Reset'),
                ),
              ],
            ),
          ),
          const Divider(),
          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      selectedColor: colorScheme.primaryContainer,
                      checkmarkColor: colorScheme.onPrimaryContainer,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    'Order',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: FilterChip(
                        label: const Center(child: Text('Ascending')),
                        selected: sortPrefs.order == TaskSortOrder.ascending,
                        onSelected: (_) {
                          ref.read(sortPreferencesProvider.notifier).setSortOrder(TaskSortOrder.ascending);
                        },
                        selectedColor: colorScheme.primaryContainer,
                        checkmarkColor: colorScheme.onPrimaryContainer,
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
                        selectedColor: colorScheme.primaryContainer,
                        checkmarkColor: colorScheme.onPrimaryContainer,
                      ),
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
    }
  }
}
