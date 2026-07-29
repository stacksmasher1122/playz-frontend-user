import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class CompetitivenessCard extends StatelessWidget {
  final int score;

  const CompetitivenessCard({
    super.key,
    this.score = 94,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Container(
      padding: EdgeInsets.all(context.widthPct(4.5)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(context.minDimensionPct(4.5)),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Row(
        children: [
          SizedBox(
            width: context.widthPct(16),
            height: context.widthPct(16),
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: score / 100.0,
                  strokeWidth: 5,
                  backgroundColor: AppColors.textPrimary.withValues(alpha: 0.12),
                  color: AppColors.accent,
                ),
                Text(
                  "$score%",
                  style: AppTypography.headlineSm.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: context.responsiveFont(15),
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: context.widthPct(4)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Match Competitiveness",
                  style: AppTypography.headlineSm.copyWith(
                    fontSize: context.responsiveFont(15),
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: context.heightPct(0.5)),
                Text(
                  "Fairly balanced skill matchmaking based on player XP history",
                  style: AppTypography.bodySm.copyWith(
                    fontSize: context.responsiveFont(12),
                    color: AppColors.muted,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
