import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pastel_tasks/features/filter/domain/models/task_filter.dart';
import 'package:pastel_tasks/features/filter/presentation/providers/filter_providers.dart';
import 'package:pastel_tasks/features/tags/domain/models/tag.dart';
import 'package:pastel_tasks/features/tags/presentation/providers/tag_notifier.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/priority.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/task_status.dart';

/// Bottom sheet for selecting task filters.
class FilterBottomSheet extends ConsumerStatefulWidget {
  const FilterBottomSheet({super.key});

  /// Shows the filter bottom sheet.
  static Future<void> show(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => const FilterBottomSheet(),
    );
  }

  @override
  ConsumerState<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<FilterBottomSheet> {
  TaskFilter? _currentFilter;

  @override
  void initState() {
    super.initState();
    // It's safe to read the value if it's already loaded, or default to empty
    _currentFilter = ref.read(filterProvider).value ?? TaskFilter.empty;
  }

  void _applyFilter() {
    if (_currentFilter != null) {
      ref.read(filterProvider.notifier).updateFilter(_currentFilter!);
    }
    Navigator.of(context).pop();
  }

  void _clearAll() {
    setState(() {
      _currentFilter = TaskFilter.empty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final tagsAsync = ref.watch(tagNotifierProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
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
                      'Filters',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: _clearAll,
                      child: const Text('Clear All'),
                    ),
                  ],
                ),
              ),
              const Divider(),
              // Content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  children: [
                    _buildSectionTitle(theme, 'Status'),
                    _buildStatusChips(colorScheme),
                    const SizedBox(height: 24),
                    
                    _buildSectionTitle(theme, 'Priority'),
                    _buildPriorityChips(colorScheme),
                    const SizedBox(height: 24),

                    _buildSectionTitle(theme, 'Quick Filters'),
                    _buildQuickFilters(colorScheme),
                    const SizedBox(height: 24),

                    _buildSectionTitle(theme, 'Tags'),
                    tagsAsync.when(
                      data: (tags) {
                        if (tags.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Text('No tags created yet.'),
                          );
                        }
                        return Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: tags.map<Widget>((tag) {
                            final isSelected = _currentFilter?.tags?.contains(tag.name) ?? false;
                            return FilterChip(
                              label: Text('#${tag.name}'),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  final currentTags = List<String>.from(_currentFilter?.tags ?? []);
                                  if (selected) {
                                    currentTags.add(tag.name);
                                  } else {
                                    currentTags.remove(tag.name);
                                  }
                                  _currentFilter = _currentFilter?.copyWith(
                                    tags: currentTags,
                                    clearTags: currentTags.isEmpty,
                                  );
                                });
                              },
                              selectedColor: colorScheme.primaryContainer,
                              checkmarkColor: colorScheme.onPrimaryContainer,
                            );
                          }).toList(),
                        );
                      },
                      loading: () => const CircularProgressIndicator(),
                      error: (err, stack) => const Text('Error loading tags'),
                    ),
                    const SizedBox(height: 48), // Bottom padding for FAB
                  ],
                ),
              ),
              // Footer Action
              Padding(
                padding: const EdgeInsets.all(24),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: FilledButton(
                    onPressed: _applyFilter,
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Apply Filters',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildStatusChips(ColorScheme colorScheme) {
    if (_currentFilter == null) return const SizedBox.shrink();
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: TaskStatus.values.map((status) {
        final isSelected = _currentFilter!.statuses?.contains(status) ?? false;
        return FilterChip(
          label: Text(status.name[0].toUpperCase() + status.name.substring(1)),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              final currentStatuses = List<TaskStatus>.from(_currentFilter!.statuses ?? []);
              if (selected) {
                currentStatuses.add(status);
              } else {
                currentStatuses.remove(status);
              }
              _currentFilter = _currentFilter!.copyWith(
                statuses: currentStatuses,
                clearStatuses: currentStatuses.isEmpty,
              );
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildPriorityChips(ColorScheme colorScheme) {
    if (_currentFilter == null) return const SizedBox.shrink();
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: Priority.values.map((priority) {
        final isSelected = _currentFilter!.priorities?.contains(priority) ?? false;
        return FilterChip(
          label: Text(priority.name[0].toUpperCase() + priority.name.substring(1)),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              final current = List<Priority>.from(_currentFilter!.priorities ?? []);
              if (selected) {
                current.add(priority);
              } else {
                current.remove(priority);
              }
              _currentFilter = _currentFilter!.copyWith(
                priorities: current,
                clearPriorities: current.isEmpty,
              );
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildQuickFilters(ColorScheme colorScheme) {
    if (_currentFilter == null) return const SizedBox.shrink();
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        FilterChip(
          label: const Text('Pinned'),
          selected: _currentFilter!.isPinned == true,
          onSelected: (selected) {
            setState(() {
              _currentFilter = _currentFilter!.copyWith(
                isPinned: selected ? true : null,
                clearPinned: !selected,
              );
            });
          },
        ),
        FilterChip(
          label: const Text('Completed'),
          selected: _currentFilter!.isCompleted == true,
          onSelected: (selected) {
            setState(() {
              _currentFilter = _currentFilter!.copyWith(
                isCompleted: selected ? true : null,
                clearCompleted: !selected,
              );
            });
          },
        ),
        // Additional quick filters can be added here
      ],
    );
  }
}
