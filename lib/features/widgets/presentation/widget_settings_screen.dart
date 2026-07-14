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

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final showCompleted = await HomeWidget.getWidgetData<bool>('widget_show_completed', defaultValue: true);
    final accentValue = await HomeWidget.getWidgetData<int>('widget_accent_color', defaultValue: 0);
    
    setState(() {
      _showCompleted = showCompleted ?? true;
      if (accentValue != null && accentValue != 0) {
        _accentColor = Color(accentValue);
      }
    });
  }

  Future<void> _saveSettings() async {
    await HomeWidget.saveWidgetData<bool>('widget_show_completed', _showCompleted);
    await HomeWidget.saveWidgetData<int>('widget_accent_color', _accentColor.value);
    
    // Trigger update on native side
    await HomeWidget.updateWidget(
      name: 'PastelTasksWidgetReceiver',
      androidName: 'widget.PastelTasksWidgetReceiver',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Widget Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Show Completed Tasks'),
            subtitle: const Text('Include completed tasks in the widget list'),
            value: _showCompleted,
            onChanged: (val) {
              setState(() => _showCompleted = val);
              _saveSettings();
            },
          ),
          ListTile(
            title: const Text('Widget Accent Color'),
            subtitle: const Text('Tap to change the accent color on the widget'),
            trailing: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: _accentColor,
                shape: BoxShape.circle,
              ),
            ),
            onTap: () {
              // In a real app, open a color picker. 
              // Hardcoded toggle for demonstration.
              setState(() {
                _accentColor = _accentColor == AppColors.primary 
                    ? Colors.purple 
                    : AppColors.primary;
              });
              _saveSettings();
            },
          ),
        ],
      ),
    );
  }
}
