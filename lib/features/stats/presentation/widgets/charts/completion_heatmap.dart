import 'package:flutter/material.dart';

class CompletionHeatmap extends StatelessWidget {
  const CompletionHeatmap({
    required this.heatmapData,
    super.key,
  });

  /// Map of Date (normalized to midnight) -> number of completions
  final Map<DateTime, int> heatmapData;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Determine the max value for color scaling
    int maxCompletions = 1;
    if (heatmapData.isNotEmpty) {
      maxCompletions = heatmapData.values.reduce((a, b) => a > b ? a : b);
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    // We want 14 weeks of data (approx 3 months)
    const weeksToDisplay = 14;
    const daysToDisplay = weeksToDisplay * 7;
    
    // Ensure we start on a Sunday for alignment (or Monday based on preference, standard is Sunday)
    // today.weekday returns 1 (Monday) to 7 (Sunday).
    // So if today is Wednesday (3), the Sunday of this week was 3 days ago.
    final offsetToSunday = today.weekday % 7; 
    
    // The very first day of the grid
    final startDate = today.subtract(Duration(days: daysToDisplay - 1 + offsetToSunday));

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
              'Activity',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true, // Start from the right (today)
              child: SizedBox(
                height: 120,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Y-axis labels
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _DayLabel('Sun'),
                        const SizedBox(height: 12),
                        _DayLabel('Tue'),
                        const SizedBox(height: 12),
                        _DayLabel('Thu'),
                        const SizedBox(height: 12),
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
                                  child: SizedBox(width: 12, height: 12),
                                );
                              }
                              
                              final completions = heatmapData[date] ?? 0;
                              
                              Color cellColor;
                              if (completions == 0) {
                                cellColor = theme.colorScheme.surfaceContainerHighest.withOpacity(0.5);
                              } else {
                                final intensity = (completions / maxCompletions).clamp(0.2, 1.0);
                                cellColor = theme.colorScheme.primary.withOpacity(intensity);
                              }

                              return Tooltip(
                                message: '${date.month}/${date.day}/${date.year}: $completions completions',
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  margin: const EdgeInsets.only(bottom: 4),
                                  decoration: BoxDecoration(
                                    color: cellColor,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
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
          ],
        ),
      ),
    );
  }
}

class _DayLabel extends StatelessWidget {
  const _DayLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        fontSize: 10,
      ),
    );
  }
}
