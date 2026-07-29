import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/model/User_Models/More_Models/goals_missions_model.dart';

class AchievementsGridSection extends StatelessWidget {
  final List<AchievementModel> achievements;
  final Function(AchievementModel) onAchievementTap;

  const AchievementsGridSection({
    super.key,
    required this.achievements,
    required this.onAchievementTap,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Text(
            'Achievements',
            style: AppTypography.headlineSm.copyWith(
              color: AppColors.textPrimary,
              fontSize: context.responsiveFont(18),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: context.heightPct(1.5)),

          // 2-Column Grid
          GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: achievements.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: context.heightPct(1.5),
              crossAxisSpacing: context.widthPct(3.5),
              childAspectRatio: 1.15,
            ),
            itemBuilder: (context, index) {
              final a = achievements[index];
              final isUnlocked = a.isUnlocked;

              return InkWell(
                onTap: () => onAchievementTap(a),
                borderRadius: BorderRadius.circular(context.minDimensionPct(5)),
                child: Container(
                  padding: EdgeInsets.all(context.widthPct(3.5)),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(context.minDimensionPct(5)),
                    border: Border.all(
                      color: isUnlocked ? AppColors.accent : AppColors.borderDark,
                      width: isUnlocked ? 1.5 : 1.0,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        a.icon,
                        color: isUnlocked ? AppColors.accent : AppColors.muted,
                        size: 32,
                      ),
                      SizedBox(height: context.heightPct(1)),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          a.title,
                          style: AppTypography.headlineSm.copyWith(
                            color: AppColors.textPrimary,
                            fontSize: context.responsiveFont(14),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: context.heightPct(0.3)),
                      Text(
                        isUnlocked ? 'Unlocked' : 'Locked',
                        style: AppTypography.bodySm.copyWith(
                          color: isUnlocked ? AppColors.accent : AppColors.muted,
                          fontSize: context.responsiveFont(11),
                          fontWeight: isUnlocked ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
