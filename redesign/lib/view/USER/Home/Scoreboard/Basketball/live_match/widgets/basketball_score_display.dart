import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Basketball/basketball_controller.dart';

/// High-fidelity Basketball Scoreboard Display Card matching the design screenshot.
class BasketballScoreDisplay extends StatelessWidget {
  const BasketballScoreDisplay({super.key});

  String _formatTimer(int totalSeconds) {
    final mins = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final secs = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  String _formatScore(int score) {
    return score.toString().padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<BasketballController>();

    return Obx(() {
      final state = controller.liveState.value;
      if (state == null) return const SizedBox.shrink();

      final homeName = controller.currentMatch.value?.homeTeam.isNotEmpty == true
          ? controller.currentMatch.value!.homeTeam
          : 'SIDE A';
      final awayName = controller.currentMatch.value?.awayTeam.isNotEmpty == true
          ? controller.currentMatch.value!.awayTeam
          : 'SIDE B';

      final isClockRunning = controller.isTimerRunning.value;
      final isArrowA = state.possessionTeam == 'sideA';
      final shotClockVal = controller.shotClockSeconds.value;

      return Container(
        padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16.0)),
        child: Column(
          children: [
            // ─── TOP STATUS CARDS ROW (Q1 | GAME CLOCK | SHOT CLOCK) ───
            Row(
              children: [
                // 1. Quarter Badge Card (Left)
                Expanded(
                  flex: 3,
                  child: Container(
                    height: ResponsiveHelper.h(58.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFF141822),
                      borderRadius: BorderRadius.circular(ResponsiveHelper.w(16.0)),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                    ),
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveHelper.w(12.0),
                          vertical: ResponsiveHelper.h(6.0),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(ResponsiveHelper.w(14.0)),
                          border: Border.all(
                            color: AppColors.accent.withValues(alpha: 0.4),
                            width: 1.2,
                          ),
                        ),
                        child: Text(
                          state.quarterDisplay,
                          style: AppTypography.headlineSm.copyWith(
                            color: AppColors.accent,
                            fontSize: ResponsiveHelper.sp(14.0),
                            fontWeight: FontWeight.w900,
                          ).responsive(context),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(10.0)),

                // 2. Main Game Clock Card (Middle)
                Expanded(
                  flex: 5,
                  child: GestureDetector(
                    onTap: () {
                      if (isClockRunning) {
                        controller.pauseForBreak();
                      } else {
                        controller.resumeFromBreak();
                      }
                    },
                    child: Container(
                      height: ResponsiveHelper.h(58.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFF141822),
                        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16.0)),
                        border: Border.all(
                          color: isClockRunning
                              ? AppColors.accent.withValues(alpha: 0.5)
                              : Colors.white.withValues(alpha: 0.1),
                          width: 1.2,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isClockRunning
                                ? Icons.timer_outlined
                                : Icons.pause_circle_outline_rounded,
                            color: isClockRunning ? AppColors.accent : AppColors.warning,
                            size: ResponsiveHelper.w(20.0),
                          ),
                          SizedBox(width: ResponsiveHelper.w(8.0)),
                          Text(
                            _formatTimer(controller.secondsRemaining.value),
                            style: AppTypography.displayLg.copyWith(
                              color: AppColors.textPrimary,
                              fontSize: ResponsiveHelper.sp(22.0),
                              fontWeight: FontWeight.w900,
                              fontFamily: 'JetBrains Mono',
                              letterSpacing: 0.5,
                            ).responsive(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(10.0)),

                // 3. 24s Shot Clock Card (Right)
                Expanded(
                  flex: 4,
                  child: Container(
                    height: ResponsiveHelper.h(58.0),
                    padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(10.0)),
                    decoration: BoxDecoration(
                      color: const Color(0xFF141822),
                      borderRadius: BorderRadius.circular(ResponsiveHelper.w(16.0)),
                      border: Border.all(
                        color: shotClockVal <= 5
                            ? AppColors.error.withValues(alpha: 0.6)
                            : Colors.white.withValues(alpha: 0.08),
                        width: 1.2,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '24s',
                              style: AppTypography.labelCaps.copyWith(
                                color: AppColors.textPrimary,
                                fontSize: ResponsiveHelper.sp(11.0),
                                fontWeight: FontWeight.w900,
                              ).responsive(context),
                            ),
                            Text(
                              'SHOT CLOCK',
                              style: AppTypography.labelCaps.copyWith(
                                color: AppColors.mutedText,
                                fontSize: ResponsiveHelper.sp(7.5),
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ).responsive(context),
                            ),
                          ],
                        ),
                        Text(
                          shotClockVal.toString().padLeft(2, '0'),
                          style: AppTypography.displayLg.copyWith(
                            color: shotClockVal <= 5 ? AppColors.error : const Color(0xFFFF5252),
                            fontSize: ResponsiveHelper.sp(22.0),
                            fontWeight: FontWeight.w900,
                            fontFamily: 'JetBrains Mono',
                          ).responsive(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveHelper.h(16.0)),

            // ─── MAIN SCOREBOARD CONTAINER WITH FLOATING POSSESSION BADGE ───
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                // Score Container
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.w(16.0),
                    vertical: ResponsiveHelper.h(22.0),
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF141822),
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(20.0)),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                  ),
                  child: Row(
                    children: [
                      // SIDE A (Left - Green Theme)
                      Expanded(
                        child: Column(
                          children: [
                            SizedBox(height: ResponsiveHelper.h(6.0)),
                            Text(
                              homeName.toUpperCase(),
                              style: AppTypography.labelCaps.copyWith(
                                color: AppColors.textPrimary,
                                fontSize: ResponsiveHelper.sp(13.0),
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.0,
                              ).responsive(context),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: ResponsiveHelper.h(4.0)),
                            Container(
                              width: ResponsiveHelper.w(24.0),
                              height: 2.0,
                              decoration: BoxDecoration(
                                color: AppColors.accent,
                                borderRadius: BorderRadius.circular(2.0),
                              ),
                            ),
                            SizedBox(height: ResponsiveHelper.h(10.0)),

                            // Big Score Numerals
                            Text(
                              _formatScore(state.sideAScore),
                              style: AppTypography.displayScoreSora.copyWith(
                                color: AppColors.accent,
                                fontSize: ResponsiveHelper.sp(56.0),
                                fontWeight: FontWeight.w900,
                                height: 1.0,
                              ).responsive(context),
                            ),
                            SizedBox(height: ResponsiveHelper.h(14.0)),

                            // Fouls Indicator
                            Text(
                              'FOULS',
                              style: AppTypography.labelCaps.copyWith(
                                color: AppColors.mutedText,
                                fontSize: ResponsiveHelper.sp(9.5),
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.0,
                              ).responsive(context),
                            ),
                            SizedBox(height: ResponsiveHelper.h(3.0)),
                            Text(
                              '${state.teamFoulsA} / 5',
                              style: AppTypography.bodySm.copyWith(
                                color: state.isBonusPenaltyA ? AppColors.error : AppColors.textPrimary,
                                fontSize: ResponsiveHelper.sp(14.0),
                                fontWeight: FontWeight.w900,
                              ).responsive(context),
                            ),
                          ],
                        ),
                      ),

                      // Center Divider with VS Badge
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(8.0)),
                        child: Container(
                          width: ResponsiveHelper.w(36.0),
                          height: ResponsiveHelper.w(36.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0B0E14),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
                          ),
                          child: Center(
                            child: Text(
                              'VS',
                              style: AppTypography.labelCaps.copyWith(
                                color: AppColors.textPrimary,
                                fontSize: ResponsiveHelper.sp(11.0),
                                fontWeight: FontWeight.w900,
                              ).responsive(context),
                            ),
                          ),
                        ),
                      ),

                      // SIDE B (Right - Blue Theme)
                      Expanded(
                        child: Column(
                          children: [
                            SizedBox(height: ResponsiveHelper.h(6.0)),
                            Text(
                              awayName.toUpperCase(),
                              style: AppTypography.labelCaps.copyWith(
                                color: AppColors.textPrimary,
                                fontSize: ResponsiveHelper.sp(13.0),
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.0,
                              ).responsive(context),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: ResponsiveHelper.h(4.0)),
                            Container(
                              width: ResponsiveHelper.w(24.0),
                              height: 2.0,
                              decoration: BoxDecoration(
                                color: const Color(0xFF4D96FF),
                                borderRadius: BorderRadius.circular(2.0),
                              ),
                            ),
                            SizedBox(height: ResponsiveHelper.h(10.0)),

                            // Big Score Numerals
                            Text(
                              _formatScore(state.sideBScore),
                              style: AppTypography.displayScoreSora.copyWith(
                                color: const Color(0xFF4D96FF),
                                fontSize: ResponsiveHelper.sp(56.0),
                                fontWeight: FontWeight.w900,
                                height: 1.0,
                              ).responsive(context),
                            ),
                            SizedBox(height: ResponsiveHelper.h(14.0)),

                            // Fouls Indicator
                            Text(
                              'FOULS',
                              style: AppTypography.labelCaps.copyWith(
                                color: AppColors.mutedText,
                                fontSize: ResponsiveHelper.sp(9.5),
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.0,
                              ).responsive(context),
                            ),
                            SizedBox(height: ResponsiveHelper.h(3.0)),
                            Text(
                              '${state.teamFoulsB} / 5',
                              style: AppTypography.bodySm.copyWith(
                                color: state.isBonusPenaltyB ? AppColors.error : AppColors.textPrimary,
                                fontSize: ResponsiveHelper.sp(14.0),
                                fontWeight: FontWeight.w900,
                              ).responsive(context),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Floating Top Arrow Possession Pill Badge
                Positioned(
                  top: -13,
                  child: GestureDetector(
                    onTap: () => controller.togglePossessionArrow(),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelper.w(14.0),
                        vertical: ResponsiveHelper.h(4.5),
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1B2230),
                        borderRadius: BorderRadius.circular(ResponsiveHelper.w(14.0)),
                        border: Border.all(
                          color: isArrowA
                              ? AppColors.accent.withValues(alpha: 0.6)
                              : const Color(0xFF4D96FF).withValues(alpha: 0.6),
                          width: 1.2,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isArrowA ? Icons.arrow_left_rounded : Icons.arrow_right_rounded,
                            color: isArrowA ? AppColors.accent : const Color(0xFF4D96FF),
                            size: ResponsiveHelper.w(18.0),
                          ),
                          SizedBox(width: ResponsiveHelper.w(4.0)),
                          Text(
                            'ARROW: ${isArrowA ? homeName.toUpperCase() : awayName.toUpperCase()}',
                            style: AppTypography.labelCaps.copyWith(
                              color: isArrowA ? AppColors.accent : const Color(0xFF4D96FF),
                              fontSize: ResponsiveHelper.sp(10.5),
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.8,
                            ).responsive(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
