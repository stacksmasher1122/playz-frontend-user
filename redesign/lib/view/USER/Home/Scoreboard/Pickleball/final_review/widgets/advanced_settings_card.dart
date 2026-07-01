import 'package:flutter/material.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Pickleball/pickleball_review_model.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'advanced_setting_tile.dart';

class AdvancedSettingsCard extends StatelessWidget {
  final PickleballReviewModel reviewData;

  const AdvancedSettingsCard({
    super.key,
    required this.reviewData,
  });

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
          Text(
            'ADVANCED SETTINGS',
            style: AppTypography.labelCaps10.copyWith(color: AppColors.muted),
          ),
          const SizedBox(height: 8),
          AdvancedSettingTile(
            icon: Icons.timer_outlined,
            label: 'Time Limit',
            value: reviewData.timeLimit,
          ),
          const Divider(color: AppColors.surfaceContainerHighest, height: 1),
          AdvancedSettingTile(
            icon: Icons.swap_horiz,
            label: 'Switch Sides',
            value: reviewData.switchSides,
          ),
          const Divider(color: AppColors.surfaceContainerHighest, height: 1),
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
