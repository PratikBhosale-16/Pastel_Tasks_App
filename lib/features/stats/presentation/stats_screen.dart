import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pastel_tasks/features/stats/presentation/providers/stats_provider.dart';
import 'package:pastel_tasks/features/stats/presentation/widgets/animated_stat_card.dart';
import 'package:pastel_tasks/features/stats/presentation/widgets/charts/completion_heatmap.dart';
import 'package:pastel_tasks/features/stats/presentation/widgets/charts/priority_pie_chart.dart';
import 'package:pastel_tasks/features/stats/presentation/widgets/charts/weekly_bar_chart.dart';
import 'package:pastel_tasks/features/stats/presentation/widgets/productivity_score.dart';
import 'package:pastel_tasks/features/stats/presentation/widgets/streak_display.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(statsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Productivity'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                ProductivityScoreWidget(score: stats.productivityScore),
                const SizedBox(height: 24),
                
                Row(
                  children: [
                    Expanded(
                      child: AnimatedStatCard(
                        title: 'Today',
                        value: stats.completedToday,
                        icon: Icons.check_circle_outline,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AnimatedStatCard(
                        title: 'This Week',
                        value: stats.completedThisWeek,
                        icon: Icons.date_range_outlined,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AnimatedStatCard(
                        title: 'Total',
                        value: stats.totalCompleted,
                        icon: Icons.task_alt,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                StreakDisplay(
                  currentStreak: stats.currentStreak,
                  longestStreak: stats.longestStreak,
                ),
                const SizedBox(height: 24),
                
                CompletionHeatmap(heatmapData: stats.heatmapData),
                const SizedBox(height: 24),
                
                WeeklyBarChart(last7DaysCompletion: stats.last7DaysCompletion),
                const SizedBox(height: 24),
                
                if (stats.priorityBreakdown.values.any((v) => v > 0)) ...[
                  PriorityPieChart(priorityBreakdown: stats.priorityBreakdown),
                  const SizedBox(height: 24),
                ],
                
                if (stats.mostProductiveWeekday != null || stats.mostProductiveHour != null) ...[
                  Text(
                    'Insights',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (stats.mostProductiveWeekday != null)
                    _InsightTile(
                      icon: Icons.calendar_today_rounded,
                      title: 'Most Productive Day',
                      subtitle: _getWeekday(stats.mostProductiveWeekday!),
                    ),
                  if (stats.mostProductiveHour != null) ...[
                    const SizedBox(height: 8),
                    _InsightTile(
                      icon: Icons.schedule_rounded,
                      title: 'Most Productive Hour',
                      subtitle: _getHour(stats.mostProductiveHour!),
                    ),
                  ],
                  if (stats.averageCompletionTimeMinutes != null) ...[
                    const SizedBox(height: 8),
                    _InsightTile(
                      icon: Icons.timer_outlined,
                      title: 'Average Completion Time',
                      subtitle: _formatMinutes(stats.averageCompletionTimeMinutes!),
                    ),
                  ],
                  const SizedBox(height: 32),
                ],
              ]),
            ),
          ),
        ],
      ),
    );
  }

  String _getWeekday(int weekday) {
    const days = [
      '',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    if (weekday < 1 || weekday > 7) return 'Unknown';
    return days[weekday];
  }

  String _getHour(int hour) {
    if (hour == 0) return '12 AM';
    if (hour == 12) return '12 PM';
    if (hour > 12) return '${hour - 12} PM';
    return '$hour AM';
  }

  String _formatMinutes(int minutes) {
    if (minutes < 60) return '$minutes mins';
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (mins == 0) return '$hours hrs';
    return '$hours hrs $mins mins';
  }
}

class _InsightTile extends StatelessWidget {
  const _InsightTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Text(
            subtitle,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
