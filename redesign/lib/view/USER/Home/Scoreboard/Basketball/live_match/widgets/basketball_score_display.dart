import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Basketball/basketball_controller.dart';

class BasketballScoreDisplay extends StatelessWidget {
  const BasketballScoreDisplay({super.key});

  String _formatTimer(int totalSeconds) {
    final mins = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final secs = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<BasketballController>();

    return Obx(() {
      final state = controller.liveState.value;
      if (state == null) return const SizedBox.shrink();

      final homeName = controller.currentMatch.value?.homeTeam ?? 'Side A';
      final awayName = controller.currentMatch.value?.awayTeam ?? 'Side B';
      final isClockRunning = controller.isTimerRunning.value;
      final isArrowA = state.possessionTeam == 'sideA';

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
            // Quarter Pill, Game Clock, Shot Clock & Possession Arrow Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Quarter Badge
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.w(10),
                    vertical: ResponsiveHelper.h(5),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.accent.withValues(alpha: 0.4)),
                  ),
                  child: Text(
                    state.quarterDisplay,
                    style: AppTypography.labelCaps.copyWith(
                      color: AppColors.accent,
                      fontSize: ResponsiveHelper.sp(12),
                      fontWeight: FontWeight.bold,
                    ).responsive(context),
                  ),
                ),

                // Game Clock Pill
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.w(14),
                    vertical: ResponsiveHelper.h(5),
                  ),
                  decoration: BoxDecoration(
                    color: isClockRunning
                        ? AppColors.accent.withValues(alpha: 0.15)
                        : AppColors.warning.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isClockRunning ? AppColors.accent : AppColors.warning,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isClockRunning ? Icons.timer_outlined : Icons.pause_circle_outline,
                        color: isClockRunning ? AppColors.accent : AppColors.warning,
                        size: 16,
                      ),
                      SizedBox(width: ResponsiveHelper.w(6)),
                      Text(
                        _formatTimer(controller.secondsRemaining.value),
                        style: AppTypography.monoMd.copyWith(
                          color: isClockRunning ? AppColors.accent : AppColors.warning,
                          fontSize: ResponsiveHelper.sp(14),
                          fontWeight: FontWeight.w900,
                        ).responsive(context),
                      ),
                    ],
                  ),
                ),

                // 24s Shot Clock Pill
                if (state.config.enableShotClock)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveHelper.w(10),
                      vertical: ResponsiveHelper.h(5),
                    ),
                    decoration: BoxDecoration(
                      color: controller.shotClockSeconds.value <= 5
                          ? AppColors.error.withValues(alpha: 0.3)
                          : const Color(0xFF262626),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: controller.shotClockSeconds.value <= 5
                            ? AppColors.error
                            : Colors.white24,
                      ),
                    ),
                    child: Text(
                      '24s: ${controller.shotClockSeconds.value}',
                      style: AppTypography.labelCaps.copyWith(
                        color: controller.shotClockSeconds.value <= 5
                            ? AppColors.liveRed
                            : AppColors.textPrimary,
                        fontSize: ResponsiveHelper.sp(12),
                        fontWeight: FontWeight.bold,
                      ).responsive(context),
                    ),
                  ),
              ],
            ),

            SizedBox(height: ResponsiveHelper.h(12)),

            // Alternating Possession Arrow Indicator Pill
            GestureDetector(
              onTap: () => controller.togglePossessionArrow(),
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
                    Icon(
                      isArrowA ? Icons.arrow_left : Icons.arrow_right,
                      color: isArrowA ? AppColors.accent : const Color(0xFF4D96FF),
                      size: 20,
                    ),
                    Text(
                      'ARROW: ${isArrowA ? homeName.toUpperCase() : awayName.toUpperCase()}',
                      style: AppTypography.labelCaps.copyWith(
                        color: isArrowA ? AppColors.accent : const Color(0xFF4D96FF),
                        fontSize: ResponsiveHelper.sp(11),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ).responsive(context),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: ResponsiveHelper.h(14)),

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
                        '${state.sideAScore}',
                        style: AppTypography.displayScoreSora.copyWith(
                          color: AppColors.accent,
                          fontSize: ResponsiveHelper.sp(44),
                          fontWeight: FontWeight.w800,
                        ).responsive(context),
                      ),
                      SizedBox(height: ResponsiveHelper.h(4)),
                      Text(
                        'Fouls: ${state.teamFoulsA}/5',
                        style: AppTypography.bodySm.copyWith(
                          color: state.isBonusPenaltyA ? AppColors.liveRed : AppColors.mutedText,
                          fontSize: ResponsiveHelper.sp(11),
                          fontWeight: state.isBonusPenaltyA ? FontWeight.bold : FontWeight.normal,
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
                        '${state.sideBScore}',
                        style: AppTypography.displayScoreSora.copyWith(
                          color: const Color(0xFF4D96FF),
                          fontSize: ResponsiveHelper.sp(44),
                          fontWeight: FontWeight.w800,
                        ).responsive(context),
                      ),
                      SizedBox(height: ResponsiveHelper.h(4)),
                      Text(
                        'Fouls: ${state.teamFoulsB}/5',
                        style: AppTypography.bodySm.copyWith(
                          color: state.isBonusPenaltyB ? AppColors.liveRed : AppColors.mutedText,
                          fontSize: ResponsiveHelper.sp(11),
                          fontWeight: state.isBonusPenaltyB ? FontWeight.bold : FontWeight.normal,
                        ).responsive(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // MATCH ON BREAK Banner
            if (controller.isMatchStarted.value && !isClockRunning) ...[
              SizedBox(height: ResponsiveHelper.h(14)),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  vertical: ResponsiveHelper.h(8),
                  horizontal: ResponsiveHelper.w(12),
                ),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.warning.withValues(alpha: 0.5)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.pause_circle_filled, color: AppColors.warning, size: 18),
                    SizedBox(width: ResponsiveHelper.w(8)),
                    Text(
                      'MATCH ON BREAK - TAP RESUME TO CONTINUE',
                      style: AppTypography.labelCaps.copyWith(
                        color: AppColors.warning,
                        fontSize: ResponsiveHelper.sp(11),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ).responsive(context),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      );
    });
  }
}
