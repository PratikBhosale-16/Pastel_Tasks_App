import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pastel_tasks/app/theme/colors.dart';
import 'package:pastel_tasks/features/tags/presentation/providers/tag_notifier.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/priority.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/repeat_rule.dart';
import 'package:pastel_tasks/features/tasks/domain/models/sub_task.dart';
import 'package:pastel_tasks/features/tasks/domain/models/task.dart';
import 'package:uuid/uuid.dart';
import 'package:pastel_tasks/features/tags/presentation/widgets/tag_form_bottom_sheet.dart';
import 'package:pastel_tasks/features/tasks/presentation/widgets/add_task_bottom_sheet/tag_selector_dropdown.dart';
import 'package:pastel_tasks/features/tasks/presentation/widgets/add_task_bottom_sheet/date_time_picker_bottom_sheet.dart';
import 'package:pastel_tasks/core/providers/core_providers.dart';

class AddTaskFormData {
  const AddTaskFormData({
    required this.title,
    required this.description,
    required this.priority,
    required this.subTasks,
    this.tag,
    this.dueDate,
    this.reminder,
    required this.repeatRule,
    this.repeatEndDate,
    this.repeatCount,
    this.color,
    required this.isPinned,
    this.isDelete = false,
    this.isArchive = false,
    this.isRestore = false,
  });

  final String title;
  final String description; // Kept for backwards compatibility
  final Priority priority;
  final List<SubTask> subTasks;
  final String? tag;
  final DateTime? dueDate;
  final DateTime? reminder;
  final RepeatRule repeatRule;
  final DateTime? repeatEndDate;
  final int? repeatCount;
  final Color? color;
  final bool isPinned;
  final bool isDelete;
  final bool isArchive;
  final bool isRestore;
}

class AddTaskBottomSheet extends ConsumerStatefulWidget {
  const AddTaskBottomSheet({
    super.key,
    this.existingTask,
    this.initialDate,
    this.initialTagId,
  });

  final Task? existingTask;
  final DateTime? initialDate;
  final String? initialTagId;

  static Future<AddTaskFormData?> show(
    BuildContext context, {
    Task? existingTask,
    DateTime? initialDate,
    String? initialTagId,
    bool useRootNavigator = false,
  }) {
    return showModalBottomSheet<AddTaskFormData>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      useRootNavigator: useRootNavigator,
      backgroundColor: Colors.transparent,
      builder: (_) => AddTaskBottomSheet(
        existingTask: existingTask,
        initialDate: initialDate,
        initialTagId: initialTagId,
      ),
    );
  }

  @override
  ConsumerState<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends ConsumerState<AddTaskBottomSheet> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final List<TextEditingController> _subTaskControllers = [];
  
  bool _showDescription = false;
  Priority _priority = Priority.medium;
  String? _tagId;
  DateTime? _dueDate;
  TimeOfDay? _reminder;
  RepeatRule _repeatRule = RepeatRule.none;
  DateTime? _repeatEndDate;
  int? _repeatCount;
  Color? _selectedColor;
  bool _isPinned = false;

  bool _showColors = false;

  @override
  void initState() {
    super.initState();
    final task = widget.existingTask;
    if (task != null) {
      _titleController.text = task.title;
      _descriptionController.text = task.description;
      _showDescription = task.description.isNotEmpty;
      _priority = task.priority;
      _tagId = task.tags.isNotEmpty ? task.tags.first : null;
      _dueDate = task.dueDate;
      if (task.reminder != null) {
        _reminder = TimeOfDay.fromDateTime(task.reminder!.triggerTime);
      }
      _repeatRule = task.repeatRule;
      _repeatEndDate = task.repeatEndDate;
      _repeatCount = task.repeatCount;
      if (task.color.isNotEmpty) {
        _selectedColor = Color(int.parse(task.color, radix: 16));
      }
      _isPinned = task.isPinned;

      for (var sub in task.subTasks) {
        _subTaskControllers.add(TextEditingController(text: sub.title));
      }
    } else {
      _dueDate = widget.initialDate;
      _tagId = widget.initialTagId;
      _loadDefaults();
    }
  }

  Future<void> _loadDefaults() async {
    final prefs = ref.read(preferencesProvider);
    final defaultPriorityStr = await prefs.read('default_priority') as String?;
    final defaultRepeatStr = await prefs.read('default_repeat') as String?;
    
    if (!mounted) return;

    setState(() {
      if (defaultPriorityStr != null) {
        switch (defaultPriorityStr) {
          case 'Low': _priority = Priority.low; break;
          case 'Medium': _priority = Priority.medium; break;
          case 'High':
          case 'Critical': _priority = Priority.high; break;
        }
      }
      if (defaultRepeatStr != null && defaultRepeatStr != 'None') {
        switch (defaultRepeatStr) {
          case 'Hourly': _repeatRule = RepeatRule.hourly; break;
          case 'Daily': _repeatRule = RepeatRule.daily; break;
          case 'Weekly': _repeatRule = RepeatRule.weekly; break;
          case 'Monthly': _repeatRule = RepeatRule.monthly; break;
          case 'Yearly': _repeatRule = RepeatRule.yearly; break;
        }
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    for (var c in _subTaskControllers) {
      c.dispose();
    }
    super.dispose();
  }

  Color _getPriorityColor(Priority priority, ThemeData theme) {
    switch (priority) {
      case Priority.low:
        return Colors.green;
      case Priority.medium:
        return Colors.orange;
      case Priority.high:
        return Colors.red;
    }
  }

  void _submit() {
    if (_titleController.text.trim().isEmpty) return;

    final subTasks = _subTaskControllers
        .map((c) => c.text.trim())
        .where((text) => text.isNotEmpty)
        .map((text) => SubTask(id: const Uuid().v4(), title: text))
        .toList();

    // Preserve existing subtask completion states if editing
    List<SubTask> finalSubTasks = [];
    if (widget.existingTask != null) {
      final existingSubTasks = widget.existingTask!.subTasks;
      for (int i = 0; i < subTasks.length; i++) {
        if (i < existingSubTasks.length && existingSubTasks[i].title == subTasks[i].title) {
          finalSubTasks.add(existingSubTasks[i]);
        } else {
          finalSubTasks.add(subTasks[i]);
        }
      }
    } else {
      finalSubTasks = subTasks;
    }

    final now = DateTime.now();
    final formData = AddTaskFormData(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(), 
      priority: _priority,
      subTasks: finalSubTasks,
      tag: _tagId,
      dueDate: _dueDate,
      reminder: _reminder != null
          ? DateTime(now.year, now.month, now.day, _reminder!.hour, _reminder!.minute)
          : null,
      repeatRule: _repeatRule,
      repeatEndDate: _repeatEndDate,
      repeatCount: _repeatCount,
      color: _selectedColor,
      isPinned: _isPinned,
    );
    Navigator.of(context).pop(formData);
  }

  void _addSubTask() {
    setState(() {
      _subTaskControllers.add(TextEditingController());
    });
  }

  void _removeSubTask(int index) {
    setState(() {
      _subTaskControllers[index].dispose();
      _subTaskControllers.removeAt(index);
    });
  }

  Future<void> _openCalendarOptions() async {
    final result = await DateTimePickerBottomSheet.show(
      context,
      initialDueDate: _dueDate,
      initialTime: _dueDate != null ? TimeOfDay.fromDateTime(_dueDate!) : null,
      initialReminderTime: _reminder,
      initialRepeatRule: _repeatRule,
      initialRepeatEndDate: _repeatEndDate,
      initialRepeatCount: _repeatCount,
    );

    if (result != null && mounted) {
      setState(() {
        _dueDate = result.dueDate;
        if (result.time != null && _dueDate != null) {
          _dueDate = DateTime(
            _dueDate!.year,
            _dueDate!.month,
            _dueDate!.day,
            result.time!.hour,
            result.time!.minute,
          );
        }
        _reminder = result.reminderTime;
        _repeatRule = result.repeatRule;
        _repeatEndDate = result.repeatEndDate;
        _repeatCount = result.repeatCount;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tags = ref.watch(tagNotifierProvider).valueOrNull ?? [];
    String tagLabel = 'No Category';
    if (_tagId != null) {
      final t = tags.where((tag) => tag.id == _tagId).firstOrNull;
      if (t != null) tagLabel = t.name;
    }

    return AnimatedPadding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      child: Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            )
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Main Input Area
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _titleController,
                        autofocus: true,
                        style: theme.textTheme.titleMedium,
                        decoration: InputDecoration(
                          hintText: 'Task title...',
                          border: InputBorder.none,
                          hintStyle: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
                          ),
                        ),
                        onSubmitted: (_) => _submit(),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.mic_none),
                      onPressed: () {
                        // Voice input stub
                      },
                      color: theme.colorScheme.onSurfaceVariant,
                    )
                  ],
                ),
              ),

              // Description
              if (_showDescription)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: TextField(
                    controller: _descriptionController,
                    style: theme.textTheme.bodyMedium,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'Add details...',
                      border: InputBorder.none,
                      isDense: true,
                      hintStyle: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),

              // Subtasks List
              if (_subTaskControllers.isNotEmpty)
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.3,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _subTaskControllers.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                        child: Row(
                          children: [
                            Icon(Icons.radio_button_unchecked, 
                                size: 20, 
                                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller: _subTaskControllers[index],
                                autofocus: index == _subTaskControllers.length - 1,
                                style: theme.textTheme.bodyMedium,
                                decoration: InputDecoration(
                                  hintText: 'Input the sub-task',
                                  border: InputBorder.none,
                                  isDense: true,
                                  hintStyle: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
                                  ),
                                ),
                                onSubmitted: (_) => _addSubTask(),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, size: 18),
                              onPressed: () => _removeSubTask(index),
                              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

              const Divider(height: 1),

              // Color Palette Overlay
              if (_showColors)
                Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: AppColors.taskColors.length,
                    itemBuilder: (context, index) {
                      final color = AppColors.taskColors[index];
                      final isSelected = _selectedColor == color;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedColor = isSelected ? null : color;
                            _showColors = false;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: isSelected ? Border.all(color: theme.colorScheme.primary, width: 2) : null,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

              // Bottom Toolbar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            // Tag Selector Pill
                            InkWell(
                              onTap: () async {
                        final RenderBox button = context.findRenderObject() as RenderBox;
                        final offset = button.localToGlobal(Offset.zero);
                        
                        final newTagId = await TagSelectorDropdown.show(
                          context: context,
                          position: offset,
                          tags: tags,
                          currentTagId: _tagId,
                          onCreateNew: () async {
                            final createdTag = await TagFormBottomSheet.show(context);
                            if (createdTag != null && mounted) {
                              await ref.read(tagNotifierProvider.notifier).create(createdTag);
                              if (mounted) {
                                setState(() {
                                  _tagId = createdTag.id;
                                });
                              }
                            }
                          },
                        );

                        if (newTagId != null && mounted) {
                          setState(() {
                            _tagId = newTagId.isEmpty ? null : newTagId;
                          });
                        }
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          tagLabel,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: _tagId != null ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Pin Toggle
                    IconButton(
                      icon: Icon(
                        Icons.push_pin_rounded,
                        size: 22,
                        color: _isPinned ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPinned = !_isPinned;
                        });
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                    ),

                    // Priority
                    PopupMenuButton<Priority>(
                      icon: Icon(
                        Icons.priority_high_rounded,
                        size: 22,
                        color: _getPriorityColor(_priority, theme),
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                      onSelected: (Priority priority) {
                        setState(() {
                          _priority = priority;
                        });
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<Priority>>[
                        const PopupMenuItem<Priority>(
                          value: Priority.low,
                          child: Text('Low Priority', style: TextStyle(color: Colors.green)),
                        ),
                        const PopupMenuItem<Priority>(
                          value: Priority.medium,
                          child: Text('Medium Priority', style: TextStyle(color: Colors.orange)),
                        ),
                        const PopupMenuItem<Priority>(
                          value: Priority.high,
                          child: Text('High Priority', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                    
                    // Calendar
                    IconButton(
                      icon: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Icon(Icons.calendar_today_rounded, size: 22),
                          if (_dueDate != null)
                            Positioned(
                              top: 7,
                              child: Text(
                                '${_dueDate!.day}',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                        ],
                      ),
                      color: _dueDate != null ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                      onPressed: _openCalendarOptions,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                    ),
                    
                    // Subtask / Description
                    PopupMenuButton<String>(
                      icon: Icon(
                        Icons.subdirectory_arrow_right,
                        size: 22,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                      onSelected: (String value) {
                        if (value == 'subtask') {
                          _addSubTask();
                        } else if (value == 'description') {
                          setState(() {
                            _showDescription = true;
                          });
                        }
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'subtask',
                          child: Text('Add Subtask'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'description',
                          child: Text('Add Description'),
                        ),
                      ],
                    ),

                    // Color
                    IconButton(
                      icon: Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: _selectedColor ?? theme.colorScheme.onSurfaceVariant.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _showColors = !_showColors;
                        });
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                    ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Submit Button
                    Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.send, size: 18),
                        color: theme.colorScheme.onPrimary,
                        onPressed: _submit,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
