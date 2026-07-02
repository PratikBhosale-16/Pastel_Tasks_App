import 'package:flutter/material.dart';
import 'package:pastel_tasks/shared/widgets/buttons/primary_button.dart';
import 'package:pastel_tasks/shared/widgets/buttons/secondary_button.dart';
import 'package:pastel_tasks/shared/widgets/chips/selection_chip.dart';
import 'package:pastel_tasks/shared/widgets/textfields/multiline_field.dart';
import 'package:pastel_tasks/shared/widgets/textfields/primary_text_field.dart';
import 'package:pastel_tasks/features/tasks/domain/models/task.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/priority.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/repeat_rule.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pastel_tasks/features/tags/presentation/providers/tag_notifier.dart';
import 'package:pastel_tasks/features/tags/presentation/widgets/tag_form_bottom_sheet.dart';
import 'package:pastel_tasks/app/theme/colors.dart';

/// Data class representing the result from the add task bottom sheet.
class AddTaskFormData {
  const AddTaskFormData({
    required this.title,
    required this.description,
    required this.priority,
    this.tag,
    this.dueDate,
    this.reminder,
    required this.repeatRule,
    this.color,
    required this.isPinned,
    this.isDelete = false,
    this.isArchive = false,
    this.isRestore = false,
  });

  final String title;
  final String description;
  final String priority;
  final String? tag;
  final DateTime? dueDate;
  final TimeOfDay? reminder;
  final String repeatRule;
  final Color? color;
  final bool isPinned;
  final bool isDelete;
  final bool isArchive;
  final bool isRestore;
}

/// A bottom sheet for adding or editing a task.
/// Returns an [AddTaskFormData] if the user successfully creates/edits a task.
class AddTaskBottomSheet extends ConsumerStatefulWidget {
  const AddTaskBottomSheet({super.key, this.existingTask});
  
  final Task? existingTask;

  /// Displays the bottom sheet and returns the captured form data.
  static Future<AddTaskFormData?> show(BuildContext context, {Task? existingTask, bool useRootNavigator = false}) {
    return showModalBottomSheet<AddTaskFormData>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      useRootNavigator: useRootNavigator,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => AddTaskBottomSheet(existingTask: existingTask),
    );
  }

  @override
  ConsumerState<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends ConsumerState<AddTaskBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _priority = 'Medium';
  String? _tagId;
  DateTime? _dueDate;
  TimeOfDay? _reminder;
  String _repeatRule = 'None';
  Color? _selectedColor;
  bool _isPinned = false;

  final List<String> _priorities = ['Low', 'Medium', 'High', 'Critical'];
  final List<String> _repeatRules = ['None', 'Daily', 'Weekly', 'Monthly'];
  final List<Color> _presetColors = AppColors.taskColors;

  @override
  void initState() {
    super.initState();
    final task = widget.existingTask;
    if (task != null) {
      _titleController.text = task.title;
      _descriptionController.text = task.description;
      _priority = _formatPriority(task.priority);
      _tagId = task.tags.isNotEmpty ? task.tags.first : null;
      _dueDate = task.dueDate;
      if (task.reminder != null) {
        _reminder = TimeOfDay.fromDateTime(task.reminder!.triggerTime);
      }
      _repeatRule = _formatRepeatRule(task.repeatRule);
      if (task.color.isNotEmpty) {
        _selectedColor = Color(int.parse(task.color, radix: 16));
      }
      _isPinned = task.isPinned;
    }
  }

  String _formatPriority(Priority p) {
    switch (p) {
      case Priority.low: return 'Low';
      case Priority.high: return 'High';
      case Priority.critical: return 'Critical';
      case Priority.medium:
      default: return 'Medium';
    }
  }

  String _formatRepeatRule(RepeatRule r) {
    switch (r) {
      case RepeatRule.daily: return 'Daily';
      case RepeatRule.weekly: return 'Weekly';
      case RepeatRule.monthly: return 'Monthly';
      case RepeatRule.yearly: return 'Yearly';
      case RepeatRule.none:
      default: return 'None';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  bool _hasUnsavedChanges() {
    final task = widget.existingTask;
    if (task == null) {
      return _titleController.text.trim().isNotEmpty || 
             _descriptionController.text.trim().isNotEmpty ||
             _dueDate != null || _tagId != null;
    } else {
      if (_titleController.text.trim() != task.title) return true;
      if (_descriptionController.text.trim() != task.description) return true;
      if (_priority != _formatPriority(task.priority)) return true;
      final existingTag = task.tags.isNotEmpty ? task.tags.first : null;
      if (_tagId != existingTag) return true;
      if (_dueDate != task.dueDate) return true;
      if (_repeatRule != _formatRepeatRule(task.repeatRule)) return true;
      
      Color? existingColor;
      if (task.color.isNotEmpty) {
        existingColor = Color(int.parse(task.color, radix: 16));
      }
      if (_selectedColor != existingColor) return true;
      if (_isPinned != task.isPinned) return true;
      return false;
    }
  }

  Future<bool> _showDiscardDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Discard Changes?'),
          content: const Text('You have unsaved changes. Are you sure you want to discard them?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Keep Editing'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('Discard'),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final formData = AddTaskFormData(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        priority: _priority,
        tag: _tagId,
        dueDate: _dueDate,
        reminder: _reminder,
        repeatRule: _repeatRule,
        color: _selectedColor,
        isPinned: _isPinned,
      );
      Navigator.of(context).pop(formData);
    }
  }

  void _delete() {
    final formData = AddTaskFormData(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      priority: _priority,
      tag: _tagId,
      dueDate: _dueDate,
      reminder: _reminder,
      repeatRule: _repeatRule,
      color: _selectedColor,
      isPinned: _isPinned,
      isDelete: true,
    );
    Navigator.of(context).pop(formData);
  }

  void _archive() {
    final formData = AddTaskFormData(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      priority: _priority,
      tag: _tagId,
      dueDate: _dueDate,
      reminder: _reminder,
      repeatRule: _repeatRule,
      color: _selectedColor,
      isPinned: _isPinned,
      isArchive: true,
    );
    Navigator.of(context).pop(formData);
  }

  void _restore() {
    final formData = AddTaskFormData(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      priority: _priority,
      tag: _tagId,
      dueDate: _dueDate,
      reminder: _reminder,
      repeatRule: _repeatRule,
      color: _selectedColor,
      isPinned: _isPinned,
      isRestore: true,
    );
    Navigator.of(context).pop(formData);
  }

  Future<void> _pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null && mounted) {
      setState(() => _dueDate = picked);
    }
  }

  Future<void> _pickReminder() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _reminder ?? TimeOfDay.now(),
    );
    if (picked != null && mounted) {
      setState(() => _reminder = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = widget.existingTask != null;
    
    return PopScope(
      canPop: !_hasUnsavedChanges(),
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldDiscard = await _showDiscardDialog();
        if (shouldDiscard && mounted) {
          Navigator.of(context).pop();
        }
      },
      child: AnimatedPadding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  children: [
                    // Handle
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.outlineVariant,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isEditMode ? 'Edit Task' : 'Add New Task',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        TextButton(
                          onPressed: _submit,
                          style: TextButton.styleFrom(
                            foregroundColor: Theme.of(context).colorScheme.primary,
                            textStyle: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          child: Text(isEditMode ? 'Save' : 'Create'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    PrimaryTextField(
                      controller: _titleController,
                      labelText: 'Task Title',
                      hintText: 'What needs to be done?',
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Title is required';
                        }
                        if (value.length > 80) {
                          return 'Title must be 80 characters or less';
                        }
                        return null;
                      },
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${_titleController.text.length}/80',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: _titleController.text.length > 80
                                  ? Theme.of(context).colorScheme.error
                                  : Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                        semanticsLabel: '${_titleController.text.length} out of 80 characters',
                      ),
                    ),
                    const SizedBox(height: 16),
                    MultilineField(
                      controller: _descriptionController,
                      labelText: 'Description (Optional)',
                      hintText: 'Add some details...',
                      minLines: 3,
                      maxLines: 6,
                    ),
                    const SizedBox(height: 24),
                    
                    // Priority
                    Text('Priority', style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: _priorities.map((p) {
                        return SelectionChip(
                          label: p,
                          isSelected: _priority == p,
                          onSelected: (selected) {
                            if (selected) setState(() => _priority = p);
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    
                    // Tags
                    Text('Tags', style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          SelectionChip(
                            label: '+ New Tag',
                            isSelected: false,
                            onSelected: (_) async {
                              final newTag = await TagFormBottomSheet.show(context);
                              if (newTag != null && mounted) {
                                await ref.read(tagNotifierProvider.notifier).create(newTag);
                                setState(() {
                                  _tagId = newTag.id;
                                });
                              }
                            },
                          ),
                          const SizedBox(width: 8),
                          ...ref.watch(tagNotifierProvider).when(
                            data: (tags) {
                              return tags.map((t) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: SelectionChip(
                                    label: t.name,
                                    isSelected: _tagId == t.id,
                                    color: Color(int.parse(t.color, radix: 16)),
                                    icon: IconData(int.parse(t.icon), fontFamily: 'MaterialIcons'),
                                    onSelected: (selected) {
                                      setState(() => _tagId = selected ? t.id : null);
                                    },
                                  ),
                                );
                              });
                            },
                            loading: () => [const SizedBox.shrink()],
                            error: (_, __) => [const SizedBox.shrink()],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Dates & Reminders
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Date & Reminder', style: Theme.of(context).textTheme.titleSmall),
                        if (isEditMode && (_dueDate != null || _reminder != null))
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {
                              setState(() {
                                _dueDate = null;
                                _reminder = null;
                              });
                            },
                            child: const Text('Clear Both'),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(horizontal: _dueDate != null ? 8 : 16),
                                  ),
                                  onPressed: _pickDueDate,
                                  icon: const Icon(Icons.calendar_today_rounded, size: 18),
                                  label: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(_dueDate != null
                                        ? '${_dueDate!.year}-${_dueDate!.month.toString().padLeft(2, '0')}-${_dueDate!.day.toString().padLeft(2, '0')}'
                                        : 'Due Date'),
                                  ),
                                ),
                              ),
                              if (_dueDate != null)
                                IconButton(
                                  icon: const Icon(Icons.close, size: 18),
                                  onPressed: () => setState(() => _dueDate = null),
                                  padding: const EdgeInsets.only(left: 4),
                                  constraints: const BoxConstraints(),
                                  visualDensity: VisualDensity.compact,
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(horizontal: _reminder != null ? 8 : 16),
                                  ),
                                  onPressed: _pickReminder,
                                  icon: const Icon(Icons.alarm_rounded, size: 18),
                                  label: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(_reminder?.format(context) ?? 'Reminder'),
                                  ),
                                ),
                              ),
                              if (_reminder != null)
                                IconButton(
                                  icon: const Icon(Icons.close, size: 18),
                                  onPressed: () => setState(() => _reminder = null),
                                  padding: const EdgeInsets.only(left: 4),
                                  constraints: const BoxConstraints(),
                                  visualDensity: VisualDensity.compact,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Repeat Rule
                    Text('Repeat', style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: _repeatRules.map((r) {
                        return SelectionChip(
                          label: r,
                          isSelected: _repeatRule == r,
                          onSelected: (selected) {
                            if (selected) setState(() => _repeatRule = r);
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    
                    // Color Picker
                    Text('Color (Optional)', style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 12,
                      children: _presetColors.map((color) {
                        final isSelected = _selectedColor == color;
                        return Semantics(
                          label: 'Select color',
                          button: true,
                          selected: isSelected,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedColor = isSelected ? null : color;
                              });
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected ? Theme.of(context).colorScheme.onSurface : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: isSelected 
                                ? const Icon(Icons.check, color: Colors.black54, size: 20)
                                : null,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    
                    // Pin Toggle
                    SwitchListTile(
                      title: const Text('Pin to top'),
                      subtitle: const Text('Keep this task visible'),
                      value: _isPinned,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (val) => setState(() => _isPinned = val),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Action Buttons
                    Row(
                      children: [
                        if (isEditMode) ...[
                          IconButton(
                            icon: Icon(Icons.delete_outline_rounded, color: Theme.of(context).colorScheme.error),
                            onPressed: _delete,
                            tooltip: 'Delete',
                          ),
                          IconButton(
                            icon: Icon(widget.existingTask!.isArchived ? Icons.unarchive_outlined : Icons.archive_outlined),
                            onPressed: widget.existingTask!.isArchived ? _restore : _archive,
                            tooltip: widget.existingTask!.isArchived ? 'Restore' : 'Archive',
                          ),
                          const Spacer(),
                          SecondaryButton(
                            label: 'Cancel',
                            isFullWidth: false,
                            onPressed: () async {
                              if (_hasUnsavedChanges()) {
                                final discard = await _showDiscardDialog();
                                if (discard && mounted) {
                                  Navigator.of(context).pop();
                                }
                              } else {
                                Navigator.of(context).pop();
                              }
                            },
                          ),
                          const SizedBox(width: 8),
                          PrimaryButton(
                            label: 'Save',
                            isFullWidth: false,
                            onPressed: (_titleController.text.trim().isEmpty || _titleController.text.length > 80)
                                ? null
                                : _submit,
                          ),
                        ] else ...[
                          Expanded(
                            child: SecondaryButton(
                              label: 'Cancel',
                              onPressed: () async {
                                if (_hasUnsavedChanges()) {
                                  final discard = await _showDiscardDialog();
                                  if (discard && mounted) {
                                    Navigator.of(context).pop();
                                  }
                                } else {
                                  Navigator.of(context).pop();
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: PrimaryButton(
                              label: 'Create Task',
                              onPressed: (_titleController.text.trim().isEmpty || _titleController.text.length > 80)
                                  ? null
                                  : _submit,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
    );
  }
}
