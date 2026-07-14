import 'package:flutter/material.dart';

class FocusChartCard extends StatelessWidget {
  const FocusChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // For now, mirroring the exact static UI from screenshot for Focus chart empty state
    // "Focus" | "12/7 - 18/7"
    // "Total focus time this week 0 min"
    
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
                'Focus',
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
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                'Total focus time this week',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF7A8699),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '0 min',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF7A9CF5),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
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
                        _YLabel('12'),
                        _YLabel('9'),
                        _YLabel('6'),
                        _YLabel('3'),
                        _YLabel('0'),
                      ],
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Stack(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _GridLine(),
                              _GridLine(),
                              _GridLine(),
                              _GridLine(),
                              _GridLine(),
                            ],
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: const [
                                _XLabel('Sun'),
                                _XLabel('Mon'),
                                _XLabel('Tue'),
                                _XLabel('Wed'),
                                _XLabel('Thu'),
                                _XLabel('Fri'),
                                _XLabel('Sat'),
                              ],
                            ),
                          )
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
                  'No Focus Data',
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

class _XLabel extends StatelessWidget {
  const _XLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: const Color(0xFF7A8699),
      ),
    );
  }
}

class _GridLine extends StatelessWidget {
  const _GridLine();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 20),
      child: Container(
        height: 1,
        color: const Color(0xFFE2EAFB).withOpacity(0.5),
      ),
    );
  }
}
