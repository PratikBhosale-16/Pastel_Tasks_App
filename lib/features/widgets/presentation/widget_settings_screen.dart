import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:pastel_tasks/app/theme/colors.dart';

class WidgetSettingsScreen extends StatefulWidget {
  const WidgetSettingsScreen({super.key});

  @override
  State<WidgetSettingsScreen> createState() => _WidgetSettingsScreenState();
}

class _WidgetSettingsScreenState extends State<WidgetSettingsScreen> {
  bool _showCompleted = true;
  Color _accentColor = AppColors.primary;
  bool _followAppAccent = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final showCompleted = await HomeWidget.getWidgetData<bool>('widget_show_completed', defaultValue: true);
    final followApp = await HomeWidget.getWidgetData<bool>('widget_follow_app_accent', defaultValue: true);
    final accentValue = await HomeWidget.getWidgetData<int>('widget_accent_color', defaultValue: 0);
    
    setState(() {
      _showCompleted = showCompleted ?? true;
      _followAppAccent = followApp ?? true;
      if (accentValue != null && accentValue != 0) {
        _accentColor = Color(accentValue);
      }
    });
  }

  Future<void> _saveSettings() async {
    await HomeWidget.saveWidgetData<bool>('widget_show_completed', _showCompleted);
    await HomeWidget.saveWidgetData<bool>('widget_follow_app_accent', _followAppAccent);
    await HomeWidget.saveWidgetData<int>('widget_accent_color', _accentColor.value);
    
    // Trigger update on native side
    await HomeWidget.updateWidget(
      name: 'PastelTasksWidgetReceiver',
      androidName: 'widget.PastelTasksWidgetReceiver',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(title: const Text('Widget Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            title: const Text('Show Completed Tasks'),
            subtitle: const Text('Include completed tasks in the widget list'),
            leading: Icon(Icons.check_circle_outline, color: primaryColor),
            trailing: Theme(
              data: theme.copyWith(useMaterial3: false),
              child: Switch(
                value: _showCompleted,
                activeColor: primaryColor,
                activeTrackColor: primaryColor.withOpacity(0.5),
                onChanged: (val) {
                  setState(() => _showCompleted = val);
                  _saveSettings();
                },
              ),
            ),
            onTap: () {
              setState(() => _showCompleted = !_showCompleted);
              _saveSettings();
            },
          ),
          const SizedBox(height: 16),
          ListTile(
            title: const Text('Follow App Accent Color'),
            subtitle: const Text('Use the same accent color as the app theme'),
            leading: Icon(Icons.color_lens, color: primaryColor),
            trailing: Theme(
              data: theme.copyWith(useMaterial3: false),
              child: Switch(
                value: _followAppAccent,
                activeColor: primaryColor,
                activeTrackColor: primaryColor.withOpacity(0.5),
                onChanged: (val) {
                  setState(() => _followAppAccent = val);
                  _saveSettings();
                },
              ),
            ),
            onTap: () {
              setState(() => _followAppAccent = !_followAppAccent);
              _saveSettings();
            },
          ),
          if (!_followAppAccent) ...[
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Widget Accent Color',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: AppColors.taskColors.map((color) {
                final isSelected = _accentColor == color;
                return GestureDetector(
                  onTap: () {
                    setState(() => _accentColor = color);
                    _saveSettings();
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: isSelected ? Border.all(color: primaryColor, width: 3) : null,
                    ),
                  ),
                );
              }).toList(),
            ),
          ]
        ],
      ),
    );
  }
}
