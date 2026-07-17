import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class CoachInsightWidget extends StatelessWidget {
  final List<String> insights;

  CoachInsightWidget({super.key, required this.insights});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(20)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        border: Border.all(color: AppColors.outlineVariant, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline, color: AppColors.muted, size: 20),
              SizedBox(width: 8),
              Text(
                'Coach Insights',
                style: AppTypography.headlineSm.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 16),
          ...insights.map((insight) => Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• ', style: TextStyle(color: AppColors.accent, fontSize: ResponsiveHelper.sp(16), fontWeight: FontWeight.bold)),
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
