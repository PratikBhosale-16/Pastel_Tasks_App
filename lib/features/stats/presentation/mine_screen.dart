import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pastel_tasks/features/stats/presentation/providers/stats_provider.dart';
import 'package:pastel_tasks/features/stats/presentation/widgets/charts/completion_heatmap.dart';
import 'package:pastel_tasks/features/stats/presentation/widgets/charts/donut_chart_card.dart';
import 'package:pastel_tasks/features/stats/presentation/widgets/charts/daily_completed_chart.dart';
import 'package:pastel_tasks/features/stats/presentation/widgets/charts/focus_chart_card.dart';

class MineScreen extends ConsumerWidget {
  const MineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(statsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Profile Header
                  _buildProfileHeader(theme),
                  const SizedBox(height: 24),

                  // Overview Stats
                  _buildOverviewStats(theme, stats.totalCompleted, stats.longestStreak),
                  const SizedBox(height: 16),

                  // Annual Heatmap
                  CompletionHeatmap(heatmapData: stats.heatmapData),
                  const SizedBox(height: 16),

                  // Completed Tasks Donut Chart
                  DonutChartCard(stats: stats),
                  const SizedBox(height: 16),

                  // Daily Completed Bar Chart
                  DailyCompletedChart(stats: stats),
                  const SizedBox(height: 16),

                  // Focus Line Chart
                  const FocusChartCard(),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(ThemeData theme) {
    return Row(
      children: [
        CircleAvatar(
          radius: 36,
          backgroundColor: theme.colorScheme.surfaceContainerHighest,
          child: Icon(
            Icons.person,
            size: 40,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'John Doe', // Dummy data
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Age: 28', // Dummy data
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.edit_outlined),
          onPressed: () {},
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ],
    );
  }

  Widget _buildOverviewStats(ThemeData theme, int completed, int perfectDay) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(theme, 'Completed Tasks', completed.toString()),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(theme, 'Perfect Day', perfectDay.toString(), showHelpInfo: true),
        ),
      ],
    );
  }

  Widget _buildStatCard(ThemeData theme, String title, String value, {bool showHelpInfo = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F5FA), // Light blue-ish gray from screenshot
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            children: [
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF7A8699),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          if (showHelpInfo)
            Positioned(
              right: -8,
              top: -16,
              child: Icon(
                Icons.help_outline,
                size: 16,
                color: const Color(0xFF7A8699).withOpacity(0.5),
              ),
            ),
        ],
      ),
    );
  }
}
