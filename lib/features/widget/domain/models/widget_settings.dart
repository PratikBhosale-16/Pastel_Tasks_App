import 'package:equatable/equatable.dart';

class WidgetSettings extends Equatable {
  const WidgetSettings({
    this.showCompleted = true,
    this.showUpcoming = true,
    this.showOnlyToday = false,
    this.showArchived = false,
    this.maxTaskCount = 5,
    this.accentColor = '',
    this.transparency = 1.0,
    this.cornerRadius = 16.0,
    this.compactMode = false,
    this.showGreeting = true,
    this.showProgress = true,
    this.autoRefreshInterval = 15,
  });

  final bool showCompleted;
  final bool showUpcoming;
  final bool showOnlyToday;
  final bool showArchived;
  final int maxTaskCount;
  final String accentColor;
  final double transparency;
  final double cornerRadius;
  final bool compactMode;
  final bool showGreeting;
  final bool showProgress;
  final int autoRefreshInterval;

  WidgetSettings copyWith({
    bool? showCompleted,
    bool? showUpcoming,
    bool? showOnlyToday,
    bool? showArchived,
    int? maxTaskCount,
    String? accentColor,
    double? transparency,
    double? cornerRadius,
    bool? compactMode,
    bool? showGreeting,
    bool? showProgress,
    int? autoRefreshInterval,
  }) {
    return WidgetSettings(
      showCompleted: showCompleted ?? this.showCompleted,
      showUpcoming: showUpcoming ?? this.showUpcoming,
      showOnlyToday: showOnlyToday ?? this.showOnlyToday,
      showArchived: showArchived ?? this.showArchived,
      maxTaskCount: maxTaskCount ?? this.maxTaskCount,
      accentColor: accentColor ?? this.accentColor,
      transparency: transparency ?? this.transparency,
      cornerRadius: cornerRadius ?? this.cornerRadius,
      compactMode: compactMode ?? this.compactMode,
      showGreeting: showGreeting ?? this.showGreeting,
      showProgress: showProgress ?? this.showProgress,
      autoRefreshInterval: autoRefreshInterval ?? this.autoRefreshInterval,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'showCompleted': showCompleted,
      'showUpcoming': showUpcoming,
      'showOnlyToday': showOnlyToday,
      'showArchived': showArchived,
      'maxTaskCount': maxTaskCount,
      'accentColor': accentColor,
      'transparency': transparency,
      'cornerRadius': cornerRadius,
      'compactMode': compactMode,
      'showGreeting': showGreeting,
      'showProgress': showProgress,
      'autoRefreshInterval': autoRefreshInterval,
    };
  }

  factory WidgetSettings.fromJson(Map<String, dynamic> json) {
    return WidgetSettings(
      showCompleted: json['showCompleted'] as bool? ?? true,
      showUpcoming: json['showUpcoming'] as bool? ?? true,
      showOnlyToday: json['showOnlyToday'] as bool? ?? false,
      showArchived: json['showArchived'] as bool? ?? false,
      maxTaskCount: json['maxTaskCount'] as int? ?? 5,
      accentColor: json['accentColor'] as String? ?? '',
      transparency: (json['transparency'] as num?)?.toDouble() ?? 1.0,
      cornerRadius: (json['cornerRadius'] as num?)?.toDouble() ?? 16.0,
      compactMode: json['compactMode'] as bool? ?? false,
      showGreeting: json['showGreeting'] as bool? ?? true,
      showProgress: json['showProgress'] as bool? ?? true,
      autoRefreshInterval: json['autoRefreshInterval'] as int? ?? 15,
    );
  }

  @override
  List<Object?> get props => [
        showCompleted,
        showUpcoming,
        showOnlyToday,
        showArchived,
        maxTaskCount,
        accentColor,
        transparency,
        cornerRadius,
        compactMode,
        showGreeting,
        showProgress,
        autoRefreshInterval,
      ];
}
