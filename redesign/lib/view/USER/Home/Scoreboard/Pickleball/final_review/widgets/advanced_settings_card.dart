import 'package:flutter/material.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Pickleball/pickleball_review_model.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'advanced_setting_tile.dart';
import 'package:redesign/theme/responsive_helper.dart';

class AdvancedSettingsCard extends StatelessWidget {
  final PickleballReviewModel reviewData;

  AdvancedSettingsCard({
    super.key,
    required this.reviewData,
  });

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
          Text(
            'ADVANCED SETTINGS',
            style: AppTypography.labelCaps10.copyWith(color: AppColors.muted),
          ),
          SizedBox(height: 8),
          AdvancedSettingTile(
            icon: Icons.timer_outlined,
            label: 'Time Limit',
            value: reviewData.timeLimit,
          ),
          Divider(color: AppColors.outlineVariant, height: 1),
          AdvancedSettingTile(
            icon: Icons.swap_horiz,
            label: 'Switch Sides',
            value: reviewData.switchSides,
          ),
          Divider(color: AppColors.outlineVariant, height: 1),
          AdvancedSettingTile(
            icon: Icons.replay,
            label: 'Record Replays',
            value: reviewData.recordReplays ? 'ON' : 'OFF',
            valueIsHighlighted: reviewData.recordReplays,
          ),
        ],
      ),
    );
  }
}
