import 'package:equatable/equatable.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/priority.dart';

/// Represents a computed snapshot of the user's productivity statistics.
class StatsData extends Equatable {
  const StatsData({
    required this.totalCompleted,
    required this.completedToday,
    required this.completedThisWeek,
    required this.completedThisMonth,
    required this.currentStreak,
    required this.longestStreak,
    required this.mostProductiveWeekday,
    required this.mostProductiveHour,
    required this.averageCompletionTimeMinutes,
    required this.productivityScore,
    required this.heatmapData,
    required this.priorityBreakdown,
    required this.tagBreakdown,
    required this.last7DaysCompletion,
  });

  /// Total tasks ever completed
  final int totalCompleted;
  
  /// Completed today
  final int completedToday;
  
  /// Completed in the last 7 days
  final int completedThisWeek;
  
  /// Completed in the current month
  final int completedThisMonth;
  
  /// Current consecutive days with at least 1 completion
  final int currentStreak;
  
  /// Longest consecutive days with at least 1 completion
  final int longestStreak;
  
  /// 1 = Monday, 7 = Sunday (from DateTime.weekday)
  final int? mostProductiveWeekday;
  
  /// 0-23
  final int? mostProductiveHour;
  
  /// Average minutes from creation to completion
  final int? averageCompletionTimeMinutes;
  
  /// A computed score based on task volume and priority
  final int productivityScore;
  
  /// A map of Date (normalized to midnight) -> number of completions
  final Map<DateTime, int> heatmapData;
  
  /// A breakdown of completions by Priority
  final Map<Priority, int> priorityBreakdown;
  
  /// A breakdown of completions by Tag ID
  final Map<String, int> tagBreakdown;
  
  /// A list of 7 integers, where index 0 is 6 days ago, and index 6 is today.
  final List<int> last7DaysCompletion;

  factory StatsData.empty() {
    return const StatsData(
      totalCompleted: 0,
      completedToday: 0,
      completedThisWeek: 0,
      completedThisMonth: 0,
      currentStreak: 0,
      longestStreak: 0,
      mostProductiveWeekday: null,
      mostProductiveHour: null,
      averageCompletionTimeMinutes: null,
      productivityScore: 0,
      heatmapData: {},
      priorityBreakdown: {},
      tagBreakdown: {},
      last7DaysCompletion: [0, 0, 0, 0, 0, 0, 0],
    );
  }

  @override
  List<Object?> get props => [
        totalCompleted,
        completedToday,
        completedThisWeek,
        completedThisMonth,
        currentStreak,
        longestStreak,
        mostProductiveWeekday,
        mostProductiveHour,
        averageCompletionTimeMinutes,
        productivityScore,
        heatmapData,
        priorityBreakdown,
        tagBreakdown,
        last7DaysCompletion,
      ];
}
