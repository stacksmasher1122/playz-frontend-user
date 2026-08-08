import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Kho_Kho/khokho_controller.dart';

/// App-themed Kho Kho Score Display Card with per-person points summary and responsive layout.
class KhoKhoScoreDisplay extends StatelessWidget {
  const KhoKhoScoreDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<KhoKhoController>();

    return Obx(() {
      final state = controller.liveState.value;
      if (state == null) return const SizedBox.shrink();

      final homeName = controller.currentMatch.value?.homeTeam.isNotEmpty == true
          ? controller.currentMatch.value!.homeTeam
          : 'SIDE A';
      final awayName = controller.currentMatch.value?.awayTeam.isNotEmpty == true
          ? controller.currentMatch.value!.awayTeam
          : 'SIDE B';

      final bool isChasingA = state.activeChasingTeam == 'sideA';
      final activeChasingTeamName = isChasingA ? homeName : awayName;

      final inningNumber = ((state.currentTurn - 1) ~/ 2) + 1;
      final turnInInning = ((state.currentTurn - 1) % 2) + 1;

      const Color greenColor = Color(0xFF00E676);
      const Color blueColor = Color(0xFF448AFF);
      const Color goldColor = Color(0xFFFFC107);
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
          border: Border.all(
            color: (isChasingA ? greenColor : blueColor).withValues(alpha: 0.6),
            width: 1.2,
          ),
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
            // ─── 1. TOP BADGES ROW (INNING/TURN & CHASING TEAM) ───
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Inning / Turn Pill
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.w(14.0),
                    vertical: ResponsiveHelper.h(6.0),
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D2418),
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(20.0)),
                    border: Border.all(color: greenColor, width: 1.2),
                  ),
                  child: Text(
                    'INN $inningNumber • TURN $turnInInning',
                    style: AppTypography.labelCaps.copyWith(
                      color: greenColor,
                      fontSize: ResponsiveHelper.sp(12.0),
                      fontWeight: FontWeight.w900,
                    ).responsive(context),
                  ),
                ),

                // Active Chaser Pill
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.w(14.0),
                    vertical: ResponsiveHelper.h(6.0),
                  ),
                  decoration: BoxDecoration(
                    color: goldColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(20.0)),
                    border: Border.all(color: goldColor, width: 1.2),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.flash_on_rounded,
                        color: goldColor,
                        size: ResponsiveHelper.w(14.0),
                      ),
                      SizedBox(width: ResponsiveHelper.w(4.0)),
                      Text(
                        'CHASING: $activeChasingTeamName',
                        style: AppTypography.bodySm.copyWith(
                          color: goldColor,
                          fontSize: ResponsiveHelper.sp(11.5),
                          fontWeight: FontWeight.w900,
                        ).responsive(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: ResponsiveHelper.h(20.0)),

            // ─── 2. MAIN POINTS DISPLAY ROW ───
            Row(
              children: [
                // SIDE A POINTS
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
                      SizedBox(height: ResponsiveHelper.h(6.0)),
                      Text(
                        '${state.pointsA}',
                        style: AppTypography.displayScoreSora.copyWith(
                          color: greenColor,
                          fontSize: ResponsiveHelper.sp(64.0),
                          fontWeight: FontWeight.w900,
                        ).responsive(context),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveHelper.w(8.0),
                          vertical: ResponsiveHelper.h(2.0),
                        ),
                        decoration: BoxDecoration(
                          color: (isChasingA ? goldColor : Colors.white10).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        child: Text(
                          isChasingA ? '⚡ CHASING' : '🛡 DEFENDING',
                          style: AppTypography.labelCaps.copyWith(
                            color: isChasingA ? goldColor : AppColors.mutedText,
                            fontSize: ResponsiveHelper.sp(10.0),
                            fontWeight: FontWeight.w900,
                          ).responsive(context),
                        ),
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

                // SIDE B POINTS
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
                      SizedBox(height: ResponsiveHelper.h(6.0)),
                      Text(
                        '${state.pointsB}',
                        style: AppTypography.displayScoreSora.copyWith(
                          color: blueColor,
                          fontSize: ResponsiveHelper.sp(64.0),
                          fontWeight: FontWeight.w900,
                        ).responsive(context),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveHelper.w(8.0),
                          vertical: ResponsiveHelper.h(2.0),
                        ),
                        decoration: BoxDecoration(
                          color: (!isChasingA ? goldColor : Colors.white10).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        child: Text(
                          !isChasingA ? '⚡ CHASING' : '🛡 DEFENDING',
                          style: AppTypography.labelCaps.copyWith(
                            color: !isChasingA ? goldColor : AppColors.mutedText,
                            fontSize: ResponsiveHelper.sp(10.0),
                            fontWeight: FontWeight.w900,
                          ).responsive(context),
                        ),
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
