import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Pickleball/pickleball_review_model.dart';

class TeamsVsCard extends StatelessWidget {
  final PickleballReviewModel reviewData;
  final VoidCallback onEditTeams;

  const TeamsVsCard({
    super.key,
    required this.reviewData,
    required this.onEditTeams,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.surfaceContainerHighest, width: 1),
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
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryContainer,
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
            const SizedBox(height: 24),
            const Divider(color: AppColors.surfaceContainerHighest, height: 1),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on_outlined, color: AppColors.muted, size: 16),
                const SizedBox(width: 6),
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
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: AppColors.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.muted, size: 28),
          ),
          const SizedBox(height: 12),
          Text(teamLabel, style: AppTypography.labelCaps10.copyWith(color: AppColors.muted)),
          const SizedBox(height: 4),
          Text(teamName, style: AppTypography.headlineMd.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
