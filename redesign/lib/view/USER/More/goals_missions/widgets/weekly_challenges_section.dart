import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/model/User_Models/More_Models/goals_missions_model.dart';

class WeeklyChallengesSection extends StatelessWidget {
  final List<WeeklyChallengeModel> challenges;

  const WeeklyChallengesSection({
    super.key,
    required this.challenges,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final iconBoxSize = context.minDimensionPct(11).clamp(40.0, 48.0);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Text(
            'Weekly Challenges',
            style: AppTypography.headlineSm.copyWith(
              color: AppColors.textPrimary,
              fontSize: context.responsiveFont(18),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: context.heightPct(1.5)),

          ...challenges.map((c) {
            final progressFraction = (c.currentProgress / c.totalTarget).clamp(0.0, 1.0);

            return Container(
              margin: EdgeInsets.only(bottom: context.heightPct(1.5)),
              padding: EdgeInsets.all(context.widthPct(4)),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(context.minDimensionPct(5)),
                border: Border.all(color: AppColors.borderDark),
              ),
              child: Row(
                children: [
                  // Circular Icon Box
                  Container(
                    width: iconBoxSize,
                    height: iconBoxSize,
                    decoration: const BoxDecoration(
                      color: AppColors.surface,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(c.icon, color: AppColors.accent, size: 22),
                  ),
                  SizedBox(width: context.widthPct(3.5)),

                  // Title & Progress Bar
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                c.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.headlineSm.copyWith(
                                  color: AppColors.textPrimary,
                                  fontSize: context.responsiveFont(15),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(width: context.widthPct(2)),
                            Text(
                              '+${c.zCoinsReward} Z',
                              style: AppTypography.headlineSm.copyWith(
                                color: AppColors.accent,
                                fontSize: context.responsiveFont(13),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: context.heightPct(1)),
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(context.minDimensionPct(1)),
                                child: LinearProgressIndicator(
                                  value: progressFraction,
                                  backgroundColor: AppColors.surfaceElevated,
                                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
                                  minHeight: 5,
                                ),
                              ),
                            ),
                            SizedBox(width: context.widthPct(2.5)),
                            Text(
                              '${c.currentProgress}/${c.totalTarget}',
                              style: AppTypography.bodySm.copyWith(
                                color: AppColors.muted,
                                fontSize: context.responsiveFont(11),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
