import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class TeamScoreCard extends StatelessWidget {
  final String teamName;
  final int setsWon;
  final int score;
  final bool isServing;

  TeamScoreCard({
    super.key,
    required this.teamName,
    required this.setsWon,
    required this.score,
    required this.isServing,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Stack(
        children: [
          if (isServing)
            Positioned(
              left: ResponsiveHelper.w(0),
              top: ResponsiveHelper.h(0),
              bottom: ResponsiveHelper.h(0),
              child: Container(
                width: ResponsiveHelper.w(4),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(ResponsiveHelper.w(16)), bottomLeft: Radius.circular(ResponsiveHelper.w(16))),
                  boxShadow: [
                    BoxShadow(color: AppColors.accent, blurRadius: 8, spreadRadius: 2),
                  ],
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.all(ResponsiveHelper.w(24.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        teamName.toUpperCase(),
                        style: AppTypography.headlineSm.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(ResponsiveHelper.w(8)),
                      decoration: BoxDecoration(
                        color: AppColors.outlineVariant,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        setsWon.toString(),
                        style: AppTypography.headlineMd.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    score.toString(),
                    style: TextStyle(fontSize: ResponsiveHelper.sp(120), fontWeight: FontWeight.w900, color: AppColors.accent, height: 1),
                  ),
                ),
                SizedBox(height: 24),
                // Mock Rally indicators (Win, Loss, Win)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildRallyIndicator(true),
                    SizedBox(width: 8),
                    _buildRallyIndicator(false),
                    SizedBox(width: 8),
                    _buildRallyIndicator(true),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRallyIndicator(bool won) {
    return Container(
      width: ResponsiveHelper.w(32),
      height: ResponsiveHelper.h(4),
      decoration: BoxDecoration(
        color: won ? AppColors.accent : AppColors.outlineVariant,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(2)),
      ),
    );
  }
}
