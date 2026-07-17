import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/volleyball_review_model.dart';
import 'review_info_tile.dart';
import 'package:redesign/theme/responsive_helper.dart';

class RegulationSummaryCard extends StatelessWidget {
  final VolleyballReviewModel reviewData;

  RegulationSummaryCard({super.key, required this.reviewData});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: ResponsiveHelper.w(4),
            height: ResponsiveHelper.h(180),
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(ResponsiveHelper.w(16)), bottomLeft: Radius.circular(ResponsiveHelper.w(16))),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(ResponsiveHelper.w(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.gavel, color: AppColors.accent, size: 16),
                      SizedBox(width: 8),
                      Text('REGULATION SETTINGS', style: AppTypography.labelCaps10.copyWith(color: AppColors.muted, letterSpacing: 1.5)),
                    ],
                  ),
                  SizedBox(height: 12),
                  ReviewInfoTile(label: 'Best of', value: '${reviewData.config.format.split(" ").last} Sets'),
                  ReviewInfoTile(label: 'Set Points', value: '${reviewData.config.pointsPerSet}'),
                  ReviewInfoTile(label: 'Tie-break', value: '${reviewData.config.finalSetPoints}'),
                  ReviewInfoTile(label: 'Subs / Set', value: '${reviewData.config.substitutions}', isLast: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
