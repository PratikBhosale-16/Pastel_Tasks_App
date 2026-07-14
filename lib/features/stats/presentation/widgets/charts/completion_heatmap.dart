import 'package:flutter/material.dart';

class CompletionHeatmap extends StatelessWidget {
  const CompletionHeatmap({
    required this.heatmapData,
    super.key,
  });

  final Map<DateTime, int> heatmapData;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    int maxCompletions = 1;
    if (heatmapData.isNotEmpty) {
      maxCompletions = heatmapData.values.reduce((a, b) => a > b ? a : b);
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    // We want to show a large grid similar to GitHub heatmap
    const weeksToDisplay = 18;
    const daysToDisplay = weeksToDisplay * 7;
    
    final offsetToSunday = today.weekday % 7; 
    final startDate = today.subtract(Duration(days: daysToDisplay - 1 + offsetToSunday));

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F7FB), // Very light grey/blue from design
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Annual Heatmap',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.help_outline,
                    size: 16,
                    color: const Color(0xFF7A8699).withOpacity(0.5),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    '${now.year}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF7A8699),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_drop_down,
                    color: Color(0xFF7A8699),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Stack(
            alignment: Alignment.center,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                reverse: true,
                child: SizedBox(
                  height: 140,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Y-axis labels
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const [
                          _DayLabel('Sun'),
                          _DayLabel('Mon'),
                          _DayLabel('Tue'),
                          _DayLabel('Wed'),
                          _DayLabel('Thu'),
                          _DayLabel('Fri'),
                          _DayLabel('Sat'),
                        ],
                      ),
                      const SizedBox(width: 8),
                      // Grid
                      Row(
                        children: List.generate(weeksToDisplay, (weekIndex) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 4.0),
                            child: Column(
                              children: List.generate(7, (dayIndex) {
                                final dayOffset = (weekIndex * 7) + dayIndex;
                                final date = startDate.add(Duration(days: dayOffset));
                                
                                if (date.isAfter(today)) {
                                  return const Padding(
                                    padding: EdgeInsets.only(bottom: 4),
                                    child: SizedBox(width: 14, height: 14),
                                  );
                                }
                                
                                final completions = heatmapData[date] ?? 0;
                                
                                Color cellColor;
                                if (completions == 0) {
                                  cellColor = const Color(0xFFE2E8F0); // Gray cell
                                } else {
                                  final intensity = (completions / maxCompletions).clamp(0.4, 1.0);
                                  cellColor = const Color(0xFF7A9CF5).withOpacity(intensity); // Blue cell
                                }

                                return Container(
                                  width: 14,
                                  height: 14,
                                  margin: const EdgeInsets.only(bottom: 4),
                                  decoration: BoxDecoration(
                                    color: cellColor,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                );
                              }),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
              if (heatmapData.isEmpty)
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
        ],
      ),
    );
  }
}

class _DayLabel extends StatelessWidget {
  const _DayLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: const Color(0xFFB0B9C6),
          fontSize: 9,
        ),
      ),
    );
  }
}
