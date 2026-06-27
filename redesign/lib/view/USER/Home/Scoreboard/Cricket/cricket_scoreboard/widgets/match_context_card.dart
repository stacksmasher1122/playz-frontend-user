import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';

class MatchContextCard extends StatelessWidget {
  final double winProbability;
  final int partnershipRuns;
  final int partnershipBalls;
  final double requiredRunRate;

  const MatchContextCard({
    super.key,
    required this.winProbability,
    required this.partnershipRuns,
    required this.partnershipBalls,
    required this.requiredRunRate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: _contextItem(
              'WIN PROB',
              '${(winProbability * 100).round()}%',
              AppColors.success,
            ),
          ),
          Expanded(
            child: _contextItem(
              'PARTNERSHIP',
              '$partnershipRuns ($partnershipBalls)',
              Colors.white,
            ),
          ),
          if (requiredRunRate > 0)
            Expanded(
              child: _contextItem(
                'RRR',
                requiredRunRate.toStringAsFixed(2),
                AppColors.warning,
              ),
            ),
        ],
      ),
    );
  }

  Widget _contextItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.muted,
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
