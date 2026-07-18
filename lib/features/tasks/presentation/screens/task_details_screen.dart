import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pastel_tasks/features/tasks/domain/models/sub_task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pastel_tasks/app/providers/date_time_format_provider.dart';
import 'package:pastel_tasks/app/theme/spacing.dart';
import 'package:pastel_tasks/features/tags/presentation/providers/tag_notifier.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/repeat_rule.dart';
import 'package:pastel_tasks/features/tasks/domain/models/task.dart';
import 'package:pastel_tasks/features/tasks/presentation/providers/task_notifier.dart';
import 'package:pastel_tasks/features/tasks/presentation/providers/task_providers.dart';
import 'package:pastel_tasks/features/tasks/presentation/widgets/add_task_bottom_sheet/add_task_bottom_sheet.dart';
import 'package:pastel_tasks/shared/widgets/dialogs/confirmation_dialog.dart';
import 'package:pastel_tasks/features/tasks/presentation/widgets/add_task_bottom_sheet/date_time_picker_bottom_sheet.dart';
import 'package:pastel_tasks/features/tasks/domain/models/reminder.dart';
import 'package:pastel_tasks/features/tasks/presentation/widgets/category_selection_bottom_sheet.dart';
import 'package:uuid/uuid.dart';

class TaskDetailsScreen extends ConsumerStatefulWidget {
  final String taskId;

  const TaskDetailsScreen({super.key, required this.taskId});

  @override
  ConsumerState<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends ConsumerState<TaskDetailsScreen> {
  bool _isEditingTitle = false;
  bool _isEditingNote = false;
  late TextEditingController _titleController;
  late TextEditingController _noteController;
  final FocusNode _titleFocus = FocusNode();
  final FocusNode _noteFocus = FocusNode();
  Task? _lastTask;

  String? _editingSubtaskId;
  late final TextEditingController _subTaskController;
  late final FocusNode _subTaskFocus;
  DateTime _lastNoteSaveTime = DateTime.fromMillisecondsSinceEpoch(0);

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _noteController = TextEditingController();
    _subTaskController = TextEditingController();
    _subTaskFocus = FocusNode();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    _subTaskController.dispose();
    _titleFocus.dispose();
    _noteFocus.dispose();
    _subTaskFocus.dispose();
    super.dispose();
  }

  Task? _getTask(WidgetRef ref) {
    final tasks = ref.watch(taskListProvider).valueOrNull ?? [];
    return tasks.where((t) => t.id == widget.taskId).firstOrNull;
  }

  Future<void> _saveTitle(Task task) async {
    setState(() { _isEditingTitle = false; });
    if (_titleController.text.trim().isEmpty) return;
    if (_titleController.text.trim() == task.title) return;
    
    final updatedTask = task.copyWith(
      title: _titleController.text.trim(),
      updatedAt: DateTime.now().toUtc(),
    );
    await ref.read(taskNotifierProvider.notifier).updateTask(updatedTask);
  }

  Future<void> _saveNote(Task task) async {
    _lastNoteSaveTime = DateTime.now();
    setState(() { _isEditingNote = false; });
    if (_noteController.text.trim() == task.note) return;
    
    final updatedTask = task.copyWith(
      note: _noteController.text.trim(),
      updatedAt: DateTime.now().toUtc(),
    );
    await ref.read(taskNotifierProvider.notifier).updateTask(updatedTask);
  }

  Future<void> _saveSubTask(Task task) async {
    final text = _subTaskController.text.trim();
    if (text.isEmpty && _editingSubtaskId != 'NEW') {
      // Empty text on an existing subtask could mean delete, or just ignore
      setState(() { _editingSubtaskId = null; });
      return;
    }
    
    if (text.isEmpty) {
      setState(() { _editingSubtaskId = null; });
      return;
    }

    final newSubTasks = List<SubTask>.from(task.subTasks);
    if (_editingSubtaskId == 'NEW') {
      newSubTasks.add(SubTask(id: const Uuid().v4(), title: text));
    } else {
      final index = newSubTasks.indexWhere((s) => s.id == _editingSubtaskId);
      if (index != -1) {
        newSubTasks[index] = newSubTasks[index].copyWith(title: text);
      }
    }

    setState(() { _editingSubtaskId = null; });
    final updatedTask = task.copyWith(
      subTasks: newSubTasks,
      updatedAt: DateTime.now().toUtc(),
    );
    await ref.read(taskNotifierProvider.notifier).updateTask(updatedTask);
  }

  Future<void> _editDateTimePicker(BuildContext context, Task task) async {
    final result = await DateTimePickerBottomSheet.show(
      context,
      initialDueDate: task.dueDate,
      initialTime: (task.dueDate != null && (task.dueDate!.hour != 0 || task.dueDate!.minute != 0 || task.reminder != null)) ? TimeOfDay.fromDateTime(task.dueDate!) : null,
      initialReminderTime: task.reminder != null ? TimeOfDay.fromDateTime(task.reminder!.triggerTime) : null,
      initialRepeatRule: task.repeatRule,
      initialRepeatEndDate: task.repeatEndDate,
      initialRepeatCount: task.repeatCount,
    );

    if (result != null && mounted) {
      DateTime? updatedDueDate = result.dueDate;
      if (updatedDueDate != null) {
        if (result.time != null) {
          updatedDueDate = DateTime(
            updatedDueDate.year,
            updatedDueDate.month,
            updatedDueDate.day,
            result.time!.hour,
            result.time!.minute,
          );
        } else {
          updatedDueDate = DateTime(
            updatedDueDate.year,
            updatedDueDate.month,
            updatedDueDate.day,
          );
        }
      }

      Reminder? updatedReminder;
      if (result.reminderTime != null) {
        final reminderTime = updatedDueDate != null 
            ? DateTime(updatedDueDate.year, updatedDueDate.month, updatedDueDate.day, result.reminderTime!.hour, result.reminderTime!.minute)
            : DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, result.reminderTime!.hour, result.reminderTime!.minute);
        
        updatedReminder = Reminder(
          id: task.reminder?.id ?? const Uuid().v4(),
          taskId: task.id,
          triggerTime: reminderTime,
          repeatRule: result.repeatRule,
          enabled: true,
        );
      }

      final updatedTask = task.copyWith(
        dueDate: updatedDueDate,
        clearDueDate: updatedDueDate == null,
        reminder: updatedReminder,
        clearReminder: updatedReminder == null,
        repeatRule: result.repeatRule,
        repeatEndDate: result.repeatEndDate,
        repeatCount: result.repeatCount,
        updatedAt: DateTime.now().toUtc(),
      );

      await ref.read(taskNotifierProvider.notifier).updateTask(updatedTask);
    }
  }

  Future<void> _editCategory(BuildContext context, Task task) async {
    final tags = ref.read(tagNotifierProvider).valueOrNull ?? [];
    final currentTagId = task.tags.isNotEmpty ? task.tags.first : null;

    final newTagId = await CategorySelectionBottomSheet.show(
      context,
      tags: tags,
      currentTagId: currentTagId,
    );

    if (newTagId != null && mounted) {
      if (newTagId == 'CREATE_NEW') {
        // Handled directly inside bottom sheet now
      } else {
        final List<String> newTags = newTagId == 'NO_CATEGORY' ? [] : [newTagId];
        final updatedTask = task.copyWith(
          tags: newTags,
          updatedAt: DateTime.now().toUtc(),
        );
        await ref.read(taskNotifierProvider.notifier).updateTask(updatedTask);
      }
    }
  }

  Future<void> _pickAttachment(Task task) async {
    final status = await Permission.storage.request();
    if (status.isDenied) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Storage permission is required to pick files.')),
        );
      }
      // Depending on the OS, we might still proceed because file_picker uses SAF which doesn't need manifest permission,
      // but let's try calling file picker anyway since on Android 13+ it returns denied for storage but SAF works.
    }

    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
    );

    if (result != null && result.files.isNotEmpty) {
      final appDir = await getApplicationDocumentsDirectory();
      final attachmentsDir = Directory('${appDir.path}/attachments');
      if (!await attachmentsDir.exists()) {
        await attachmentsDir.create(recursive: true);
      }

      final newAttachments = List<String>.from(task.attachments);
      
      for (final file in result.files) {
        if (file.path != null) {
          final originalFile = File(file.path!);
          final fileName = '${DateTime.now().millisecondsSinceEpoch}_${p.basename(file.path!)}';
          final savedFile = await originalFile.copy('${attachmentsDir.path}/$fileName');
          newAttachments.add(savedFile.path);
        }
      }

      final updatedTask = task.copyWith(
        attachments: newAttachments,
        updatedAt: DateTime.now().toUtc(),
      );
      await ref.read(taskNotifierProvider.notifier).updateTask(updatedTask);
    }
  }

  Future<void> _removeAttachment(Task task, String attachmentPath) async {
    final newAttachments = List<String>.from(task.attachments)..remove(attachmentPath);
    final updatedTask = task.copyWith(
      attachments: newAttachments,
      updatedAt: DateTime.now().toUtc(),
    );
    await ref.read(taskNotifierProvider.notifier).updateTask(updatedTask);
    
    // Optionally delete the file from storage
    try {
      final file = File(attachmentPath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      debugPrint('Failed to delete attachment file: $e');
    }
  }

  Future<void> _editTask(BuildContext context, Task task) async {
    final formData = await AddTaskBottomSheet.show(context, existingTask: task);
    if (formData == null || !context.mounted) return;

    if (formData.isDelete) {
      _confirmAndDeleteTask(context, task);
      return;
    }
    if (formData.isArchive) {
      _archiveTask(context, task);
      return;
    }
    if (formData.isRestore) {
      ref.read(taskNotifierProvider.notifier).restore(task.id);
      return;
    }

    final updatedTask = task.copyWith(
      title: formData.title,
      note: formData.note,
      priority: formData.priority,
      tags: formData.tag != null ? [formData.tag!] : [],
      subTasks: formData.subTasks,
      updatedAt: DateTime.now().toUtc(),
      dueDate: formData.dueDate,
      clearDueDate: formData.dueDate == null,
      clearReminder: formData.reminder == null,
      repeatRule: formData.repeatRule,
      isPinned: formData.isPinned,
      color: formData.color?.value.toRadixString(16) ?? '',
    );

    await ref.read(taskNotifierProvider.notifier).updateTask(updatedTask);
  }

  Future<void> _confirmAndDeleteTask(BuildContext context, Task task) async {
    final confirm = await ConfirmationDialog.show(
      context: context,
      title: 'Delete Task',
      message: 'Delete this task?\nThis action cannot be undone after the timeout.',
      confirmText: 'Delete',
      cancelText: 'Cancel',
      isDestructive: true,
    );

    if (confirm && context.mounted) {
      final taskCopy = task;
      final messenger = ScaffoldMessenger.of(context);
      final themeContext = Theme.of(context);
      final notifier = ref.read(taskNotifierProvider.notifier);
      
      await notifier.delete(task.id);
      if (context.mounted) {
        context.pop();
        
        messenger.clearSnackBars();
        messenger.showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Text('Task deleted'),
                const Spacer(),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: themeContext.colorScheme.inversePrimary,
                  ),
                  onPressed: () {
                    messenger.hideCurrentSnackBar();
                    notifier.create(taskCopy);
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
  }

  Future<void> _archiveTask(BuildContext context, Task task) async {
    final taskCopy = task;
    final messenger = ScaffoldMessenger.of(context);
    final themeContext = Theme.of(context);
    final notifier = ref.read(taskNotifierProvider.notifier);

    await notifier.archive(task.id);
    if (context.mounted) {
      context.pop();
      
      messenger.clearSnackBars();
      messenger.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Text('Task archived'),
              const Spacer(),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: themeContext.colorScheme.inversePrimary,
                ),
                onPressed: () {
                  messenger.hideCurrentSnackBar();
                  notifier.restore(taskCopy.id);
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

  String _getRepeatLabel(RepeatRule rule) {
    switch (rule) {
      case RepeatRule.hourly: return 'Hourly';
      case RepeatRule.daily: return 'Daily';
      case RepeatRule.weekly: return 'Weekly';
      case RepeatRule.monthly: return 'Monthly';
      case RepeatRule.yearly: return 'Yearly';
      case RepeatRule.none: return 'No';
    }
  }

  @override
  Widget build(BuildContext context) {
    final task = _getTask(ref);
    if (task == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Task not found')),
      );
    }
    
    if (_lastTask?.id != task.id || _lastTask?.title != task.title) {
      if (!_isEditingTitle) _titleController.text = task.title;
    }
    if (_lastTask?.id != task.id || _lastTask?.note != task.note) {
      if (!_isEditingNote) _noteController.text = task.note;
    }
    _lastTask = task;

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final formatter = ref.watch(dateTimeFormatterProvider);
    
    final tags = ref.watch(tagNotifierProvider).valueOrNull ?? [];
    String categoryName = 'No Category';
    if (task.tags.isNotEmpty) {
      final tag = tags.where((t) => t.id == task.tags.first).firstOrNull;
      if (tag != null) categoryName = tag.name;
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'archive') _archiveTask(context, task);
              if (value == 'delete') _confirmAndDeleteTask(context, task);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'archive', child: Text('Archive')),
              const PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Dropdown mimic
            InkWell(
              onTap: () => _editCategory(context, task),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      categoryName,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_drop_down, color: colorScheme.onSurfaceVariant),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            
            // Title
            if (_isEditingTitle)
              TextField(
                controller: _titleController,
                focusNode: _titleFocus,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _saveTitle(task),
                onTapOutside: (_) => _saveTitle(task),
                autofocus: true,
              )
            else
              GestureDetector(
                onTap: () {
                  setState(() { _isEditingTitle = true; });
                  _titleFocus.requestFocus();
                },
                child: Text(
                  task.title,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            const SizedBox(height: AppSpacing.lg),

            // Subtasks
            if (task.subTasks.isNotEmpty) ...[
              ...task.subTasks.map((subTask) {
                final isEditing = _editingSubtaskId == subTask.id;
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          final newSubTasks = List<SubTask>.from(task.subTasks);
                          final index = newSubTasks.indexOf(subTask);
                          newSubTasks[index] = subTask.copyWith(isCompleted: !subTask.isCompleted);
                          ref.read(taskNotifierProvider.notifier).updateTask(task.copyWith(
                            subTasks: newSubTasks,
                            updatedAt: DateTime.now().toUtc(),
                          ));
                        },
                        child: Icon(
                          subTask.isCompleted ? Icons.check_circle : Icons.circle_outlined,
                          color: subTask.isCompleted ? colorScheme.primary : colorScheme.onSurfaceVariant,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: isEditing 
                          ? TextField(
                              controller: _subTaskController,
                              focusNode: _subTaskFocus,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: colorScheme.onSurface,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                              onSubmitted: (_) => _saveSubTask(task),
                              onTapOutside: (_) => _saveSubTask(task),
                            )
                          : GestureDetector(
                              onTap: () {
                                setState(() { _editingSubtaskId = subTask.id; });
                                _subTaskController.text = subTask.title;
                                _subTaskFocus.requestFocus();
                              },
                              child: Text(
                                subTask.title,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  decoration: subTask.isCompleted ? TextDecoration.lineThrough : null,
                                  color: subTask.isCompleted 
                                      ? colorScheme.onSurfaceVariant.withValues(alpha: 0.6) 
                                      : colorScheme.onSurface,
                                ),
                              ),
                            ),
                      ),
                      if (isEditing)
                        IconButton(
                          icon: const Icon(Icons.close, size: 20),
                          onPressed: () {
                            final newSubTasks = List<SubTask>.from(task.subTasks)..remove(subTask);
                            ref.read(taskNotifierProvider.notifier).updateTask(task.copyWith(
                              subTasks: newSubTasks,
                              updatedAt: DateTime.now().toUtc(),
                            ));
                            setState(() { _editingSubtaskId = null; });
                          },
                          color: colorScheme.error,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                    ],
                  ),
                );
              }),
            ],
            
            if (_editingSubtaskId == 'NEW')
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Icon(Icons.circle_outlined, color: colorScheme.onSurfaceVariant.withOpacity(0.5), size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _subTaskController,
                        focusNode: _subTaskFocus,
                        style: theme.textTheme.titleMedium?.copyWith(color: colorScheme.onSurface),
                        decoration: const InputDecoration(
                          hintText: 'New sub-task...',
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onSubmitted: (_) => _saveSubTask(task),
                        onTapOutside: (_) => _saveSubTask(task),
                      ),
                    ),
                  ],
                ),
              )
            else
              TextButton.icon(
                onPressed: () {
                  setState(() { _editingSubtaskId = 'NEW'; });
                  _subTaskController.clear();
                  _subTaskFocus.requestFocus();
                },
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Sub-task'),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                ),
              ),
            
            const SizedBox(height: AppSpacing.lg),
            const Divider(),

            // Due Date
            _buildListTile(
              icon: Icons.calendar_today_outlined,
              title: 'Due Date',
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  task.dueDate != null ? formatter.formatDate(task.dueDate!) : 'No',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              onTap: () => _editDateTimePicker(context, task),
              theme: theme,
            ),
            const Divider(),

            // Time & Reminder
            _buildListTile(
              icon: Icons.access_time_outlined,
              title: 'Time & Reminder',
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  (task.dueDate != null && (task.dueDate!.hour != 0 || task.dueDate!.minute != 0))
                      ? formatter.formatTime(task.dueDate!)
                      : (task.reminder != null ? formatter.formatTime(task.reminder!.triggerTime) : 'No'),
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              onTap: () => _editDateTimePicker(context, task),
              theme: theme,
            ),
            const Divider(),

            // Repeat Task
            _buildListTile(
              icon: Icons.repeat,
              title: 'Repeat Task',
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _getRepeatLabel(task.repeatRule),
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              onTap: () => _editDateTimePicker(context, task),
              theme: theme,
            ),
            const Divider(),

            // Notes
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.chat_bubble_outline, color: theme.colorScheme.onSurfaceVariant),
                      const SizedBox(width: 16),
                      Text('Notes', style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          if (_isEditingNote) {
                            _saveNote(task);
                          } else {
                            if (DateTime.now().difference(_lastNoteSaveTime).inMilliseconds < 300) return;
                            setState(() { _isEditingNote = true; });
                            _noteFocus.requestFocus();
                          }
                        },
                        child: Text(_isEditingNote ? 'Save' : (task.note.isEmpty ? 'Add' : 'Edit'), style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
                      ),
                    ],
                  ),
                  if (_isEditingNote)
                    Padding(
                      padding: const EdgeInsets.only(left: 40.0, bottom: 8.0),
                      child: TextField(
                        controller: _noteController,
                        focusNode: _noteFocus,
                        style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                        ),
                        maxLines: null,
                        textInputAction: TextInputAction.newline,
                        onTapOutside: (_) => _saveNote(task),
                      ),
                    )
                  else if (task.note.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        setState(() { _isEditingNote = true; });
                        _noteFocus.requestFocus();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 40.0, bottom: 8.0),
                        child: Text(
                          task.note,
                          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const Divider(),

            // Attachment
            _buildListTile(
              icon: Icons.attach_file,
              title: 'Attachment',
              trailing: TextButton(
                onPressed: () => _pickAttachment(task),
                child: Text('Add', style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
              ),
              onTap: () => _pickAttachment(task),
              theme: theme,
            ),
            
            if (task.attachments.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 40.0, right: 16.0, bottom: 16.0),
                child: Column(
                  children: task.attachments.map((path) {
                    final fileName = p.basename(path);
                    return GestureDetector(
                      onTap: () {
                        OpenFilex.open(path);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8.0),
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.insert_drive_file, size: 20, color: theme.colorScheme.primary),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                fileName,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurface,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, size: 20),
                              color: theme.colorScheme.onSurfaceVariant,
                              onPressed: () => _removeAttachment(task, path),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              
            const Divider(),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required Widget trailing,
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Icon(icon, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(width: 16),
            Text(title, style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            const Spacer(),
            trailing,
          ],
        ),
      ),
    );
  }
}
