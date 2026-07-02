import 'package:flutter/material.dart';

class ProductivityScoreWidget extends StatelessWidget {
  const ProductivityScoreWidget({
    required this.score,
    super.key,
  });

  final int score;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.tertiary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Productivity Score',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _getScoreMessage(score),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onPrimary.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.onPrimary.withOpacity(0.2),
              border: Border.all(
                color: theme.colorScheme.onPrimary.withOpacity(0.5),
                width: 2,
              ),
            ),
            child: Center(
              child: TweenAnimationBuilder<int>(
                tween: IntTween(begin: 0, end: score),
                duration: const Duration(milliseconds: 1500),
                curve: Curves.easeOutCubic,
                builder: (context, val, child) {
                  return Text(
                    val.toString(),
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getScoreMessage(int score) {
    if (score == 0) return "Let's get started today!";
    if (score < 50) return 'Good start, keep it up!';
    if (score < 150) return 'You are on a roll!';
    if (score < 300) return 'Amazing productivity!';
    return 'Unstoppable force!';
  }
}
