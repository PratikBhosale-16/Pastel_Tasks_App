import 'package:flutter/material.dart';

class StreakDisplay extends StatelessWidget {
  const StreakDisplay({
    required this.currentStreak,
    required this.longestStreak,
    super.key,
  });

  final int currentStreak;
  final int longestStreak;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StreakCard(
            title: 'Current Streak',
            value: currentStreak,
            icon: Icons.local_fire_department_rounded,
            iconColor: Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StreakCard(
            title: 'Longest Streak',
            value: longestStreak,
            icon: Icons.emoji_events_rounded,
            iconColor: Colors.amber,
          ),
        ),
      ],
    );
  }
}

class _StreakCard extends StatelessWidget {
  const _StreakCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  final String title;
  final int value;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(height: 8),
          TweenAnimationBuilder<int>(
            tween: IntTween(begin: 0, end: value),
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeOutBack,
            builder: (context, val, child) {
              return Text(
                '$val Days',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              );
            },
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
