import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Volleyball/volleyball_controller.dart';

class VolleyballScoreDisplay extends StatelessWidget {
  const VolleyballScoreDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<VolleyballController>();

    return Obx(() {
      final state = controller.liveState.value;
      if (state == null) return const SizedBox.shrink();

      final homeName = controller.currentMatch.value?.homeTeam ?? 'Side A';
      final awayName = controller.currentMatch.value?.awayTeam ?? 'Side B';
      final isServingA = state.servingTeam == 'sideA';

      return Container(
        margin: EdgeInsets.all(ResponsiveHelper.w(16)),
        padding: EdgeInsets.all(ResponsiveHelper.w(16)),
        decoration: BoxDecoration(
          color: AppColors.cardSurface,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          boxShadow: [
            BoxShadow(
              color: AppColors.background.withValues(alpha: 0.5),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Set Pill & Sets Won Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Set Badge
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.w(12),
                    vertical: ResponsiveHelper.h(5),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.accent.withValues(alpha: 0.4)),
                  ),
                  child: Text(
                    'SET ${state.currentSetNumber} / ${state.config.maxSets}',
                    style: AppTypography.labelCaps.copyWith(
                      color: AppColors.accent,
                      fontSize: ResponsiveHelper.sp(12),
                      fontWeight: FontWeight.bold,
                    ).responsive(context),
                  ),
                ),

                // Sets Won Summary Pill
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.w(14),
                    vertical: ResponsiveHelper.h(5),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Text(
                    'SETS: ${state.setsWonA} - ${state.setsWonB}',
                    style: AppTypography.monoMd.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: ResponsiveHelper.sp(13),
                      fontWeight: FontWeight.w900,
                    ).responsive(context),
                  ),
                ),
              ],
            ),

            SizedBox(height: ResponsiveHelper.h(12)),

            // Serving Team Indicator Pill
            GestureDetector(
              onTap: () => controller.toggleServingTeam(),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.w(14),
                  vertical: ResponsiveHelper.h(5),
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2620),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.sports_volleyball, color: AppColors.accent, size: 16),
                    SizedBox(width: ResponsiveHelper.w(6)),
                    Text(
                      'SERVING: ${isServingA ? homeName.toUpperCase() : awayName.toUpperCase()}',
                      style: AppTypography.labelCaps.copyWith(
                        color: AppColors.accent,
                        fontSize: ResponsiveHelper.sp(11),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ).responsive(context),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: ResponsiveHelper.h(16)),

            // Scores Row
            Row(
              children: [
                // Team A Score
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        homeName,
                        textAlign: TextAlign.center,
                        style: AppTypography.headlineSm.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: ResponsiveHelper.sp(14),
                          fontWeight: FontWeight.bold,
                        ).responsive(context),
                      ),
                      SizedBox(height: ResponsiveHelper.h(6)),
                      Text(
                        '${state.currentSetPointsA}',
                        style: AppTypography.displayScoreSora.copyWith(
                          color: AppColors.accent,
                          fontSize: ResponsiveHelper.sp(48),
                          fontWeight: FontWeight.w800,
                        ).responsive(context),
                      ),
                    ],
                  ),
                ),

                // VS Divider
                Container(
                  padding: EdgeInsets.all(ResponsiveHelper.w(8)),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    'VS',
                    style: AppTypography.labelCaps.copyWith(
                      color: AppColors.mutedText,
                      fontSize: ResponsiveHelper.sp(12),
                      fontWeight: FontWeight.w900,
                    ).responsive(context),
                  ),
                ),

                // Team B Score
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        awayName,
                        textAlign: TextAlign.center,
                        style: AppTypography.headlineSm.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: ResponsiveHelper.sp(14),
                          fontWeight: FontWeight.bold,
                        ).responsive(context),
                      ),
                      SizedBox(height: ResponsiveHelper.h(6)),
                      Text(
                        '${state.currentSetPointsB}',
                        style: AppTypography.displayScoreSora.copyWith(
                          color: const Color(0xFF4D96FF),
                          fontSize: ResponsiveHelper.sp(48),
                          fontWeight: FontWeight.w800,
                        ).responsive(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Previous Sets Scores Summary
            if (state.setHistory.isNotEmpty) ...[
              SizedBox(height: ResponsiveHelper.h(14)),
              Wrap(
                spacing: 8,
                children: state.setHistory.map((s) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF262626),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'S${s.setNumber}: ${s.sideAScore}-${s.sideBScore}',
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.mutedText,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ).responsive(context),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      );
    });
  }
}
