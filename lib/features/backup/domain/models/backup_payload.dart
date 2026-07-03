import 'package:equatable/equatable.dart';

/// Represents a list of items and backup metadata to be stored/restored.
class BackupPayload extends Equatable {
  const BackupPayload({
    required this.version,
    required this.appVersion,
    required this.createdAt,
    required this.tasksJson,
    required this.tagsJson,
    required this.remindersJson,
    required this.preferencesJson,
  });

  /// The schema version of the backup.
  final int version;

  /// The version of the app that created this backup.
  final String appVersion;

  /// When the backup was created.
  final DateTime createdAt;

  /// Raw list of tasks converted to JSON maps.
  final List<Map<String, dynamic>> tasksJson;

  /// Raw list of tags converted to JSON maps.
  final List<Map<String, dynamic>> tagsJson;

  /// Raw list of reminders converted to JSON maps.
  final List<Map<String, dynamic>> remindersJson;

  /// Map of SharedPreferences key-values.
  final Map<String, dynamic> preferencesJson;

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'appVersion': appVersion,
      'createdAt': createdAt.toIso8601String(),
      'tasks': tasksJson,
      'tags': tagsJson,
      'reminders': remindersJson,
      'preferences': preferencesJson,
    };
  }

  factory BackupPayload.fromJson(Map<String, dynamic> json) {
    return BackupPayload(
      version: json['version'] as int? ?? 1,
      appVersion: json['appVersion'] as String? ?? '1.0.0',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : DateTime.now(),
      tasksJson: (json['tasks'] as List<dynamic>?)?.map((e) => e as Map<String, dynamic>).toList() ?? [],
      tagsJson: (json['tags'] as List<dynamic>?)?.map((e) => e as Map<String, dynamic>).toList() ?? [],
      remindersJson: (json['reminders'] as List<dynamic>?)?.map((e) => e as Map<String, dynamic>).toList() ?? [],
      preferencesJson: (json['preferences'] as Map<String, dynamic>?) ?? {},
    );
  }

  @override
  List<Object?> get props => [
        version,
        appVersion,
        createdAt,
        tasksJson,
        tagsJson,
        remindersJson,
        preferencesJson,
      ];
}
