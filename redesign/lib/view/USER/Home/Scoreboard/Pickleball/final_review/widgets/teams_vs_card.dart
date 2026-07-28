import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Pickleball/pickleball_review_model.dart';
import 'package:redesign/theme/responsive_helper.dart';

class TeamsVsCard extends StatelessWidget {
  final PickleballReviewModel reviewData;
  final VoidCallback onEditTeams;

  TeamsVsCard({super.key, required this.reviewData, required this.onEditTeams});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return RepaintBoundary(
      child: Container(
        padding: EdgeInsets.all(ResponsiveHelper.w(20)),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.card.withOpacity(0.8),
              Colors.black,
            ],
          ),
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
          border: Border.all(color: AppColors.accent.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withOpacity(0.05),
              blurRadius: 20,
              spreadRadius: 1,
            )
          ],
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
                      imageUrl: reviewData.teamAImage,
                      onTap: onEditTeams,
                    ),
                    _buildTeamColumn(
                      teamLabel: 'TEAM B',
                      teamName: reviewData.teamBName,
                      imageUrl: reviewData.teamBImage,
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
                      style: AppTypography.labelCaps.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
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
    required String imageUrl,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: ResponsiveHelper.w(80),
            height: ResponsiveHelper.h(80),
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.accent.withOpacity(0.5),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withOpacity(0.2),
                  blurRadius: 15,
                  spreadRadius: 2,
                )
              ],
            ),
            child: ClipOval(
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Icon(Icons.person, color: AppColors.muted, size: 40),
                    )
                  : Icon(Icons.person, color: AppColors.muted, size: 40),
            ),
          ),SizedBox(height: 12),
          Text(
            teamLabel,
            style: AppTypography.labelCaps10.copyWith(color: AppColors.muted),
          ),
          SizedBox(height: 4),
          Text(
            teamName,
            style: AppTypography.headlineMd.copyWith(
              color: AppColors.accent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
