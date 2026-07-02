import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pastel_tasks/features/stats/domain/models/stats_data.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/task_status.dart';
import 'package:pastel_tasks/features/tasks/domain/models/task.dart';
import 'package:pastel_tasks/features/tasks/presentation/providers/task_providers.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/priority.dart';

final statsProvider = Provider<StatsData>((ref) {
  final asyncTasks = ref.watch(taskListProvider);
  return asyncTasks.maybeWhen(
    data: (tasks) => _computeStats(tasks),
    orElse: () => StatsData.empty(),
  );
});

StatsData _computeStats(List<Task> tasks) {
  final completedTasks = tasks
      .where((t) => t.status == TaskStatus.completed && t.completedAt != null)
      .toList();

  if (completedTasks.isEmpty) {
    return StatsData.empty();
  }

  final now = DateTime.now();
  final todayMidnight = DateTime(now.year, now.month, now.day);
  
  int completedToday = 0;
  int completedThisWeek = 0;
  int completedThisMonth = 0;
  
  final Map<DateTime, int> heatmapData = {};
  final Map<Priority, int> priorityBreakdown = {
    Priority.low: 0,
    Priority.medium: 0,
    Priority.high: 0,
  };
  final Map<String, int> tagBreakdown = {};
  final List<int> last7DaysCompletion = List.filled(7, 0);
  
  final Map<int, int> weekdayCounts = {};
  final Map<int, int> hourCounts = {};
  int totalCompletionTime = 0;
  
  // Calculate date thresholds
  final startOfWeek = todayMidnight.subtract(Duration(days: todayMidnight.weekday - 1));
  final startOfMonth = DateTime(now.year, now.month, 1);
  final sevenDaysAgo = todayMidnight.subtract(const Duration(days: 6));

  for (final task in completedTasks) {
    final completedAt = task.completedAt!;
    final completedMidnight = DateTime(completedAt.year, completedAt.month, completedAt.day);
    
    // Update daily/weekly/monthly counts
    if (completedMidnight == todayMidnight) completedToday++;
    if (!completedMidnight.isBefore(startOfWeek)) completedThisWeek++;
    if (!completedMidnight.isBefore(startOfMonth)) completedThisMonth++;
    
    // Last 7 days array
    if (!completedMidnight.isBefore(sevenDaysAgo)) {
      final daysAgo = todayMidnight.difference(completedMidnight).inDays;
      if (daysAgo >= 0 && daysAgo < 7) {
        last7DaysCompletion[6 - daysAgo]++;
      }
    }
    
    // Heatmap
    heatmapData[completedMidnight] = (heatmapData[completedMidnight] ?? 0) + 1;
    
    // Priority Breakdown
    priorityBreakdown[task.priority] = (priorityBreakdown[task.priority] ?? 0) + 1;
    
    // Tag Breakdown
    for (final tag in task.tags) {
      tagBreakdown[tag] = (tagBreakdown[tag] ?? 0) + 1;
    }
    
    // Weekday & Hour
    weekdayCounts[completedAt.weekday] = (weekdayCounts[completedAt.weekday] ?? 0) + 1;
    hourCounts[completedAt.hour] = (hourCounts[completedAt.hour] ?? 0) + 1;
    
    // Average time
    totalCompletionTime += completedAt.difference(task.createdAt).inMinutes;
  }
  
  int? mostProductiveWeekday;
  if (weekdayCounts.isNotEmpty) {
    mostProductiveWeekday = weekdayCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }
  
  int? mostProductiveHour;
  if (hourCounts.isNotEmpty) {
    mostProductiveHour = hourCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }
  
  int? averageCompletionTimeMinutes;
  if (completedTasks.isNotEmpty) {
    averageCompletionTimeMinutes = totalCompletionTime ~/ completedTasks.length;
  }
  
  // Calculate streaks
  final sortedDates = heatmapData.keys.toList()..sort((a, b) => b.compareTo(a));
  
  int currentStreak = 0;
  int longestStreak = 0;
  
  if (sortedDates.isNotEmpty) {
    // Check if the streak is still alive (either today or yesterday)
    final firstDate = sortedDates.first;
    final isAlive = firstDate == todayMidnight || firstDate == todayMidnight.subtract(const Duration(days: 1));
    
    if (isAlive) {
      currentStreak = 1;
      var previousDate = firstDate;
      for (int i = 1; i < sortedDates.length; i++) {
        final expectedDate = previousDate.subtract(const Duration(days: 1));
        if (sortedDates[i] == expectedDate) {
          currentStreak++;
          previousDate = sortedDates[i];
        } else {
          break;
        }
      }
    }
    
    // Find longest streak
    int tempStreak = 1;
    longestStreak = 1;
    for (int i = 0; i < sortedDates.length - 1; i++) {
      final diff = sortedDates[i].difference(sortedDates[i+1]).inDays;
      if (diff == 1) {
        tempStreak++;
        if (tempStreak > longestStreak) {
          longestStreak = tempStreak;
        }
      } else {
        tempStreak = 1;
      }
    }
  }
  
  // Simple productivity score: recent completions heavily weighted + priority bonuses
  int score = (completedToday * 10) + (completedThisWeek * 5) + (completedThisMonth * 2);
  final highPriority = priorityBreakdown[Priority.high] ?? 0;
  score += highPriority * 5;

  return StatsData(
    totalCompleted: completedTasks.length,
    completedToday: completedToday,
    completedThisWeek: completedThisWeek,
    completedThisMonth: completedThisMonth,
    currentStreak: currentStreak,
    longestStreak: longestStreak,
    mostProductiveWeekday: mostProductiveWeekday,
    mostProductiveHour: mostProductiveHour,
    averageCompletionTimeMinutes: averageCompletionTimeMinutes,
    productivityScore: score,
    heatmapData: heatmapData,
    priorityBreakdown: priorityBreakdown,
    tagBreakdown: tagBreakdown,
    last7DaysCompletion: last7DaysCompletion,
  );
}
