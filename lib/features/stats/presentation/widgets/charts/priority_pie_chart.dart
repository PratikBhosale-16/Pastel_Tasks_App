import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/priority.dart';

class PriorityPieChart extends StatelessWidget {
  const PriorityPieChart({
    required this.priorityBreakdown,
    super.key,
  });

  final Map<Priority, int> priorityBreakdown;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    final low = priorityBreakdown[Priority.low] ?? 0;
    final medium = priorityBreakdown[Priority.medium] ?? 0;
    final high = priorityBreakdown[Priority.high] ?? 0;
    final total = low + medium + high;

    if (total == 0) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Priority Breakdown',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 60,
                      sections: [
                        if (low > 0)
                          PieChartSectionData(
                            color: Colors.green.shade400,
                            value: low.toDouble(),
                            title: '${((low / total) * 100).round()}%',
                            radius: 20,
                            titleStyle: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        if (medium > 0)
                          PieChartSectionData(
                            color: Colors.orange.shade400,
                            value: medium.toDouble(),
                            title: '${((medium / total) * 100).round()}%',
                            radius: 20,
                            titleStyle: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        if (high > 0)
                          PieChartSectionData(
                            color: Colors.red.shade400,
                            value: high.toDouble(),
                            title: '${((high / total) * 100).round()}%',
                            radius: 20,
                            titleStyle: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        total.toString(),
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        'Completed',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _Indicator(color: Colors.red.shade400, text: 'High'),
                const SizedBox(width: 16),
                _Indicator(color: Colors.orange.shade400, text: 'Medium'),
                const SizedBox(width: 16),
                _Indicator(color: Colors.green.shade400, text: 'Low'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Indicator extends StatelessWidget {
  const _Indicator({
    required this.color,
    required this.text,
  });

  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
