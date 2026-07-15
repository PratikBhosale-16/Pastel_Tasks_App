import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/repeat_rule.dart';

class DateTimePickerResult {
  final DateTime? dueDate;
  final TimeOfDay? time;
  final TimeOfDay? reminderTime;
  final RepeatRule repeatRule;
  final DateTime? repeatEndDate;
  final int? repeatCount;

  DateTimePickerResult({
    this.dueDate,
    this.time,
    this.reminderTime,
    required this.repeatRule,
    this.repeatEndDate,
    this.repeatCount,
  });
}

class DateTimePickerBottomSheet extends StatefulWidget {
  final DateTime? initialDueDate;
  final TimeOfDay? initialTime;
  final TimeOfDay? initialReminderTime;
  final RepeatRule initialRepeatRule;
  final DateTime? initialRepeatEndDate;
  final int? initialRepeatCount;

  const DateTimePickerBottomSheet({
    super.key,
    this.initialDueDate,
    this.initialTime,
    this.initialReminderTime,
    this.initialRepeatRule = RepeatRule.none,
    this.initialRepeatEndDate,
    this.initialRepeatCount,
  });

  static Future<DateTimePickerResult?> show(
    BuildContext context, {
    DateTime? initialDueDate,
    TimeOfDay? initialTime,
    TimeOfDay? initialReminderTime,
    RepeatRule initialRepeatRule = RepeatRule.none,
    DateTime? initialRepeatEndDate,
    int? initialRepeatCount,
  }) {
    return showModalBottomSheet<DateTimePickerResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DateTimePickerBottomSheet(
        initialDueDate: initialDueDate,
        initialTime: initialTime,
        initialReminderTime: initialReminderTime,
        initialRepeatRule: initialRepeatRule,
        initialRepeatEndDate: initialRepeatEndDate,
        initialRepeatCount: initialRepeatCount,
      ),
    );
  }

  @override
  State<DateTimePickerBottomSheet> createState() => _DateTimePickerBottomSheetState();
}

enum _ViewMode { main, time, reminder, repeat }

class _DateTimePickerBottomSheetState extends State<DateTimePickerBottomSheet> {
  _ViewMode _viewMode = _ViewMode.main;
  
  late DateTime? _dueDate;
  late TimeOfDay? _time;
  late TimeOfDay? _reminderTime;
  late RepeatRule _repeatRule;
  DateTime? _repeatEndDate;
  int? _repeatCount;
  
  int _repeatEndOption = 0; // 0 = Endlessly, 1 = A date, 2 = Repeat counts

  // For time view specifically
  int _selectedRelativeReminder = 5; // e.g. 5 for 5 mins default
  bool _isPickingMinutes = false;

  @override
  void initState() {
    super.initState();
    // Default to today if null
    _dueDate = widget.initialDueDate ?? DateTime.now();
    _time = widget.initialTime;
    _reminderTime = widget.initialReminderTime;
    _repeatRule = widget.initialRepeatRule;
    _repeatEndDate = widget.initialRepeatEndDate;
    _repeatCount = widget.initialRepeatCount;
    if (_repeatEndDate != null) {
      _repeatEndOption = 1;
    } else if (_repeatCount != null) {
      _repeatEndOption = 2;
    } else {
      _repeatEndOption = 0;
    }
    _loadLastReminderMode();
  }

  Future<void> _loadLastReminderMode() async {
    final prefs = await SharedPreferences.getInstance();
    int defaultVal = 5;
    final defaultReminderStr = prefs.getString('default_reminder');
    if (defaultReminderStr != null) {
      if (defaultReminderStr == 'Same with due date') {
        defaultVal = 0;
      } else if (defaultReminderStr == 'None') {
        defaultVal = -1;
      } else if (defaultReminderStr.endsWith('before')) {
        final parts = defaultReminderStr.split(' ');
        if (parts.length >= 3) {
          final val = int.tryParse(parts[0]);
          if (val != null) {
            final unit = parts[1];
            if (unit.startsWith('min')) {
              defaultVal = val;
            } else if (unit.startsWith('hour')) {
              defaultVal = val * 60;
            } else if (unit.startsWith('day')) {
              defaultVal = val * 60 * 24;
            } else if (unit.startsWith('week')) {
              defaultVal = val * 60 * 24 * 7;
            }
          }
        }
      }
    } else {
      defaultVal = prefs.getInt('last_used_reminder_mode') ?? 5;
    }
    
    setState(() {
      _selectedRelativeReminder = defaultVal;
    });
  }


  void _submit() {
    // If repeatEndOption is 'Endlessly' (0), clear the end date and count
    // If it's 'A date' (1), keep repeatEndDate but clear repeatCount
    // If it's 'Repeat counts' (2), keep repeatCount but clear repeatEndDate
    final finalRepeatEndDate = _repeatEndOption == 1 ? _repeatEndDate : null;
    final finalRepeatCount = _repeatEndOption == 2 ? _repeatCount : null;

    Navigator.of(context).pop(DateTimePickerResult(
      dueDate: _dueDate,
      time: _time,
      reminderTime: _reminderTime,
      repeatRule: _repeatRule,
      repeatEndDate: finalRepeatEndDate,
      repeatCount: finalRepeatCount,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: _buildCurrentView(theme),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentView(ThemeData theme) {
    switch (_viewMode) {
      case _ViewMode.main:
        return _buildMainCalendarView(theme);
      case _ViewMode.time:
        return _buildTimeView(theme);
      case _ViewMode.reminder:
        return _buildReminderView(theme);
      case _ViewMode.repeat:
        return _buildRepeatView(theme);
    }
  }

  Widget _buildMainCalendarView(ThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      key: const ValueKey('main_view'),
      children: [
        const SizedBox(height: 16),
        _CustomCalendarGrid(
          key: ValueKey(_dueDate?.month ?? DateTime.now().month), // Force rebuild if we somehow jump months via pills
          initialDate: _dueDate ?? DateTime.now(),
          onDateChanged: (date) {
            setState(() {
              _dueDate = date;
            });
          },
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              _buildQuickPill('Today', () => _setRelativeDate(0), _dueDate != null && _isSameDay(_dueDate!, DateTime.now())),
              _buildQuickPill('Tomorrow', () => _setRelativeDate(1), _dueDate != null && _isSameDay(_dueDate!, DateTime.now().add(const Duration(days: 1)))),
              _buildQuickPill('3 Days Later', () => _setRelativeDate(3), _dueDate != null && _isSameDay(_dueDate!, DateTime.now().add(const Duration(days: 3)))),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              _buildQuickPill('This Sunday', () => _setNextSunday(), false),
              _buildQuickPill('No Date', () {
                setState(() => _dueDate = null);
              }, _dueDate == null),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ListTile(
          leading: const Icon(Icons.access_time),
          title: const Text('Time'),
          trailing: Text(_time?.format(context) ?? 'No'),
          onTap: () => setState(() {
            _viewMode = _ViewMode.time;
            _isPickingMinutes = false;
          }),
        ),
        ListTile(
          leading: const Icon(Icons.notifications_none),
          title: const Text('Reminder'),
          trailing: Text(_reminderTime?.format(context) ?? 'No'),
          onTap: () => setState(() => _viewMode = _ViewMode.reminder),
        ),
        ListTile(
          leading: const Icon(Icons.repeat),
          title: const Text('Repeat'),
          trailing: Text(_repeatRule == RepeatRule.none ? 'No' : _repeatRule.name),
          onTap: () => setState(() => _viewMode = _ViewMode.repeat),
        ),
        _buildBottomActions(),
      ],
    );
  }

  Widget _buildTimeView(ThemeData theme) {
    // Format hours and minutes for dual tone
    String hours = _time != null ? _time!.hour.toString().padLeft(2, '0') : '--';
    String minutes = _time != null ? _time!.minute.toString().padLeft(2, '0') : '--';
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      key: const ValueKey('time_view'),
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Set Time', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              IconButton(
                icon: const Icon(Icons.keyboard_outlined),
                onPressed: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: _time ?? TimeOfDay.now(),
                    initialEntryMode: TimePickerEntryMode.input,
                  );
                  if (picked != null) {
                    setState(() => _time = picked);
                  }
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        
        // Dual tone time text
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _time == null 
            ? [
                Text(
                  'No Time', 
                  style: theme.textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 64,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ]
            : [
                GestureDetector(
                  onTap: () => setState(() => _isPickingMinutes = false),
                  child: Text(
                    hours, 
                    style: theme.textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 64,
                      color: !_isPickingMinutes ? theme.colorScheme.onSurface : theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
                    )
                  ),
                ),
                Text(':', style: theme.textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 64,
                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
                )),
                GestureDetector(
                  onTap: () => setState(() => _isPickingMinutes = true),
                  child: Text(
                    minutes, 
                    style: theme.textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 64,
                      color: _isPickingMinutes ? theme.colorScheme.onSurface : theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
                    )
                  ),
                ),
              ],
        ),
        const SizedBox(height: 24),
        
        // Custom Analog Clock Dial
        SizedBox(
          height: 240, // Increased size
          child: GestureDetector(
            onPanUpdate: (details) {
              _updateTimeFromOffset(details.localPosition, 240, theme);
            },
            onPanEnd: (details) {
              if (!_isPickingMinutes) {
                setState(() => _isPickingMinutes = true);
              }
            },
            onTapDown: (details) {
              _updateTimeFromOffset(details.localPosition, 240, theme);
            },
            onTapUp: (details) {
              if (!_isPickingMinutes) {
                setState(() => _isPickingMinutes = true);
              }
            },
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: CustomPaint(
                key: ValueKey(_isPickingMinutes),
                size: const Size(240, 240),
                painter: _AnalogClockPainter(
                  time: _time ?? TimeOfDay.now(),
                  theme: theme,
                  isPickingMinutes: _isPickingMinutes,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        
        // Quick Time Pills
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildQuickPill('No Time', () => setState(() => _time = null), _time == null),
              _buildQuickPill('07:00', () => setState(() => _time = const TimeOfDay(hour: 7, minute: 0)), _time?.hour == 7),
              _buildQuickPill('09:00', () => setState(() => _time = const TimeOfDay(hour: 9, minute: 0)), _time?.hour == 9),
              _buildQuickPill('10:00', () => setState(() => _time = const TimeOfDay(hour: 10, minute: 0)), _time?.hour == 10),
              _buildQuickPill('12:00', () => setState(() => _time = const TimeOfDay(hour: 12, minute: 0)), _time?.hour == 12),
              _buildQuickPill('14:00', () => setState(() => _time = const TimeOfDay(hour: 14, minute: 0)), _time?.hour == 14),
              _buildQuickPill('16:00', () => setState(() => _time = const TimeOfDay(hour: 16, minute: 0)), _time?.hour == 16),
              _buildQuickPill('18:00', () => setState(() => _time = const TimeOfDay(hour: 18, minute: 0)), _time?.hour == 18),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildBottomActions(onDone: () => setState(() => _viewMode = _ViewMode.main)),
      ],
    );
  }

  void _updateTimeFromOffset(Offset localPosition, double size, ThemeData theme) {
    final center = Offset(size / 2, size / 2);
    final dx = localPosition.dx - center.dx;
    final dy = localPosition.dy - center.dy;
    
    // angle from 12 o'clock position (0 is at top, going clockwise)
    double angle = math.atan2(dx, -dy);
    if (angle < 0) angle += 2 * math.pi;
    
    // Each hour is 30 degrees (pi/6)
    final index = (angle / (math.pi / 6)).round();
    
    if (_isPickingMinutes) {
      // Set exact minute (60 minutes in 2pi)
      int minute = (angle / (math.pi / 30)).round() % 60;
      setState(() {
        _time = TimeOfDay(hour: _time?.hour ?? 9, minute: minute);
        _updateReminderToMatchTime();
      });
    } else {
      // Set hours
      int hour = (angle / (math.pi / 6)).round() % 12;
      
      // inner circle logic
      final radius = size / 2;
      final distance = math.sqrt(dx * dx + dy * dy);
      final isInnerCircle = distance < radius * 0.6;
      if (isInnerCircle) {
        hour = (hour == 0) ? 0 : hour + 12; // 00 or 13-23
      } else {
        hour = (hour == 0) ? 12 : hour; // 1-12
      }
      
      setState(() {
        _time = TimeOfDay(hour: hour, minute: _time?.minute ?? 0);
        _updateReminderToMatchTime();
      });
    }
  }

  void _updateReminderToMatchTime() {
    if (_selectedRelativeReminder != -1 && _time != null) {
      final now = DateTime.now();
      final target = DateTime(now.year, now.month, now.day, _time!.hour, _time!.minute);
      final adjusted = target.subtract(Duration(minutes: _selectedRelativeReminder));
      _reminderTime = TimeOfDay(hour: adjusted.hour, minute: adjusted.minute);
    }
  }

  Future<void> _saveLastReminderMode(int mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('last_used_reminder_mode', mode);
  }

  String _formatCustomReminder(int minutes) {
    if (minutes >= 60 * 24 * 7 && minutes % (60 * 24 * 7) == 0) {
      return '${minutes ~/ (60 * 24 * 7)} weeks before';
    } else if (minutes >= 60 * 24 && minutes % (60 * 24) == 0) {
      return '${minutes ~/ (60 * 24)} days before';
    } else if (minutes >= 60 && minutes % 60 == 0) {
      return '${minutes ~/ 60} hours before';
    } else {
      return '$minutes minutes before';
    }
  }

  Widget _buildReminderView(ThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      key: const ValueKey('reminder_view'),
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Reminder is on', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              Switch(
                value: _reminderTime != null,
                onChanged: (val) {
                  setState(() {
                    if (val) {
                      _reminderTime = _time ?? const TimeOfDay(hour: 9, minute: 0);
                    } else {
                      _reminderTime = null;
                    }
                  });
                },
              ),
            ],
          ),
        ),
        if (_reminderTime != null) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Reminder at', style: theme.textTheme.labelLarge),
            ),
          ),
          _buildCheckboxTile('Same with due date', _selectedRelativeReminder == 0, () {
            setState(() {
              _selectedRelativeReminder = 0;
              _updateReminderToMatchTime();
            });
            _saveLastReminderMode(0);
          }),
          _buildCheckboxTile('5 minutes before', _selectedRelativeReminder == 5, () {
            setState(() {
              _selectedRelativeReminder = 5;
              _updateReminderToMatchTime();
            });
            _saveLastReminderMode(5);
          }),
          _buildCheckboxTile('15 minutes before', _selectedRelativeReminder == 15, () {
            setState(() {
              _selectedRelativeReminder = 15;
              _updateReminderToMatchTime();
            });
            _saveLastReminderMode(15);
          }),
          _buildCheckboxTile('30 minutes before', _selectedRelativeReminder == 30, () {
            setState(() {
              _selectedRelativeReminder = 30;
              _updateReminderToMatchTime();
            });
            _saveLastReminderMode(30);
          }),
          _buildCheckboxTile('1 hour before', _selectedRelativeReminder == 60, () {
            setState(() {
              _selectedRelativeReminder = 60;
              _updateReminderToMatchTime();
            });
            _saveLastReminderMode(60);
          }),
          _buildCheckboxTile(
            ![-1, 0, 5, 15, 30, 60].contains(_selectedRelativeReminder) 
                ? 'Customize time (${_formatCustomReminder(_selectedRelativeReminder)})'
                : 'Customize time',
            _selectedRelativeReminder == -1 || ![-1, 0, 5, 15, 30, 60].contains(_selectedRelativeReminder), 
            () {
            setState(() {
              if ([-1, 0, 5, 15, 30, 60].contains(_selectedRelativeReminder)) {
                _selectedRelativeReminder = -1;
              }
            });
            _saveLastReminderMode(_selectedRelativeReminder);
          }),
        ],
        _buildBottomActions(onDone: () => setState(() => _viewMode = _ViewMode.main)),
      ],
    );
  }

  Widget _buildCheckboxTile(String title, bool isSelected, VoidCallback onTap) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_box : Icons.check_box_outline_blank,
              color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 16),
            Text(title, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }

  Widget _buildRepeatView(ThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      key: const ValueKey('repeat_view'),
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => setState(() => _viewMode = _ViewMode.main),
              ),
              const SizedBox(width: 8),
              Text('Repeat', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        Column(
          children: [
            _buildRadioTile('None', RepeatRule.none),
            _buildRadioTile('Hourly', RepeatRule.hourly),
            _buildRadioTile('Daily', RepeatRule.daily),
            _buildRadioTile('Weekly', RepeatRule.weekly),
            _buildRadioTile('Monthly', RepeatRule.monthly),
            _buildRadioTile('Yearly', RepeatRule.yearly),
            
            const Divider(),
            
            Padding(
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Repeat ends at', style: theme.textTheme.titleSmall),
              ),
            ),
            _buildEndOptionTile('Endlessly', 0),
            _buildEndOptionTile('A date', 1),
            if (_repeatEndOption == 1)
              Padding(
                padding: const EdgeInsets.only(left: 32, right: 16, bottom: 8),
                child: Row(
                  children: [
                    Text(_repeatEndDate != null ? '${_repeatEndDate!.day}/${_repeatEndDate!.month}/${_repeatEndDate!.year}' : 'Select date'),
                    const Spacer(),
                    TextButton(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _repeatEndDate ?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (date != null) {
                          setState(() => _repeatEndDate = date);
                        }
                      },
                      child: const Text('Pick Date'),
                    ),
                  ],
                ),
              ),
            _buildEndOptionTile('Repeat counts', 2),
            if (_repeatEndOption == 2)
              Padding(
                padding: const EdgeInsets.only(left: 32, right: 16, bottom: 8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ...List.generate(10, (index) {
                        final val = index + 1;
                        final isSelected = _repeatCount == val;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text('$val'),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected) {
                                setState(() => _repeatCount = val);
                              }
                            },
                          ),
                        );
                      }),
                      ChoiceChip(
                        label: Text(_repeatCount != null && _repeatCount! > 10 ? 'Custom: $_repeatCount' : 'Custom'),
                        selected: _repeatCount != null && _repeatCount! > 10,
                        onSelected: (selected) {
                          _showCustomCountDialog();
                        },
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        _buildBottomActions(onDone: () => setState(() => _viewMode = _ViewMode.main)),
      ],
    );
  }

  Future<void> _showCustomCountDialog() async {
    final controller = TextEditingController(text: _repeatCount != null ? '$_repeatCount' : '');
    final result = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Custom Repeat Count'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: 'Enter number of repeats'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final val = int.tryParse(controller.text);
              Navigator.pop(context, val);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
    if (result != null && result > 0) {
      setState(() => _repeatCount = result);
    }
  }

  Widget _buildRadioTile(String title, RepeatRule rule) {
    return RadioListTile<RepeatRule>(
      title: Text(title),
      value: rule,
      groupValue: _repeatRule,
      onChanged: (val) {
        if (val != null) setState(() => _repeatRule = val);
      },
    );
  }
  
  Widget _buildEndOptionTile(String title, int index) {
    return RadioListTile<int>(
      title: Text(title),
      value: index,
      groupValue: _repeatEndOption,
      onChanged: (val) {
        if (val != null) setState(() => _repeatEndOption = val);
      },
    );
  }

  Widget _buildBottomActions({VoidCallback? onDone}) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: onDone ?? _submit,
            child: const Text('DONE'),
          ),
        ],
      ),
    );
  }

  void _setRelativeDate(int daysAdded) {
    setState(() {
      _dueDate = DateTime.now().add(Duration(days: daysAdded));
    });
  }

  void _setNextSunday() {
    DateTime now = DateTime.now();
    int daysToSunday = 7 - now.weekday;
    if (daysToSunday == 0) daysToSunday = 7; // if today is Sunday, get next week
    setState(() {
      _dueDate = now.add(Duration(days: daysToSunday));
    });
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Widget _buildQuickPill(String text, VoidCallback onTap, bool isSelected) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? theme.colorScheme.primaryContainer : theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            text,
            style: theme.textTheme.labelLarge?.copyWith(
              color: isSelected ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}

class _CustomCalendarGrid extends StatefulWidget {
  final DateTime initialDate;
  final ValueChanged<DateTime> onDateChanged;

  const _CustomCalendarGrid({
    super.key,
    required this.initialDate,
    required this.onDateChanged,
  });

  @override
  State<_CustomCalendarGrid> createState() => _CustomCalendarGridState();
}

class _CustomCalendarGridState extends State<_CustomCalendarGrid> {
  late DateTime _displayedMonth;
  late DateTime _selectedDate;

  final List<String> _weekDays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _displayedMonth = DateTime(_selectedDate.year, _selectedDate.month);
  }
  
  @override
  void didUpdateWidget(_CustomCalendarGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialDate != oldWidget.initialDate) {
      _selectedDate = widget.initialDate;
      _displayedMonth = DateTime(_selectedDate.year, _selectedDate.month);
    }
  }

  void _previousMonth() {
    setState(() {
      _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1);
    });
  }

  List<DateTime> _getDaysInMonth() {
    final firstDayOfMonth = DateTime(_displayedMonth.year, _displayedMonth.month, 1);
    // Weekday: 1=Mon, 7=Sun. We want 7=Sun as 0 index in our grid.
    int firstWeekdayOffset = firstDayOfMonth.weekday % 7; 
    
    final days = <DateTime>[];
    
    // Add previous month days
    for (int i = firstWeekdayOffset - 1; i >= 0; i--) {
      days.add(firstDayOfMonth.subtract(Duration(days: i + 1)));
    }
    
    // Add current month days
    final daysInMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1, 0).day;
    for (int i = 0; i < daysInMonth; i++) {
      days.add(firstDayOfMonth.add(Duration(days: i)));
    }
    
    // Add next month days to complete the grid (only complete the current week)
    int remaining = (7 - (days.length % 7)) % 7;
    final lastDayOfMonth = DateTime(_displayedMonth.year, _displayedMonth.month, daysInMonth);
    for (int i = 1; i <= remaining; i++) {
      days.add(lastDayOfMonth.add(Duration(days: i)));
    }
    
    return days;
  }

  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final days = _getDaysInMonth();
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () async {
                  final picked = await _MonthYearPickerDialog.show(
                    context,
                    initialDate: _displayedMonth,
                  );
                  if (picked != null) {
                    setState(() {
                      _displayedMonth = DateTime(picked.year, picked.month);
                    });
                  }
                },
                child: Row(
                  children: [
                    Text(
                      '${_getMonthName(_displayedMonth.month)} ${_displayedMonth.year}',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: _previousMonth,
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: _nextMonth,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Weekdays
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _weekDays.map((day) => 
              SizedBox(
                width: 32,
                child: Center(
                  child: Text(
                    day,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ).toList(),
          ),
        ),
        const SizedBox(height: 8),
        // Days Grid
        GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity != null) {
              if (details.primaryVelocity! > 0) {
                _previousMonth();
              } else if (details.primaryVelocity! < 0) {
                _nextMonth();
              }
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: days.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1.0,
              ),
              itemBuilder: (context, index) {
                final date = days[index];
                final isCurrentMonth = date.month == _displayedMonth.month;
                final isSelected = date.year == _selectedDate.year && 
                                   date.month == _selectedDate.month && 
                                   date.day == _selectedDate.day;
                
                Color textColor;
                if (isSelected) {
                  textColor = theme.colorScheme.onPrimary;
                } else if (!isCurrentMonth) {
                  textColor = theme.colorScheme.onSurfaceVariant.withOpacity(0.4); // Light shade for prev/next
                } else {
                  textColor = theme.colorScheme.onSurface;
                }
  
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDate = date;
                    });
                    widget.onDateChanged(date);
                  },
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: isSelected ? theme.colorScheme.primary : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${date.day}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: textColor,
                          fontWeight: isCurrentMonth ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _AnalogClockPainter extends CustomPainter {
  final TimeOfDay time;
  final ThemeData theme;
  final bool isPickingMinutes;

  _AnalogClockPainter({required this.time, required this.theme, this.isPickingMinutes = false});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final textStyle = theme.textTheme.bodyLarge?.copyWith(
      color: theme.colorScheme.onSurface,
    );
    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    final handPaint = Paint()
      ..color = theme.colorScheme.primary
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    final dotPaint = Paint()..color = theme.colorScheme.primary;
    final circlePaint = Paint()..color = theme.colorScheme.primary;

    if (!isPickingMinutes) {
      final isInnerSelected = time.hour == 0 || time.hour > 12;
      
      // Draw hand
      final hourAngle = ((time.hour % 12) * 30) * math.pi / 180;
      final hourHandLength = isInnerSelected ? radius * 0.45 : radius * 0.75;
      final hourHandEnd = Offset(
        center.dx + hourHandLength * math.sin(hourAngle),
        center.dy - hourHandLength * math.cos(hourAngle),
      );
      
      canvas.drawLine(center, hourHandEnd, handPaint);
      canvas.drawCircle(center, 4, dotPaint);

      // Draw outer ring (1 to 12)
      for (int i = 1; i <= 12; i++) {
        final angle = (i * 30) * math.pi / 180;
        final outerRadius = radius * 0.75;
        final x = center.dx + outerRadius * math.sin(angle);
        final y = center.dy - outerRadius * math.cos(angle);
        
        final isSelected = !isInnerSelected && (time.hour == i || (time.hour == 0 && i == 12 && !isInnerSelected));
        if (isSelected) {
          canvas.drawCircle(Offset(x, y), 16, circlePaint);
        }
        
        textPainter.text = TextSpan(text: '$i', style: textStyle?.copyWith(color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface));
        textPainter.layout();
        textPainter.paint(canvas, Offset(x - textPainter.width / 2, y - textPainter.height / 2));
      }

      // Draw inner ring (13 to 24/00)
      for (int i = 13; i <= 24; i++) {
        final angle = (i * 30) * math.pi / 180;
        final innerRadius = radius * 0.45;
        final x = center.dx + innerRadius * math.sin(angle);
        final y = center.dy - innerRadius * math.cos(angle);
        
        final isSelected = isInnerSelected && (time.hour == (i == 24 ? 0 : i));
        if (isSelected) {
          canvas.drawCircle(Offset(x, y), 14, circlePaint);
        }

        textPainter.text = TextSpan(
          text: i == 24 ? '00' : '$i', 
          style: textStyle?.copyWith(fontSize: 12, color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface),
        );
        textPainter.layout();
        textPainter.paint(canvas, Offset(x - textPainter.width / 2, y - textPainter.height / 2));
      }
    } else {
      // Draw hand
      final minuteAngle = (time.minute * 6) * math.pi / 180;
      final minuteHandLength = radius * 0.60;
      final minuteHandEnd = Offset(
        center.dx + minuteHandLength * math.sin(minuteAngle),
        center.dy - minuteHandLength * math.cos(minuteAngle),
      );
      
      // Target circle at the hand's end
      canvas.drawCircle(minuteHandEnd, 16, circlePaint);
      
      // If not exactly on a 5-minute increment, draw a small dot
      if (time.minute % 5 != 0) {
        canvas.drawCircle(minuteHandEnd, 4, Paint()..color = theme.colorScheme.onPrimary);
      }

      canvas.drawLine(center, minuteHandEnd, handPaint);
      canvas.drawCircle(center, 4, dotPaint);

      // Draw minutes dial (00, 05, 10...)
      for (int i = 0; i < 12; i++) {
        final angle = (i * 30) * math.pi / 180;
        final innerRadius = radius * 0.60;
        final x = center.dx + innerRadius * math.sin(angle);
        final y = center.dy - innerRadius * math.cos(angle);
        
        int minute = i * 5;
        final isExact = time.minute == minute;

        textPainter.text = TextSpan(
          text: minute.toString().padLeft(2, '0'), 
          style: textStyle?.copyWith(color: isExact ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface),
        );
        textPainter.layout();
        textPainter.paint(canvas, Offset(x - textPainter.width / 2, y - textPainter.height / 2));
      }
    }
  }

  @override
  bool shouldRepaint(_AnalogClockPainter oldDelegate) {
    return oldDelegate.time != time || oldDelegate.theme != theme || oldDelegate.isPickingMinutes != isPickingMinutes;
  }
}

class _MonthYearPickerDialog extends StatefulWidget {
  final DateTime initialDate;

  const _MonthYearPickerDialog({required this.initialDate});

  static Future<DateTime?> show(BuildContext context, {required DateTime initialDate}) {
    return showDialog<DateTime>(
      context: context,
      builder: (context) => _MonthYearPickerDialog(initialDate: initialDate),
    );
  }

  @override
  State<_MonthYearPickerDialog> createState() => _MonthYearPickerDialogState();
}

class _MonthYearPickerDialogState extends State<_MonthYearPickerDialog> {
  late int _selectedMonth;
  late int _selectedYear;

  final List<String> _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  @override
  void initState() {
    super.initState();
    _selectedMonth = widget.initialDate.month;
    _selectedYear = widget.initialDate.year;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final years = List.generate(200, (index) => 1950 + index); // 1950 to 2149

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Month', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            SizedBox(
              height: 150,
              child: Row(
                children: [
                  Expanded(
                    child: CupertinoPicker(
                      scrollController: FixedExtentScrollController(initialItem: _selectedMonth - 1),
                      itemExtent: 40,
                      onSelectedItemChanged: (index) {
                        setState(() {
                          _selectedMonth = index + 1;
                        });
                      },
                      children: _months.map((m) => Center(child: Text(m))).toList(),
                    ),
                  ),
                  Expanded(
                    child: CupertinoPicker(
                      scrollController: FixedExtentScrollController(initialItem: years.indexOf(_selectedYear)),
                      itemExtent: 40,
                      onSelectedItemChanged: (index) {
                        setState(() {
                          _selectedYear = years[index];
                        });
                      },
                      children: years.map((y) => Center(child: Text(y.toString()))).toList(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('CANCEL'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(DateTime(_selectedYear, _selectedMonth)),
                  child: const Text('DONE'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

