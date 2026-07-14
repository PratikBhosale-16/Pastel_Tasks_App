import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pastel_tasks/features/stats/domain/models/stats_data.dart';

class DonutChartCard extends StatelessWidget {
  const DonutChartCard({
    required this.stats,
    super.key,
  });

  final StatsData stats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // For now, it seems the screenshot shows an empty/default state with a light blue ring.
    
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F7FB),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Completed Tasks',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_drop_down,
                    color: Color(0xFF7A8699),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'In 30 days',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF7A8699),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_drop_down,
                    size: 18,
                    color: Color(0xFF7A8699),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: 35,
                    sections: [
                      PieChartSectionData(
                        color: const Color(0xFFE2EAFB), // Light blue ring
                        value: 100,
                        title: '',
                        radius: 15,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 32),
              Expanded(
                child: Text(
                  'No Pending Tasks',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF7A8699),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
