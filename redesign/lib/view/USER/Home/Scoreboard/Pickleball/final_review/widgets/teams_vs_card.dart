import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Pickleball/pickleball_review_model.dart';
import 'package:redesign/theme/responsive_helper.dart';

class TeamsVsCard extends StatelessWidget {
  final PickleballReviewModel reviewData;
  final VoidCallback onEditTeams;

  TeamsVsCard({
    super.key,
    required this.reviewData,
    required this.onEditTeams,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return RepaintBoundary(
      child: Container(
        padding: EdgeInsets.all(ResponsiveHelper.w(20)),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
          border: Border.all(color: AppColors.outlineVariant, width: 1),
        ),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTeamColumn(
                      teamLabel: 'TEAM A',
                      teamName: reviewData.teamAName,
                      icon: Icons.groups,
                      onTap: onEditTeams,
                    ),
                    _buildTeamColumn(
                      teamLabel: 'TEAM B',
                      teamName: reviewData.teamBName,
                      icon: Icons.group_add,
                      onTap: onEditTeams,
                    ),
                  ],
                ),
                Container(
                  width: ResponsiveHelper.w(32),
                  height: ResponsiveHelper.h(32),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      'vs',
                      style: AppTypography.labelCaps.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            Divider(color: AppColors.outlineVariant, height: 1),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_on_outlined, color: AppColors.muted, size: 16),
                SizedBox(width: 6),
                Text(
                  '${reviewData.courtName} • ${reviewData.matchTime}'.toUpperCase(),
                  style: AppTypography.labelCaps.copyWith(color: AppColors.muted, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamColumn({
    required String teamLabel,
    required String teamName,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: ResponsiveHelper.w(56),
            height: ResponsiveHelper.h(56),
            decoration: BoxDecoration(
              color: AppColors.outlineVariant,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.muted, size: 28),
          ),
          SizedBox(height: 12),
          Text(teamLabel, style: AppTypography.labelCaps10.copyWith(color: AppColors.muted)),
          SizedBox(height: 4),
          Text(teamName, style: AppTypography.headlineMd.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
