import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pastel_tasks/features/settings/presentation/providers/settings_provider.dart';
class DateTimeFormatter {
  final String dateFormatSetting;
  final String timeFormatSetting;

  DateTimeFormatter({
    required this.dateFormatSetting,
    required this.timeFormatSetting,
  });

  String _getDateFormatPattern() {
    switch (dateFormatSetting) {
      case 'MM/DD/YYYY':
        return 'MMM dd, yyyy';
      case 'DD/MM/YYYY':
        return 'dd MMM yyyy';
      case 'YYYY-MM-DD':
        return 'yyyy MMM dd';
      case 'System Default':
      default:
        // By default, fallback to yMMMd or whatever the original was
        return 'MMM d, yyyy';
    }
  }

  String _getShortDateFormatPattern() {
    switch (dateFormatSetting) {
      case 'MM/DD/YYYY':
        return 'MMM dd';
      case 'DD/MM/YYYY':
        return 'dd MMM';
      case 'YYYY-MM-DD':
        return 'yyyy MMM dd';
      case 'System Default':
      default:
        return 'MMM d';
    }
  }
  
  String _getTimeFormatPattern() {
    switch (timeFormatSetting) {
      case '12-Hour':
        return 'h:mm a'; // e.g. 5:08 PM
      case '24-Hour':
        return 'HH:mm'; // e.g. 17:08
      case 'System Default':
      default:
        return 'jm'; 
    }
  }

  String formatDate(DateTime date) {
    if (dateFormatSetting == 'System Default') {
      return DateFormat.yMMMd().format(date);
    }
    return DateFormat(_getDateFormatPattern()).format(date);
  }

  String formatShortDate(DateTime date) {
    if (dateFormatSetting == 'System Default') {
      return DateFormat.MMMd().format(date);
    }
    return DateFormat(_getShortDateFormatPattern()).format(date);
  }

  String formatTime(DateTime time) {
    if (timeFormatSetting == 'System Default') {
      return DateFormat.jm().format(time); // Will be overridden by MediaQuery logic if applicable, but this is for direct DateTime formats
    }
    return DateFormat(_getTimeFormatPattern()).format(time);
  }

  String formatDateTime(DateTime dateTime) {
    if (dateFormatSetting == 'System Default' && timeFormatSetting == 'System Default') {
      return DateFormat.yMd().add_jm().format(dateTime);
    }
    final dateStr = DateFormat(_getDateFormatPattern()).format(dateTime);
    final timeStr = DateFormat(_getTimeFormatPattern()).format(dateTime);
    return '$dateStr $timeStr';
  }
}

final dateTimeFormatterProvider = Provider<DateTimeFormatter>((ref) {
  final dateFormat = ref.watch(settingDropdownProvider(dateFormatDropdown)).value ?? 'System Default';
  final timeFormat = ref.watch(settingDropdownProvider(timeFormatDropdown)).value ?? 'System Default';

  return DateTimeFormatter(
    dateFormatSetting: dateFormat,
    timeFormatSetting: timeFormat,
  );
});
