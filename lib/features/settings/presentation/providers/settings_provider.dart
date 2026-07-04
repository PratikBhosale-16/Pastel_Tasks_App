import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:pastel_tasks/features/settings/domain/models/settings_item.dart';
import 'package:pastel_tasks/features/settings/domain/models/settings_section.dart';
import 'package:pastel_tasks/core/providers/core_providers.dart';
import 'package:pastel_tasks/features/settings/presentation/providers/stats_provider.dart';
import 'package:pastel_tasks/features/backup/presentation/providers/backup_providers.dart';
import 'package:pastel_tasks/features/backup/domain/enums/backup_type.dart';
import 'package:go_router/go_router.dart';
// --- APPEARANCE ---
const themeDropdown = SettingsItemDropdown<String>(
  id: 'appearance_theme',
  title: 'Theme',
  storageKey: 'theme_mode_preference',
  defaultValue: '0', // System
  options: ['0', '1', '2'], // System, Light, Dark
  labelBuilder: _themeLabelBuilder,
  icon: Icons.brightness_6,
  keywords: ['theme', 'light', 'dark', 'system'],
);

String _themeLabelBuilder(String val) {
  switch (val) {
    case '1': return 'Light Theme';
    case '2': return 'Dark Theme';
    default: return 'System Theme';
  }
}

const appAccentPicker = SettingsItemColorPicker(
  id: 'appearance_accent',
  title: 'Accent Color',
  storageKey: 'app_accent_preference',
  icon: Icons.palette,
  keywords: ['accent', 'color', 'theme'],
);

const calendarAccentPicker = SettingsItemColorPicker(
  id: 'calendar_accent',
  title: 'Calendar Accent',
  storageKey: 'calendar_accent_color',
  icon: Icons.color_lens,
  keywords: ['calendar', 'accent', 'color'],
);

const taskCardStyleDropdown = SettingsItemDropdown<String>(
  id: 'appearance_task_card_style',
  title: 'Task Card Style',
  storageKey: 'task_card_style',
  defaultValue: 'Default',
  options: ['Default', 'Compact', 'Comfortable'],
  labelBuilder: _defaultLabelBuilder,
  icon: Icons.view_agenda,
  keywords: ['task', 'card', 'style', 'compact', 'comfortable'],
);

String _defaultLabelBuilder(String val) => val;

const fontSizeDropdown = SettingsItemDropdown<String>(
  id: 'appearance_font_size',
  title: 'Font Size',
  storageKey: 'font_size',
  defaultValue: 'Default',
  options: ['Small', 'Default', 'Large', 'Extra Large'],
  labelBuilder: _defaultLabelBuilder,
  icon: Icons.format_size,
  keywords: ['font', 'size', 'text', 'large', 'small'],
);

const animationSpeedDropdown = SettingsItemDropdown<String>(
  id: 'appearance_animation_speed',
  title: 'Animation Speed',
  storageKey: 'animation_speed',
  defaultValue: 'Normal',
  options: ['Slow', 'Normal', 'Fast'],
  labelBuilder: _defaultLabelBuilder,
  icon: Icons.animation,
  keywords: ['animation', 'speed', 'slow', 'fast'],
);

const reduceMotionSwitch = SettingsItemSwitch(
  id: 'appearance_reduce_motion',
  title: 'Reduce Motion',
  storageKey: 'reduce_motion',
  defaultValue: false,
  icon: Icons.motion_photos_off,
  keywords: ['reduce', 'motion', 'animation'],
);

const materialYouSwitch = SettingsItemSwitch(
  id: 'appearance_material_you',
  title: 'Material You',
  storageKey: 'material_you',
  defaultValue: true,
  icon: Icons.format_paint,
  keywords: ['material you', 'dynamic', 'color'],
);

// --- TASK PREFERENCES ---
const defaultPriorityDropdown = SettingsItemDropdown<String>(
  id: 'task_default_priority',
  title: 'Default Priority',
  storageKey: 'default_priority',
  defaultValue: 'Low',
  options: ['Low', 'Medium', 'High', 'Critical'],
  labelBuilder: _defaultLabelBuilder,
  icon: Icons.flag,
  keywords: ['priority', 'default', 'task'],
);

const defaultReminderDropdown = SettingsItemDropdown<String>(
  id: 'task_default_reminder',
  title: 'Default Reminder',
  storageKey: 'default_reminder',
  defaultValue: 'None',
  options: ['None', '5 mins before', '10 mins before', '30 mins before', '1 hour before'],
  labelBuilder: _defaultLabelBuilder,
  icon: Icons.alarm,
  keywords: ['reminder', 'default', 'notification'],
);

const defaultRepeatDropdown = SettingsItemDropdown<String>(
  id: 'task_default_repeat',
  title: 'Default Repeat',
  storageKey: 'default_repeat',
  defaultValue: 'None',
  options: ['None', 'Daily', 'Weekly', 'Monthly', 'Yearly'],
  labelBuilder: _defaultLabelBuilder,
  icon: Icons.repeat,
  keywords: ['repeat', 'default', 'recurring'],
);

const defaultTagDropdown = SettingsItemDropdown<String>(
  id: 'task_default_tag',
  title: 'Default Tag',
  storageKey: 'default_tag',
  defaultValue: 'None',
  options: ['None', 'Work', 'Personal', 'Home'], // Mocked for now
  labelBuilder: _defaultLabelBuilder,
  icon: Icons.label,
  keywords: ['tag', 'default', 'label'],
);

const autoArchiveSwitch = SettingsItemSwitch(
  id: 'task_auto_archive',
  title: 'Auto Archive',
  storageKey: 'auto_archive',
  defaultValue: false,
  icon: Icons.archive,
  keywords: ['archive', 'auto', 'task'],
);

const completedTaskVisDropdown = SettingsItemDropdown<String>(
  id: 'task_completed_visibility',
  title: 'Completed Task Visibility',
  storageKey: 'completed_task_visibility',
  defaultValue: '7 Days',
  options: ['1 Day', '3 Days', '7 Days', 'Forever'],
  labelBuilder: _defaultLabelBuilder,
  icon: Icons.visibility,
  keywords: ['completed', 'visibility', 'hide'],
);

// --- CALENDAR ---
const weekStartsDropdown = SettingsItemDropdown<String>(
  id: 'calendar_week_starts',
  title: 'Week Starts',
  storageKey: 'week_starts',
  defaultValue: 'Monday',
  options: ['Monday', 'Sunday'],
  labelBuilder: _defaultLabelBuilder,
  icon: Icons.calendar_today,
  keywords: ['week', 'start', 'monday', 'sunday'],
);

const defaultViewDropdown = SettingsItemDropdown<String>(
  id: 'calendar_default_view',
  title: 'Default View',
  storageKey: 'calendar_default_view',
  defaultValue: 'Month',
  options: ['Month', 'Week', 'Agenda'],
  labelBuilder: _defaultLabelBuilder,
  icon: Icons.view_module,
  keywords: ['calendar', 'view', 'month', 'week', 'agenda'],
);

const calendarDensityDropdown = SettingsItemDropdown<String>(
  id: 'calendar_density',
  title: 'Calendar Density',
  storageKey: 'calendar_density',
  defaultValue: 'Comfortable',
  options: ['Compact', 'Comfortable'],
  labelBuilder: _defaultLabelBuilder,
  icon: Icons.density_medium,
  keywords: ['calendar', 'density', 'compact', 'comfortable'],
);

const calendarShowCompletedSwitch = SettingsItemSwitch(
  id: 'show_completed_calendar',
  title: 'Show Completed Tasks in Calendar',
  storageKey: 'calendar_show_completed',
  defaultValue: false,
  icon: Icons.check_circle_outline,
  keywords: ['calendar', 'completed', 'show', 'hide'],
);

// --- NOTIFICATIONS ---
const masterNotificationToggle = SettingsItemSwitch(
  id: 'notification_master',
  title: 'Allow Notifications',
  storageKey: 'notifications_enabled',
  defaultValue: true,
  icon: Icons.notifications_active,
  keywords: ['notifications', 'alerts', 'toggle'],
);

const notificationSoundDropdown = SettingsItemDropdown<String>(
  id: 'notification_sound',
  title: 'Notification Sound',
  storageKey: 'notification_sound',
  defaultValue: 'Default',
  options: ['Default', 'Chime', 'Bell', 'None'],
  labelBuilder: _defaultLabelBuilder,
  icon: Icons.audiotrack,
  keywords: ['sound', 'notification', 'audio'],
);

const vibrationSwitch = SettingsItemSwitch(
  id: 'notification_vibration',
  title: 'Vibration',
  storageKey: 'notification_vibration',
  defaultValue: true,
  icon: Icons.vibration,
  keywords: ['vibration', 'haptic', 'notification'],
);

final quietHoursAction = SettingsItemAction(
  id: 'notification_quiet_hours',
  title: 'Quiet Hours',
  subtitle: 'Configure when not to receive notifications',
  icon: Icons.do_not_disturb,
  onAction: (context, ref) {},
  keywords: ['quiet', 'hours', 'do not disturb', 'dnd'],
);

const reminderPreviewSwitch = SettingsItemSwitch(
  id: 'notification_reminder_preview',
  title: 'Reminder Preview',
  storageKey: 'notification_reminder_preview',
  defaultValue: true,
  icon: Icons.preview,
  keywords: ['preview', 'reminder', 'notification'],
);

const notificationGroupingSwitch = SettingsItemSwitch(
  id: 'notification_grouping',
  title: 'Notification Grouping',
  storageKey: 'notification_grouping',
  defaultValue: true,
  icon: Icons.folder,
  keywords: ['group', 'notification', 'bundle'],
);

// --- BACKUP & RESTORE ---
const backupModuleNav = SettingsItemNavigation(
  id: 'backup_module',
  title: 'Backup & Restore',
  route: '/settings/backup',
  icon: Icons.cloud_sync,
  keywords: ['backup', 'restore', 'cloud', 'sync', 'drive'],
);

const autoBackupFreqDropdown = SettingsItemDropdown<String>(
  id: 'backup_auto_freq',
  title: 'Automatic Backup Frequency',
  storageKey: 'auto_backup_freq',
  defaultValue: 'Daily',
  options: ['Never', 'Daily', 'Weekly', 'Monthly'],
  labelBuilder: _defaultLabelBuilder,
  icon: Icons.schedule,
  keywords: ['backup', 'frequency', 'auto', 'schedule'],
);

final manualBackupAction = SettingsItemAction(
  id: 'backup_manual',
  title: 'Manual Backup',
  icon: Icons.backup,
  onAction: (context, ref) {},
  keywords: ['manual', 'backup', 'now'],
);

final restoreBackupAction = SettingsItemAction(
  id: 'backup_restore_action',
  title: 'Restore Backup',
  icon: Icons.restore,
  onAction: (context, ref) {},
  keywords: ['restore', 'backup', 'recover'],
);

const backupHistoryNav = SettingsItemNavigation(
  id: 'backup_history',
  title: 'Backup History',
  route: '/settings/backup',
  icon: Icons.history,
  keywords: ['history', 'backup', 'logs'],
);

// --- WIDGETS ---
const enableWidgetsSwitch = SettingsItemSwitch(
  id: 'widgets_enable',
  title: 'Enable Widgets',
  storageKey: 'widgets_enabled',
  defaultValue: true,
  icon: Icons.widgets,
  keywords: ['widgets', 'home', 'screen', 'enable'],
);

const widgetThemeDropdown = SettingsItemDropdown<String>(
  id: 'widgets_theme',
  title: 'Widget Theme',
  storageKey: 'widget_theme',
  defaultValue: 'System',
  options: ['System', 'Light', 'Dark', 'Transparent'],
  labelBuilder: _defaultLabelBuilder,
  icon: Icons.color_lens,
  keywords: ['widget', 'theme', 'color', 'transparent'],
);

const widgetRefreshDropdown = SettingsItemDropdown<String>(
  id: 'widgets_refresh',
  title: 'Widget Refresh Interval',
  storageKey: 'widget_refresh',
  defaultValue: '15 mins',
  options: ['15 mins', '30 mins', '1 hour', '6 hours'],
  labelBuilder: _defaultLabelBuilder,
  icon: Icons.refresh,
  keywords: ['widget', 'refresh', 'interval', 'update'],
);

// --- ACCESSIBILITY ---
const largeTextSwitch = SettingsItemSwitch(
  id: 'accessibility_large_text',
  title: 'Large Text',
  storageKey: 'large_text',
  defaultValue: false,
  icon: Icons.text_fields,
  keywords: ['large', 'text', 'font', 'accessibility'],
);

const highContrastSwitch = SettingsItemSwitch(
  id: 'accessibility_high_contrast',
  title: 'High Contrast',
  storageKey: 'high_contrast',
  defaultValue: false,
  icon: Icons.contrast,
  keywords: ['high', 'contrast', 'accessibility'],
);

const hapticFeedbackSwitch = SettingsItemSwitch(
  id: 'accessibility_haptic',
  title: 'Haptic Feedback',
  storageKey: 'haptic_feedback',
  defaultValue: true,
  icon: Icons.vibration,
  keywords: ['haptic', 'feedback', 'vibration', 'accessibility'],
);

const touchTargetDropdown = SettingsItemDropdown<String>(
  id: 'accessibility_touch_target',
  title: 'Touch Target Size',
  storageKey: 'touch_target_size',
  defaultValue: 'Normal',
  options: ['Normal', 'Large'],
  labelBuilder: _defaultLabelBuilder,
  icon: Icons.touch_app,
  keywords: ['touch', 'target', 'size', 'accessibility'],
);

// --- DATA & STORAGE ---
const databaseSizeInfo = SettingsItemInfo(
  id: 'data_db_size',
  title: 'Database Size',
  valueLabel: '1.2 MB', // Mocked, would be loaded dynamically in real implementation
  icon: Icons.storage,
  keywords: ['database', 'size', 'storage', 'data'],
);

const taskCountInfo = SettingsItemInfo(
  id: 'data_task_count',
  title: 'Task Count',
  valueLabel: '42',
  icon: Icons.task,
  keywords: ['task', 'count', 'total'],
);

const completedTaskCountInfo = SettingsItemInfo(
  id: 'data_completed_tasks',
  title: 'Completed Tasks',
  valueLabel: '128',
  icon: Icons.check_circle,
  keywords: ['completed', 'task', 'count'],
);

const archivedTaskCountInfo = SettingsItemInfo(
  id: 'data_archived_tasks',
  title: 'Archived Tasks',
  valueLabel: '15',
  icon: Icons.archive,
  keywords: ['archived', 'task', 'count'],
);

const tagCountInfo = SettingsItemInfo(
  id: 'data_tag_count',
  title: 'Tag Count',
  valueLabel: '8',
  icon: Icons.label,
  keywords: ['tag', 'count', 'labels'],
);

final clearCacheAction = SettingsItemAction(
  id: 'data_clear_cache',
  title: 'Clear Cache',
  icon: Icons.cleaning_services,
  onAction: (context, ref) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cache cleared')));
  },
  keywords: ['clear', 'cache', 'storage', 'clean'],
);

final optimizeDbAction = SettingsItemAction(
  id: 'data_optimize_db',
  title: 'Optimize Database',
  icon: Icons.build,
  onAction: (context, ref) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Database optimized')));
  },
  keywords: ['optimize', 'database', 'performance'],
);

// --- DEVELOPER ---
bool _isDebugOnly() => kDebugMode;

final debugLogsSwitch = SettingsItemSwitch(
  id: 'dev_debug_logs',
  title: 'Debug Logs',
  storageKey: 'dev_debug_logs',
  defaultValue: false,
  icon: Icons.bug_report,
  isVisible: _isDebugOnly,
  keywords: ['debug', 'logs', 'developer'],
);

final performanceOverlaySwitch = SettingsItemSwitch(
  id: 'dev_perf_overlay',
  title: 'Performance Overlay',
  storageKey: 'dev_perf_overlay',
  defaultValue: false,
  icon: Icons.speed,
  isVisible: _isDebugOnly,
  keywords: ['performance', 'overlay', 'fps', 'developer'],
);

final resetTutorialAction = SettingsItemAction(
  id: 'dev_reset_tutorial',
  title: 'Reset Tutorial',
  icon: Icons.school,
  isVisible: _isDebugOnly,
  onAction: (context, ref) {},
  keywords: ['reset', 'tutorial', 'developer'],
);

// --- LABS ---
final enableLabsSwitch = SettingsItemSwitch(
  id: 'dev_enable_labs',
  title: 'Enable Labs',
  storageKey: 'dev_enable_labs',
  defaultValue: false,
  icon: Icons.science,
  isVisible: _isDebugOnly,
  keywords: ['labs', 'experimental', 'developer'],
);

const labsAiAssistant = SettingsItemSwitch(
  id: 'labs_ai_assistant',
  title: 'AI Productivity Assistant',
  subtitle: 'Coming Soon',
  storageKey: 'labs_ai_assistant',
  defaultValue: false,
  icon: Icons.smart_toy,
  keywords: ['ai', 'assistant', 'smart', 'labs'],
);

const labsVoiceTask = SettingsItemSwitch(
  id: 'labs_voice_task',
  title: 'Voice Task Creation',
  subtitle: 'Coming Soon',
  storageKey: 'labs_voice_task',
  defaultValue: false,
  icon: Icons.mic,
  keywords: ['voice', 'task', 'audio', 'labs'],
);

// --- ABOUT ---
const appVersionInfo = SettingsItemInfo(
  id: 'about_version',
  title: 'App Version',
  valueLabel: '1.0.0',
  icon: Icons.info,
  keywords: ['app', 'version', 'about'],
);

const buildNumberInfo = SettingsItemInfo(
  id: 'about_build',
  title: 'Build Number',
  valueLabel: '42',
  icon: Icons.numbers,
  keywords: ['build', 'number', 'about'],
);

final osLicensesAction = SettingsItemAction(
  id: 'about_licenses',
  title: 'Open Source Licenses',
  icon: Icons.code,
  onAction: (context, ref) {}, // Handled in UI layer via router or built-in showLicensePage
  keywords: ['open source', 'licenses', 'about', 'legal'],
);

// --- RESET ---
final resetAppearanceAction = SettingsItemAction(
  id: 'reset_appearance',
  title: 'Reset Appearance',
  icon: Icons.format_paint,
  onAction: (context, ref) {},
  keywords: ['reset', 'appearance', 'theme', 'color'],
);

final factoryResetAction = SettingsItemAction(
  id: 'reset_factory',
  title: 'Factory Reset',
  icon: Icons.warning,
  isDestructive: true,
  onAction: (context, ref) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Factory Reset triggered')));
  },
  keywords: ['factory', 'reset', 'clear', 'delete', 'all'],
);

const backupSizeInfo = SettingsItemInfo(
  id: 'data_backup_size',
  title: 'Backup Size',
  valueLabel: '850 KB',
  icon: Icons.sd_storage,
  keywords: ['backup', 'size', 'storage'],
);

const lastBackupInfo = SettingsItemInfo(
  id: 'data_last_backup',
  title: 'Last Backup',
  valueLabel: 'Yesterday',
  icon: Icons.history,
  keywords: ['last', 'backup', 'date'],
);


// ==========================================
// SEARCH QUERY PROVIDER
// ==========================================
final settingsSearchQueryProvider = StateProvider<String>((ref) => '');

// ==========================================
// SECTIONS PROVIDER
// ==========================================
final settingsSectionsProvider = Provider<List<SettingsSection>>((ref) {
  final statsAsync = ref.watch(databaseStatsProvider);
  final stats = statsAsync.valueOrNull;

  final dynamicDatabaseSizeInfo = SettingsItemInfo(
    id: 'data_db_size',
    title: 'Database Size',
    valueLabel: stats != null ? stats['dbSize'] : '...',
    icon: Icons.storage,
    keywords: ['database', 'size', 'storage', 'data'],
  );

  final dynamicTaskCountInfo = SettingsItemInfo(
    id: 'data_task_count',
    title: 'Task Count',
    valueLabel: stats != null ? '' : '...',
    icon: Icons.task,
    keywords: ['task', 'count', 'total'],
  );

  final dynamicCompletedTaskCountInfo = SettingsItemInfo(
    id: 'data_completed_tasks',
    title: 'Completed Tasks',
    valueLabel: stats != null ? '' : '...',
    icon: Icons.check_circle,
    keywords: ['completed', 'task', 'count'],
  );

  final dynamicArchivedTaskCountInfo = SettingsItemInfo(
    id: 'data_archived_tasks',
    title: 'Archived Tasks',
    valueLabel: stats != null ? '' : '...',
    icon: Icons.archive,
    keywords: ['archived', 'task', 'count'],
  );

  final dynamicTagCountInfo = SettingsItemInfo(
    id: 'data_tag_count',
    title: 'Tag Count',
    valueLabel: stats != null ? '' : '...',
    icon: Icons.label,
    keywords: ['tag', 'count', 'labels'],
  );

  return [
    const SettingsSection(
      id: 'appearance',
      title: 'Appearance',
      items: [
        themeDropdown,
        appAccentPicker,
        calendarAccentPicker,
        taskCardStyleDropdown,
        fontSizeDropdown,
        animationSpeedDropdown,
        reduceMotionSwitch,
        materialYouSwitch,
      ],
    ),
    const SettingsSection(
      id: 'task_preferences',
      title: 'Task Preferences',
      items: [
        defaultPriorityDropdown,
        defaultReminderDropdown,
        defaultRepeatDropdown,
        defaultTagDropdown,
        autoArchiveSwitch,
        completedTaskVisDropdown,
      ],
    ),
    const SettingsSection(
      id: 'calendar',
      title: 'Calendar',
      items: [
        weekStartsDropdown,
        defaultViewDropdown,
        calendarDensityDropdown,
        calendarShowCompletedSwitch,
        calendarAccentPicker,
      ],
    ),
    SettingsSection(
      id: 'notifications',
      title: 'Notifications',
      items: [
        masterNotificationToggle,
        notificationSoundDropdown,
        vibrationSwitch,
        quietHoursAction,
        reminderPreviewSwitch,
        notificationGroupingSwitch,
      ],
    ),
    SettingsSection(
      id: 'backup_restore',
      title: 'Backup & Restore',
      items: [
        backupModuleNav,
        autoBackupFreqDropdown,
        manualBackupAction,
        restoreBackupAction,
        backupHistoryNav,
      ],
    ),
    const SettingsSection(
      id: 'widgets',
      title: 'Widgets',
      items: [
        enableWidgetsSwitch,
        widgetThemeDropdown,
        widgetRefreshDropdown,
      ],
    ),
    const SettingsSection(
      id: 'accessibility',
      title: 'Accessibility',
      items: [
        largeTextSwitch,
        highContrastSwitch,
        reduceMotionSwitch,
        hapticFeedbackSwitch,
        touchTargetDropdown,
      ],
    ),
    SettingsSection(
      id: 'data_storage',
      title: 'Data & Storage',
      items: [
        dynamicDatabaseSizeInfo,
        dynamicTaskCountInfo,
        dynamicCompletedTaskCountInfo,
        dynamicArchivedTaskCountInfo,
        dynamicTagCountInfo,
        backupSizeInfo,
        lastBackupInfo,
        clearCacheAction,
        optimizeDbAction,
      ],
    ),
    SettingsSection(
      id: 'developer',
      title: 'Developer',
      items: [
        debugLogsSwitch,
        performanceOverlaySwitch,
        resetTutorialAction,
        enableLabsSwitch,
      ],
    ),
    const SettingsSection(
      id: 'labs',
      title: 'Labs (Experimental)',
      items: [
        labsAiAssistant,
        labsVoiceTask,
      ],
    ),
    SettingsSection(
      id: 'about',
      title: 'About',
      items: [
        appVersionInfo,
        buildNumberInfo,
        osLicensesAction,
      ],
    ),
    SettingsSection(
      id: 'reset',
      title: 'Reset',
      items: [
        resetAppearanceAction,
        factoryResetAction,
      ],
    ),
  ];
});

// Filtered Sections
final filteredSettingsSectionsProvider = Provider<List<SettingsSection>>((ref) {
  final sections = ref.watch(settingsSectionsProvider);
  final query = ref.watch(settingsSearchQueryProvider).toLowerCase().trim();
  
  if (query.isEmpty) {
    return sections.map((section) {
      final visibleItems = section.items.where((item) => item.isVisible?.call() ?? true).toList();
      return SettingsSection(id: section.id, title: section.title, items: visibleItems);
    }).where((section) => section.items.isNotEmpty).toList();
  }

  return sections.map((section) {
    final filteredItems = section.items.where((item) {
      final isVisible = item.isVisible?.call() ?? true;
      if (!isVisible) return false;
      
      final titleMatch = item.title.toLowerCase().contains(query);
      final subtitleMatch = item.subtitle?.toLowerCase().contains(query) ?? false;
      final keywordMatch = item.keywords.any((k) => k.toLowerCase().contains(query));
      
      return titleMatch || subtitleMatch || keywordMatch;
    }).toList();
    
    return SettingsSection(id: section.id, title: section.title, items: filteredItems);
  }).where((section) => section.items.isNotEmpty).toList();
});

// A family provider for fetching/updating boolean settings
class SettingSwitchNotifier extends FamilyAsyncNotifier<bool, SettingsItemSwitch> {
  @override
  FutureOr<bool> build(SettingsItemSwitch arg) async {
    final prefs = ref.read(preferencesProvider);
    final val = await prefs.read(arg.storageKey);
    if (val != null) {
      return val.toString() == 'true';
    }
    return arg.defaultValue;
  }

  Future<void> toggle() async {
    final currentState = state.value ?? arg.defaultValue;
    final newState = !currentState;
    state = AsyncValue.data(newState);
    await ref.read(preferencesProvider).write(arg.storageKey, newState.toString());
  }
}

final settingSwitchProvider = AsyncNotifierProviderFamily<SettingSwitchNotifier, bool, SettingsItemSwitch>(() {
  return SettingSwitchNotifier();
});

// A family provider for string/dropdown settings
class SettingDropdownNotifier extends FamilyAsyncNotifier<String, SettingsItemDropdown<String>> {
  @override
  FutureOr<String> build(SettingsItemDropdown<String> arg) async {
    final prefs = ref.read(preferencesProvider);
    final val = await prefs.read(arg.storageKey);
    if (val != null) {
      return val.toString();
    }
    return arg.defaultValue;
  }

  Future<void> updateValue(String newValue) async {
    state = AsyncValue.data(newValue);
    await ref.read(preferencesProvider).write(arg.storageKey, newValue);
  }
}

final settingDropdownProvider = AsyncNotifierProviderFamily<SettingDropdownNotifier, String, SettingsItemDropdown<String>>(() {
  return SettingDropdownNotifier();
});
