import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';

class CoachInsightWidget extends StatelessWidget {
  final List<String> insights;

  const CoachInsightWidget({super.key, required this.insights});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceContainerHighest, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lightbulb_outline, color: AppColors.muted, size: 20),
              const SizedBox(width: 8),
              Text(
                'Coach Insights',
                style: AppTypography.headlineSm.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...insights.map((insight) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(color: AppColors.primaryContainer, fontSize: 16, fontWeight: FontWeight.bold)),
                Expanded(
                  child: Text(insight, style: AppTypography.bodySm.copyWith(color: AppColors.muted, height: 1.4)),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
