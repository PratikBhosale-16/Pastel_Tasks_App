import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pastel_tasks/app/theme/radius.dart';
import 'package:pastel_tasks/features/selection/presentation/providers/selection_providers.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/priority.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/task_status.dart';
import 'package:pastel_tasks/features/tasks/domain/models/task.dart';
import 'package:pastel_tasks/features/tasks/presentation/providers/task_notifier.dart';
import 'package:pastel_tasks/shared/widgets/dialogs/confirmation_dialog.dart';
import 'package:pastel_tasks/shared/widgets/chips/selection_chip.dart';
import 'package:pastel_tasks/features/tags/presentation/providers/tag_notifier.dart';
import 'package:pastel_tasks/features/tags/presentation/widgets/tag_form_bottom_sheet.dart';
import 'package:pastel_tasks/app/theme/colors.dart';

class BulkActionsBottomSheet extends ConsumerWidget {
  const BulkActionsBottomSheet({
    required this.selectedTasks,
    super.key,
  });

  final List<Task> selectedTasks;

  static Future<void> show(BuildContext context, List<Task> selectedTasks) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (_) => BulkActionsBottomSheet(selectedTasks: selectedTasks),
    );
  }

  void _closeAndClear(BuildContext context, WidgetRef ref) {
    Navigator.of(context).pop();
    ref.read(selectionProvider.notifier).clear();
  }

  Future<void> _bulkComplete(BuildContext context, WidgetRef ref) async {
    final notifier = ref.read(taskNotifierProvider.notifier);
    final updatedTasks = selectedTasks.map((t) => t.copyWith(
      status: TaskStatus.completed,
      completedAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
    )).toList();
    await notifier.bulkUpdateTasks(updatedTasks);
    if (context.mounted) _closeAndClear(context, ref);
  }

  Future<void> _bulkIncomplete(BuildContext context, WidgetRef ref) async {
    final notifier = ref.read(taskNotifierProvider.notifier);
    final updatedTasks = selectedTasks.map((t) => t.copyWith(
      status: TaskStatus.pending,
      clearCompletedAt: true,
      updatedAt: DateTime.now().toUtc(),
    )).toList();
    await notifier.bulkUpdateTasks(updatedTasks);
    if (context.mounted) _closeAndClear(context, ref);
  }

  Future<void> _bulkArchive(BuildContext context, WidgetRef ref) async {
    final confirm = await ConfirmationDialog.show(
      context: context,
      title: 'Archive Tasks',
      message: 'Archive ${selectedTasks.length} tasks?',
      confirmText: 'Archive',
      cancelText: 'Cancel',
    );
    if (confirm && context.mounted) {
      final tasksCopy = List<Task>.from(selectedTasks);
      final messenger = ScaffoldMessenger.of(context);
      final themeContext = Theme.of(context);
      
      final notifier = ref.read(taskNotifierProvider.notifier);
      final updatedTasks = selectedTasks.map((t) => t.copyWith(
        status: TaskStatus.archived,
        isArchived: true,
        updatedAt: DateTime.now().toUtc(),
      )).toList();
      await notifier.bulkUpdateTasks(updatedTasks);
      
      if (context.mounted) _closeAndClear(context, ref);

      messenger.clearSnackBars();
      messenger.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Text('${tasksCopy.length} tasks archived'),
              const Spacer(),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: themeContext.colorScheme.inversePrimary,
                ),
                onPressed: () {
                  messenger.hideCurrentSnackBar();
                  notifier.bulkUpdateTasks(tasksCopy);
                },
                child: const Text('UNDO'),
              ),
            ],
          ),
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  Future<void> _bulkRestore(BuildContext context, WidgetRef ref) async {
    final notifier = ref.read(taskNotifierProvider.notifier);
    final updatedTasks = selectedTasks.map((t) => t.copyWith(
      status: TaskStatus.pending,
      isArchived: false,
      updatedAt: DateTime.now().toUtc(),
    )).toList();
    await notifier.bulkUpdateTasks(updatedTasks);
    if (context.mounted) _closeAndClear(context, ref);
  }

  Future<void> _bulkDelete(BuildContext context, WidgetRef ref) async {
    final confirm = await ConfirmationDialog.show(
      context: context,
      title: 'Delete Tasks',
      message: 'Delete ${selectedTasks.length} tasks?\nThis action cannot be undone after the timeout.',
      confirmText: 'Delete',
      cancelText: 'Cancel',
      isDestructive: true,
    );
    if (confirm && context.mounted) {
      final tasksCopy = List<Task>.from(selectedTasks);
      final ids = tasksCopy.map((t) => t.id).toList();
      final messenger = ScaffoldMessenger.of(context);
      final themeContext = Theme.of(context);
      
      final notifier = ref.read(taskNotifierProvider.notifier);
      await notifier.bulkDeleteTasks(ids);
      
      if (context.mounted) _closeAndClear(context, ref);

      messenger.clearSnackBars();
      messenger.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Text('${tasksCopy.length} tasks deleted'),
              const Spacer(),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: themeContext.colorScheme.inversePrimary,
                ),
                onPressed: () {
                  messenger.hideCurrentSnackBar();
                  // For undo, we'd need to create them again. Our repository doesn't have a bulkCreate yet.
                  // Since creating them individually might be slow, we'll loop over create.
                  for (final t in tasksCopy) {
                    notifier.create(t);
                  }
                },
                child: const Text('UNDO'),
              ),
            ],
          ),
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  Future<void> _bulkPin(BuildContext context, WidgetRef ref, bool pin) async {
    final notifier = ref.read(taskNotifierProvider.notifier);
    final updatedTasks = selectedTasks.map((t) => t.copyWith(
      isPinned: pin,
      updatedAt: DateTime.now().toUtc(),
    )).toList();
    await notifier.bulkUpdateTasks(updatedTasks);
    if (context.mounted) _closeAndClear(context, ref);
  }

  Future<void> _bulkChangePriority(BuildContext context, WidgetRef ref) async {
    final priorities = [
      {'label': 'Low', 'value': Priority.low},
      {'label': 'Medium', 'value': Priority.medium},
      {'label': 'High', 'value': Priority.high},
      {'label': 'Critical', 'value': Priority.critical},
    ];

    final result = await showDialog<Priority>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Set Priority'),
          content: Wrap(
            spacing: 8,
            children: priorities.map((p) {
              return SelectionChip(
                label: p['label'] as String,
                isSelected: false,
                onSelected: (selected) {
                  Navigator.of(context).pop(p['value'] as Priority);
                },
              );
            }).toList(),
          ),
        );
      },
    );

    if (result != null && context.mounted) {
      final notifier = ref.read(taskNotifierProvider.notifier);
      final updatedTasks = selectedTasks.map((t) => t.copyWith(
        priority: result,
        updatedAt: DateTime.now().toUtc(),
      )).toList();
      await notifier.bulkUpdateTasks(updatedTasks);
      if (context.mounted) _closeAndClear(context, ref);
    }
  }

  Future<void> _bulkChangeTag(BuildContext context, WidgetRef ref) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Assign Tag'),
          content: Consumer(
            builder: (context, ref, _) {
              final tagsAsync = ref.watch(tagNotifierProvider);
              return SingleChildScrollView(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    SelectionChip(
                      label: 'Clear Tag',
                      isSelected: false,
                      onSelected: (_) => Navigator.of(context).pop(''),
                    ),
                    SelectionChip(
                      label: '+ New Category',
                      isSelected: false,
                      onSelected: (_) async {
                        final newTag = await TagFormBottomSheet.show(context);
                        if (newTag != null && context.mounted) {
                          await ref.read(tagNotifierProvider.notifier).create(newTag);
                          // The provider will update and rebuild the Consumer.
                        }
                      },
                    ),
                    ...tagsAsync.when(
                      data: (tags) => tags.map((t) {
                        return SelectionChip(
                          label: t.name,
                          isSelected: false,
                          onSelected: (_) => Navigator.of(context).pop(t.name),
                        );
                      }),
                      loading: () => [const SizedBox.shrink()],
                      error: (_, __) => [const SizedBox.shrink()],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );

    if (result != null && context.mounted) {
      final notifier = ref.read(taskNotifierProvider.notifier);
      final tags = result.isEmpty ? <String>[] : [result];
      final updatedTasks = selectedTasks.map((t) => t.copyWith(
        tags: tags,
        updatedAt: DateTime.now().toUtc(),
      )).toList();
      await notifier.bulkUpdateTasks(updatedTasks);
      if (context.mounted) _closeAndClear(context, ref);
    }
  }

  Future<void> _bulkChangeColor(BuildContext context, WidgetRef ref) async {
    final presetColors = AppColors.taskColors;

    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Set Color'),
          content: Wrap(
            spacing: 12,
            children: [
              Semantics(
                label: 'Clear color',
                button: true,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(''),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(color: Theme.of(context).colorScheme.outline, width: 2),
                    ),
                    child: const Icon(Icons.close, size: 20),
                  ),
                ),
              ),
              ...presetColors.map((color) {
                return Semantics(
                  label: 'Select color',
                  button: true,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(color.value.toRadixString(16)),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );

    if (result != null && context.mounted) {
      final notifier = ref.read(taskNotifierProvider.notifier);
      final updatedTasks = selectedTasks.map((t) => t.copyWith(
        color: result,
        updatedAt: DateTime.now().toUtc(),
      )).toList();
      await notifier.bulkUpdateTasks(updatedTasks);
      if (context.mounted) _closeAndClear(context, ref);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (selectedTasks.isEmpty) {
      return const SizedBox.shrink();
    }

    final hasIncomplete = selectedTasks.any((t) => t.status != TaskStatus.completed);
    final hasComplete = selectedTasks.any((t) => t.status == TaskStatus.completed);
    final hasUnarchived = selectedTasks.any((t) => !t.isArchived);
    final hasArchived = selectedTasks.any((t) => t.isArchived);
    final hasUnpinned = selectedTasks.any((t) => !t.isPinned);
    final hasPinned = selectedTasks.any((t) => t.isPinned);

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                if (hasIncomplete)
                  ListTile(
                    leading: const Icon(Icons.check_circle_outline),
                    title: const Text('Mark Complete'),
                    onTap: () => _bulkComplete(context, ref),
                  ),
                if (hasComplete)
                  ListTile(
                    leading: const Icon(Icons.radio_button_unchecked),
                    title: const Text('Mark Incomplete'),
                    onTap: () => _bulkIncomplete(context, ref),
                  ),
                if (hasUnpinned)
                  ListTile(
                    leading: const Icon(Icons.push_pin_outlined),
                    title: const Text('Pin'),
                    onTap: () => _bulkPin(context, ref, true),
                  ),
                if (hasPinned)
                  ListTile(
                    leading: const Icon(Icons.push_pin),
                    title: const Text('Unpin'),
                    onTap: () => _bulkPin(context, ref, false),
                  ),
                ListTile(
                  leading: const Icon(Icons.flag_outlined),
                  title: const Text('Change Priority'),
                  onTap: () => _bulkChangePriority(context, ref),
                ),
                ListTile(
                  leading: const Icon(Icons.label_outline),
                  title: const Text('Assign Tag'),
                  onTap: () => _bulkChangeTag(context, ref),
                ),
                ListTile(
                  leading: const Icon(Icons.palette_outlined),
                  title: const Text('Change Color'),
                  onTap: () => _bulkChangeColor(context, ref),
                ),
                const Divider(),
                if (hasUnarchived)
                  ListTile(
                    leading: const Icon(Icons.archive_outlined),
                    title: const Text('Archive'),
                    onTap: () => _bulkArchive(context, ref),
                  ),
                if (hasArchived)
                  ListTile(
                    leading: const Icon(Icons.unarchive_outlined),
                    title: const Text('Restore from Archive'),
                    onTap: () => _bulkRestore(context, ref),
                  ),
                ListTile(
                  leading: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.error),
                  title: Text('Delete', style: TextStyle(color: Theme.of(context).colorScheme.error)),
                  onTap: () => _bulkDelete(context, ref),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
