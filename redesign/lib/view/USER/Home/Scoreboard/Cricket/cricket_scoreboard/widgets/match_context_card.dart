import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MatchContextCard extends StatelessWidget {
  final double winProbability;
  final int partnershipRuns;
  final int partnershipBalls;
  final double currentRunRate;
  final double requiredRunRate;
  final int inningsNumber;

  const MatchContextCard({
    super.key,
    required this.winProbability,
    required this.partnershipRuns,
    required this.partnershipBalls,
    required this.currentRunRate,
    required this.requiredRunRate,
    required this.inningsNumber,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final isSecondInnings = inningsNumber == 2;
    final rateLabel = isSecondInnings ? 'RRR' : 'CRR';
    final rateValue = isSecondInnings
        ? requiredRunRate.toStringAsFixed(2)
        : currentRunRate.toStringAsFixed(2);
    final rateColor = isSecondInnings ? AppColors.warning : AppColors.accent;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.w(16),
        vertical: ResponsiveHelper.h(6),
      ),
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(18)),
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
              AppColors.textPrimary,
            ),
          ),
          Expanded(
            child: _contextItem(
              rateLabel,
              rateValue,
              rateColor,
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
          style: TextStyle(
            color: AppColors.muted,
            fontSize: ResponsiveHelper.sp(10),
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: ResponsiveHelper.h(8)),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: ResponsiveHelper.sp(16),
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
