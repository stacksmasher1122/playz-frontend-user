import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class GoalsMissionsLevelCard extends StatelessWidget {
  final int level;
  final String levelTitle;
  final int currentXp;
  final int maxXp;

  const GoalsMissionsLevelCard({
    super.key,
    required this.level,
    required this.levelTitle,
    required this.currentXp,
    required this.maxXp,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final progress = (currentXp / maxXp).clamp(0.0, 1.0);
    final badgeSize = context.minDimensionPct(13).clamp(48.0, 58.0);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
      padding: EdgeInsets.all(context.widthPct(4)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(context.minDimensionPct(5)),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Row(
        children: [
          // Level Badge Icon Box
          Container(
            width: badgeSize,
            height: badgeSize,
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
              border: Border.all(color: AppColors.accent.withValues(alpha: 0.4)),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'LVL',
                    style: AppTypography.labelCaps10.copyWith(
                      color: AppColors.muted,
                      fontSize: context.responsiveFont(9),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$level',
                    style: AppTypography.headlineSm.copyWith(
                      color: AppColors.accent,
                      fontSize: context.responsiveFont(18),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: context.widthPct(3.5)),

          // Level Title & XP Bar
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        levelTitle,
                        style: AppTypography.headlineSm.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: context.responsiveFont(15),
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: context.widthPct(2)),
                    Text(
                      '$currentXp / $maxXp XP',
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.accent,
                        fontSize: context.responsiveFont(11),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.heightPct(1)),
                ClipRRect(
                  borderRadius: BorderRadius.circular(context.minDimensionPct(2)),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppColors.surfaceElevated,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
                    minHeight: 7,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
