import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/model/User_Models/More_Models/goals_missions_model.dart';

class DailyMissionsSection extends StatelessWidget {
  final List<DailyMissionModel> missions;
  final String resetCountdown;
  final Function(DailyMissionModel) onClaim;

  const DailyMissionsSection({
    super.key,
    required this.missions,
    required this.resetCountdown,
    required this.onClaim,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final cardWidth = context.widthPct(65).clamp(240.0, 300.0);
    final carouselHeight = context.heightPct(20).clamp(150.0, 180.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Daily Missions',
                style: AppTypography.headlineSm.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: context.responsiveFont(18),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.timer_outlined, color: AppColors.muted, size: 13),
                  SizedBox(width: context.widthPct(1)),
                  Text(
                    'Resets in $resetCountdown',
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
        SizedBox(height: context.heightPct(1.5)),

        // Horizontal Carousel
        SizedBox(
          height: carouselHeight,
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: missions.length,
            itemBuilder: (context, index) {
              final m = missions[index];
              final isCompleted = m.isCompleted;
              final progressFraction = (m.currentProgress / m.totalTarget).clamp(0.0, 1.0);

              return Container(
                width: cardWidth,
                margin: EdgeInsets.only(right: context.widthPct(3.5)),
                padding: EdgeInsets.all(context.widthPct(4)),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(context.minDimensionPct(5)),
                  border: Border.all(
                    color: isCompleted ? AppColors.accent.withValues(alpha: 0.6) : AppColors.borderDark,
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top Row: Reward Tag + Icon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.widthPct(2.5),
                            vertical: context.heightPct(0.5),
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(context.minDimensionPct(5)),
                            border: Border.all(color: AppColors.accent.withValues(alpha: 0.4)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.stars, color: AppColors.accent, size: 12),
                              SizedBox(width: context.widthPct(1)),
                              Text(
                                '+${m.zCoinsReward} Z Coins',
                                style: AppTypography.labelCaps10.copyWith(
                                  color: AppColors.accent,
                                  fontSize: context.responsiveFont(11),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(m.icon, color: AppColors.muted, size: 20),
                      ],
                    ),

                    // Title
                    Text(
                      m.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.headlineSm.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: context.responsiveFont(16),
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // Progress Section
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Progress',
                              style: AppTypography.bodySm.copyWith(
                                color: AppColors.muted,
                                fontSize: context.responsiveFont(11),
                              ),
                            ),
                            Text(
                              '${m.currentProgress}/${m.totalTarget}',
                              style: AppTypography.bodySm.copyWith(
                                color: AppColors.textPrimary,
                                fontSize: context.responsiveFont(12),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: context.heightPct(0.8)),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(context.minDimensionPct(1)),
                          child: LinearProgressIndicator(
                            value: progressFraction,
                            backgroundColor: AppColors.surfaceElevated,
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
