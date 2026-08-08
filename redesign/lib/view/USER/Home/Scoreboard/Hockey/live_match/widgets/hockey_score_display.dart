import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Hockey/hockey_controller.dart';

/// Pixel-perfect Hockey Score Display Card matching the attached reference screenshot.
class HockeyScoreDisplay extends StatelessWidget {
  const HockeyScoreDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<HockeyController>();

    return Obx(() {
      final state = controller.liveState.value;
      if (state == null) return const SizedBox.shrink();

      final homeName = controller.currentMatch.value?.homeTeam.isNotEmpty == true
          ? controller.currentMatch.value!.homeTeam
          : 'SIDE A';
      final awayName = controller.currentMatch.value?.awayTeam.isNotEmpty == true
          ? controller.currentMatch.value!.awayTeam
          : 'SIDE B';

      const Color greenColor = Color(0xFF00E676);
      const Color blueColor = Color(0xFF448AFF);
      const Color cardBgColor = Color(0xFF10141E);
      const Color borderDividerColor = Color(0xFF1A2334);

      return Container(
        margin: EdgeInsets.all(ResponsiveHelper.w(16.0)),
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.w(20.0),
          vertical: ResponsiveHelper.h(18.0),
        ),
        decoration: BoxDecoration(
          color: cardBgColor,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(20.0)),
          border: Border.all(color: greenColor.withValues(alpha: 0.6), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ─── 1. TOP BADGES ROW (Q1 / 4 & PC: 0 - 0) ───
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Period Badge (Q1 / 4)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.w(16.0),
                    vertical: ResponsiveHelper.h(6.0),
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D2418),
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(20.0)),
                    border: Border.all(color: greenColor, width: 1.2),
                  ),
                  child: Text(
                    'Q${state.currentPeriod} / ${state.config.maxPeriods}',
                    style: AppTypography.labelCaps.copyWith(
                      color: greenColor,
                      fontSize: ResponsiveHelper.sp(13.0),
                      fontWeight: FontWeight.w900,
                    ).responsive(context),
                  ),
                ),

                // Penalty Corners Summary Pill (PC: 0 - 0)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.w(16.0),
                    vertical: ResponsiveHelper.h(6.0),
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF131A26),
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(20.0)),
                    border: Border.all(color: const Color(0xFF242D3C), width: 1.2),
                  ),
                  child: Text(
                    'PC: ${state.penaltyCornersA} - ${state.penaltyCornersB}',
                    style: AppTypography.monoMd.copyWith(
                      color: Colors.white,
                      fontSize: ResponsiveHelper.sp(13.0),
                      fontWeight: FontWeight.w900,
                    ).responsive(context),
                  ),
                ),
              ],
            ),

            SizedBox(height: ResponsiveHelper.h(20.0)),

            // ─── 2. MAIN SCORE DISPLAY ROW ───
            Row(
              children: [
                // SIDE A SCORE
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        homeName.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: AppTypography.headlineSm.copyWith(
                          color: Colors.white,
                          fontSize: ResponsiveHelper.sp(14.0),
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.8,
                        ).responsive(context),
                      ),
                      SizedBox(height: ResponsiveHelper.h(8.0)),
                      Text(
                        '${state.goalsA}',
                        style: AppTypography.displayScoreSora.copyWith(
                          color: greenColor,
                          fontSize: ResponsiveHelper.sp(68.0),
                          fontWeight: FontWeight.w900,
                        ).responsive(context),
                      ),
                    ],
                  ),
                ),

                // CENTER VS DIVIDER
                SizedBox(
                  height: ResponsiveHelper.h(80.0),
                  child: Row(
                    children: [
                      Container(
                        width: 1.0,
                        height: ResponsiveHelper.h(60.0),
                        color: borderDividerColor,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(10.0)),
                        padding: EdgeInsets.all(ResponsiveHelper.w(10.0)),
                        decoration: const BoxDecoration(
                          color: Color(0xFF1E2638),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          'VS',
                          style: AppTypography.labelCaps.copyWith(
                            color: const Color(0xFF7E8B9B),
                            fontSize: ResponsiveHelper.sp(12.0),
                            fontWeight: FontWeight.w900,
                          ).responsive(context),
                        ),
                      ),
                      Container(
                        width: 1.0,
                        height: ResponsiveHelper.h(60.0),
                        color: borderDividerColor,
                      ),
                    ],
                  ),
                ),

                // SIDE B SCORE
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        awayName.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: AppTypography.headlineSm.copyWith(
                          color: Colors.white,
                          fontSize: ResponsiveHelper.sp(14.0),
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.8,
                        ).responsive(context),
                      ),
                      SizedBox(height: ResponsiveHelper.h(8.0)),
                      Text(
                        '${state.goalsB}',
                        style: AppTypography.displayScoreSora.copyWith(
                          color: blueColor,
                          fontSize: ResponsiveHelper.sp(68.0),
                          fontWeight: FontWeight.w900,
                        ).responsive(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: ResponsiveHelper.h(16.0)),

            // HORIZONTAL DIVIDER LINE
            Container(
              width: double.infinity,
              height: 1.0,
              color: borderDividerColor,
            ),

            SizedBox(height: ResponsiveHelper.h(14.0)),

            // ─── 4. TIMER ROW INSIDE CARD ───
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.timer_outlined,
                  color: greenColor,
                  size: ResponsiveHelper.w(20.0),
                ),
                SizedBox(width: ResponsiveHelper.w(8.0)),
                Text(
                  '00:00',
                  style: AppTypography.monoMd.copyWith(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.sp(16.0),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ).responsive(context),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
