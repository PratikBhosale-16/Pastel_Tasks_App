import 'package:flutter/material.dart';
import 'package:pastel_tasks/features/stats/domain/models/stats_data.dart';

class DailyCompletedChart extends StatelessWidget {
  const DailyCompletedChart({
    required this.stats,
    super.key,
  });

  final StatsData stats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // For now, mirroring the exact static UI from screenshot
    // "Daily Completed" | "12/7 - 18/7"
    // "A light week-plenty of breathing room."
    
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F7FB),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Daily Completed',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.chevron_left, size: 16, color: Color(0xFF7A8699)),
                  Text(
                    '12/7-18/7', // Static placeholder for the week
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF7A8699),
                    ),
                  ),
                  const Icon(Icons.chevron_right, size: 16, color: Color(0xFF7A8699)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'A light week—plenty of breathing room.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF7A8699),
            ),
          ),
          const SizedBox(height: 24),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 150,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        _YLabel('16'),
                        _YLabel('12'),
                        _YLabel('8'),
                        _YLabel('4'),
                        _YLabel('0'),
                      ],
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const [
                          _BarPlaceholder(label: 'Sun'),
                          _BarPlaceholder(label: 'Mon'),
                          _BarPlaceholder(label: 'Tue'),
                          _BarPlaceholder(label: 'Wed'),
                          _BarPlaceholder(label: 'Thu'),
                          _BarPlaceholder(label: 'Fri'),
                          _BarPlaceholder(label: 'Sat'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF7A9CF5),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  'No Task Data',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Text(
                'Tasks Completion Rate',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF7A8699),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '0%',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF7A9CF5),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                'Most Productive Day',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF7A8699),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '--',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF7A9CF5),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _YLabel extends StatelessWidget {
  const _YLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: const Color(0xFFB0B9C6),
      ),
    );
  }
}

class _BarPlaceholder extends StatelessWidget {
  const _BarPlaceholder({required this.label});
  
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 12,
          height: 120, // Full height since it's "empty" background
          decoration: BoxDecoration(
            color: const Color(0xFFE2EAFB),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: const Color(0xFF7A8699),
          ),
        ),
      ],
    );
  }
}
