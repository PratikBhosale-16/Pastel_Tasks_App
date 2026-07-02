import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WeeklyBarChart extends StatelessWidget {
  const WeeklyBarChart({
    required this.last7DaysCompletion,
    super.key,
  });

  /// 7 values, where index 6 is today, index 5 is yesterday, etc.
  final List<int> last7DaysCompletion;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();

    final maxY = last7DaysCompletion.isEmpty ? 5.0 : (last7DaysCompletion.reduce((a, b) => a > b ? a : b) + 2).toDouble();

    return AspectRatio(
      aspectRatio: 1.5,
      child: Card(
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
                'Last 7 Days',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: maxY,
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipColor: (group) => theme.colorScheme.primaryContainer,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          return BarTooltipItem(
                            rod.toY.toInt().toString(),
                            theme.textTheme.bodyMedium!.copyWith(
                              color: theme.colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final daysAgo = 6 - value.toInt();
                            final date = now.subtract(Duration(days: daysAgo));
                            final weekdayStr = _getWeekdayShort(date.weekday);
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                weekdayStr,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            );
                          },
                          reservedSize: 28,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    gridData: FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    barGroups: List.generate(7, (i) {
                      return BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: last7DaysCompletion[i].toDouble(),
                            color: theme.colorScheme.primary,
                            width: 16,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(4),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getWeekdayShort(int weekday) {
    switch (weekday) {
      case 1: return 'Mon';
      case 2: return 'Tue';
      case 3: return 'Wed';
      case 4: return 'Thu';
      case 5: return 'Fri';
      case 6: return 'Sat';
      case 7: return 'Sun';
      default: return '';
    }
  }
}
