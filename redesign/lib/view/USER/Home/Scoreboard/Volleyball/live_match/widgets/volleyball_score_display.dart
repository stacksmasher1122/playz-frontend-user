import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Volleyball/volleyball_controller.dart';

/// Pixel-perfect Volleyball Score Display matching screenshot UI & FIVB rules.
class VolleyballScoreDisplay extends StatelessWidget {
  const VolleyballScoreDisplay({super.key});

  String _formatScore(int score) => score.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<VolleyballController>();

    return Obx(() {
      final state = controller.liveState.value;
      if (state == null) return const SizedBox.shrink();

      final homeName = controller.currentMatch.value?.homeTeam.isNotEmpty == true
          ? controller.currentMatch.value!.homeTeam
          : 'Side A';
      final awayName = controller.currentMatch.value?.awayTeam.isNotEmpty == true
          ? controller.currentMatch.value!.awayTeam
          : 'Side B';
      final isServingA = state.servingTeam == 'sideA';
      final currentSet = state.currentSetNumber;
      final maxSets = state.config.maxSets;
      final targetPts = state.currentTargetPoints;

      const Color greenColor = Color(0xFF00E676);
      const Color blueColor = Color(0xFF448AFF);
      const Color cardBgColor = Color(0xFF121724);
      const Color cardBorderColor = Color(0xFF1F293D);

      return Container(
        margin: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.w(16.0),
          vertical: ResponsiveHelper.h(6.0),
        ),
        child: Column(
          children: [
            // ─── 1. TOP STATUS BADGES ROW (SET BADGE & SETS WON SUMMARY) ───
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Set Badge Pill (Green border & green text)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.w(16.0),
                    vertical: ResponsiveHelper.h(8.0),
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A1D13),
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(12.0)),
                    border: Border.all(
                      color: greenColor,
                      width: 1.2,
                    ),
                  ),
                  child: Text(
                    'SET $currentSet / $maxSets',
                    style: AppTypography.labelCaps.copyWith(
                      color: greenColor,
                      fontSize: ResponsiveHelper.sp(13.0),
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ).responsive(context),
                  ),
                ),

                // Sets Won Summary Pill
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.w(16.0),
                    vertical: ResponsiveHelper.h(8.0),
                  ),
                  decoration: BoxDecoration(
                    color: cardBgColor,
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(12.0)),
                    border: Border.all(
                      color: cardBorderColor,
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.emoji_events_outlined,
                        color: AppColors.mutedText,
                        size: 16,
                      ),
                      SizedBox(width: ResponsiveHelper.w(6.0)),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'SETS WON  ',
                              style: AppTypography.labelCaps.copyWith(
                                color: AppColors.mutedText,
                                fontSize: ResponsiveHelper.sp(12.0),
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                              ).responsive(context),
                            ),
                            TextSpan(
                              text: '${state.setsWonA}',
                              style: AppTypography.labelCaps.copyWith(
                                color: state.setsWonA > 0 ? greenColor : Colors.white,
                                fontSize: ResponsiveHelper.sp(15.0),
                                fontWeight: FontWeight.w900,
                              ).responsive(context),
                            ),
                            TextSpan(
                              text: ' - ',
                              style: AppTypography.labelCaps.copyWith(
                                color: Colors.white,
                                fontSize: ResponsiveHelper.sp(15.0),
                                fontWeight: FontWeight.w900,
                              ).responsive(context),
                            ),
                            TextSpan(
                              text: '${state.setsWonB}',
                              style: AppTypography.labelCaps.copyWith(
                                color: state.setsWonB > 0 ? blueColor : Colors.white,
                                fontSize: ResponsiveHelper.sp(15.0),
                                fontWeight: FontWeight.w900,
                              ).responsive(context),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: ResponsiveHelper.h(14.0)),

            // ─── 2. FLOATING SERVING TEAM INDICATOR BADGE ───
            GestureDetector(
              onTap: () => controller.toggleServingTeam(),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.w(20.0),
                  vertical: ResponsiveHelper.h(8.0),
                ),
                decoration: BoxDecoration(
                  color: cardBgColor,
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(16.0)),
                  border: Border.all(
                    color: isServingA ? greenColor : blueColor,
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (isServingA ? greenColor : blueColor).withValues(alpha: 0.15),
                      blurRadius: 10.0,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.sports_volleyball,
                      color: isServingA ? greenColor : blueColor,
                      size: ResponsiveHelper.w(18.0),
                    ),
                    SizedBox(width: ResponsiveHelper.w(8.0)),
                    Text(
                      'SERVING: ${(isServingA ? homeName : awayName).toUpperCase()}',
                      style: AppTypography.labelCaps.copyWith(
                        color: isServingA ? greenColor : blueColor,
                        fontSize: ResponsiveHelper.sp(12.0),
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
                      ).responsive(context),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: ResponsiveHelper.h(14.0)),

            // ─── 3. MAIN SCORE DISPLAY CARD ───
            Container(
              decoration: BoxDecoration(
                color: cardBgColor,
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(20.0)),
                border: Border.all(
                  color: cardBorderColor,
                  width: 1.2,
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveHelper.w(16.0),
                      vertical: ResponsiveHelper.h(20.0),
                    ),
                    child: Row(
                      children: [
                        // ─── SIDE A (HOME) SCORE COLUMN ───
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: ResponsiveHelper.w(8.0),
                                    height: ResponsiveHelper.w(8.0),
                                    decoration: const BoxDecoration(
                                      color: greenColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(width: ResponsiveHelper.w(6.0)),
                                  Flexible(
                                    child: Text(
                                      homeName.toUpperCase(),
                                      style: AppTypography.labelCaps.copyWith(
                                        color: greenColor,
                                        fontSize: ResponsiveHelper.sp(13.0),
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 0.8,
                                      ).responsive(context),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: ResponsiveHelper.h(12.0)),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  _formatScore(state.currentSetPointsA),
                                  style: AppTypography.displayScoreSora.copyWith(
                                    color: greenColor,
                                    fontSize: ResponsiveHelper.sp(64.0),
                                    fontWeight: FontWeight.w900,
                                    height: 1.0,
                                  ).responsive(context),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // ─── CENTER DIVIDER & VS BADGE ───
                        SizedBox(
                          height: ResponsiveHelper.h(80.0),
                          child: Row(
                            children: [
                              Container(
                                width: 1,
                                height: double.infinity,
                                color: const Color(0xFF1E2838),
                              ),
                              SizedBox(width: ResponsiveHelper.w(10.0)),
                              Container(
                                width: ResponsiveHelper.w(44.0),
                                height: ResponsiveHelper.w(44.0),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF182030),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFF2B3850),
                                    width: 1.0,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'VS',
                                    style: AppTypography.labelCaps.copyWith(
                                      color: AppColors.mutedText,
                                      fontSize: ResponsiveHelper.sp(12.0),
                                      fontWeight: FontWeight.w900,
                                    ).responsive(context),
                                  ),
                                ),
                              ),
                              SizedBox(width: ResponsiveHelper.w(10.0)),
                              Container(
                                width: 1,
                                height: double.infinity,
                                color: const Color(0xFF1E2838),
                              ),
                            ],
                          ),
                        ),

                        // ─── SIDE B (AWAY) SCORE COLUMN ───
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: ResponsiveHelper.w(8.0),
                                    height: ResponsiveHelper.w(8.0),
                                    decoration: const BoxDecoration(
                                      color: blueColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(width: ResponsiveHelper.w(6.0)),
                                  Flexible(
                                    child: Text(
                                      awayName.toUpperCase(),
                                      style: AppTypography.labelCaps.copyWith(
                                        color: blueColor,
                                        fontSize: ResponsiveHelper.sp(13.0),
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 0.8,
                                      ).responsive(context),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: ResponsiveHelper.h(12.0)),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  _formatScore(state.currentSetPointsB),
                                  style: AppTypography.displayScoreSora.copyWith(
                                    color: blueColor,
                                    fontSize: ResponsiveHelper.sp(64.0),
                                    fontWeight: FontWeight.w900,
                                    height: 1.0,
                                  ).responsive(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Horizontal Divider Line
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: const Color(0xFF1E2838),
                  ),

                  // Bottom Set Target Info Section
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(14.0)),
                    child: Column(
                      children: [
                        Text(
                          'SET TARGET',
                          style: AppTypography.labelCaps.copyWith(
                            color: AppColors.mutedText,
                            fontSize: ResponsiveHelper.sp(11.0),
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.0,
                          ).responsive(context),
                        ),
                        SizedBox(height: ResponsiveHelper.h(4.0)),
                        Text(
                          '$targetPts POINTS',
                          style: AppTypography.headlineSm.copyWith(
                            color: Colors.white,
                            fontSize: ResponsiveHelper.sp(18.0),
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ).responsive(context),
                        ),
                        SizedBox(height: ResponsiveHelper.h(2.0)),
                        Text(
                          '(MUST WIN BY 2)',
                          style: AppTypography.labelCaps.copyWith(
                            color: AppColors.mutedText,
                            fontSize: ResponsiveHelper.sp(11.0),
                            fontWeight: FontWeight.bold,
                          ).responsive(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: ResponsiveHelper.h(14.0)),

            // ─── 4. COMPLETED SETS CARD ───
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.w(16.0),
                vertical: ResponsiveHelper.h(14.0),
              ),
              decoration: BoxDecoration(
                color: cardBgColor,
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(16.0)),
                border: Border.all(
                  color: cardBorderColor,
                  width: 1.2,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          color: const Color(0xFF1E2838),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(12.0)),
                        child: Text(
                          'COMPLETED SETS',
                          style: AppTypography.labelCaps.copyWith(
                            color: AppColors.mutedText,
                            fontSize: ResponsiveHelper.sp(11.0),
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.0,
                          ).responsive(context),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 1,
                          color: const Color(0xFF1E2838),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: ResponsiveHelper.h(10.0)),
                  if (state.setHistory.isEmpty)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelper.w(16.0),
                        vertical: ResponsiveHelper.h(6.0),
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF182030),
                        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12.0)),
                        border: Border.all(
                          color: const Color(0xFF2B3850),
                          width: 1.0,
                        ),
                      ),
                      child: Text(
                        'NO COMPLETED SETS YET',
                        style: AppTypography.labelCaps.copyWith(
                          color: AppColors.mutedText,
                          fontSize: ResponsiveHelper.sp(11.0),
                          fontWeight: FontWeight.bold,
                        ).responsive(context),
                      ),
                    )
                  else
                    Wrap(
                      spacing: ResponsiveHelper.w(8.0),
                      runSpacing: ResponsiveHelper.h(6.0),
                      alignment: WrapAlignment.center,
                      children: state.setHistory.map((setRes) {
                        final isWinnerA = setRes.winnerTeam == 'sideA';
                        final badgeBorderColor = isWinnerA ? greenColor : blueColor;
                        final textColor = isWinnerA ? greenColor : blueColor;

                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveHelper.w(16.0),
                            vertical: ResponsiveHelper.h(6.0),
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF182030),
                            borderRadius: BorderRadius.circular(ResponsiveHelper.w(12.0)),
                            border: Border.all(
                              color: badgeBorderColor,
                              width: 1.2,
                            ),
                          ),
                          child: Text(
                            'S${setRes.setNumber}: ${setRes.sideAScore}-${setRes.sideBScore}',
                            style: AppTypography.labelCaps.copyWith(
                              color: textColor,
                              fontSize: ResponsiveHelper.sp(13.0),
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                            ).responsive(context),
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
