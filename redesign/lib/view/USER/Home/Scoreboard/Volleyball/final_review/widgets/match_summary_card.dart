import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/volleyball_review_model.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MatchSummaryCard extends StatelessWidget {
  final VolleyballReviewModel reviewData;

  MatchSummaryCard({super.key, required this.reviewData});

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                reviewData.config.matchName.toUpperCase(),
                style: AppTypography.labelCaps10.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold, letterSpacing: 1.5),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(8), vertical: ResponsiveHelper.h(4)),
                decoration: BoxDecoration(
                  color: AppColors.outlineVariant,
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(4)),
                ),
                child: Text('LIVE RECOGNITION', style: AppTypography.labelCaps10.copyWith(color: AppColors.muted)),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            '${reviewData.teamA.teamName} vs.\n${reviewData.teamB.teamName}',
            style: AppTypography.headlineMd.copyWith(color: AppColors.accent, fontWeight: FontWeight.w900, height: 1.2),
          ),
          SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildIconInfo(Icons.stadium_outlined, 'VENUE', '${reviewData.config.venue}\n${reviewData.config.court}'),
              ),
              Expanded(
                child: _buildIconInfo(Icons.calendar_today_outlined, 'DATE & TIME', '${reviewData.config.date} •\n${reviewData.config.time}'),
              ),
            ],
          ),
          SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _buildTeamPreview(reviewData.teamA.teamName, reviewData.teamA.primaryColor)),
              SizedBox(width: 12),
              Expanded(child: _buildTeamPreview(reviewData.teamB.teamName, reviewData.teamB.primaryColor)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconInfo(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.muted, size: 24),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTypography.labelCaps10.copyWith(color: AppColors.muted, letterSpacing: 1.2)),
              SizedBox(height: 4),
              Text(value, style: AppTypography.bodyMd.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTeamPreview(String name, Color color) {
    return Container(
      height: ResponsiveHelper.h(80),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -20,
            right: -20,
            child: Icon(Icons.shield, size: 100, color: color.withOpacity(0.1)),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: EdgeInsets.all(ResponsiveHelper.w(8.0)),
              child: Text(
                name.toUpperCase(),
                style: AppTypography.labelCaps10.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
