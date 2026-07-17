import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/volleyball_review_model.dart';
import 'package:redesign/theme/responsive_helper.dart';

class OfficialCard extends StatelessWidget {
  final VolleyballReviewModel reviewData;

  OfficialCard({super.key, required this.reviewData});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(20)),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(ResponsiveHelper.w(12)),
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
            ),
            child: Icon(Icons.person_outline, color: AppColors.background),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Referee Team', style: AppTypography.headlineSm.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text(
                  '${reviewData.config.referee} • ${reviewData.config.assistantReferee}',
                  style: AppTypography.bodyMd.copyWith(color: AppColors.muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
