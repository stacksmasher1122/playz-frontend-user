import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Wrestling/wrestling_controller.dart';

class WrestlingScoreDisplay extends StatelessWidget {
  const WrestlingScoreDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<WrestlingController>();

    return Obx(() {
      final state = controller.liveState.value;
      if (state == null) return const SizedBox.shrink();

      final wAName = controller.currentMatch.value?.wrestlerA ?? 'Red Corner';
      final wBName = controller.currentMatch.value?.wrestlerB ?? 'Blue Corner';

      final minutes = (state.periodTimeRemaining ~/ 60).toString().padLeft(2, '0');
      final seconds = (state.periodTimeRemaining % 60).toString().padLeft(2, '0');

      final styleText = state.config.style == 'GRECO_ROMAN' ? 'Greco-Roman' : 'Freestyle';

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
            // Period Badge & Live Timer Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Period Pill
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
                    'Period ${state.currentPeriodIndex + 1} of ${state.config.totalPeriods} • $styleText',
                    style: AppTypography.labelCaps.copyWith(
                      color: AppColors.accent,
                      fontSize: ResponsiveHelper.sp(12),
                      fontWeight: FontWeight.bold,
                    ).responsive(context),
                  ),
                ),

                // Live Timer Pill
                GestureDetector(
                  onTap: () => controller.toggleTimer(),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveHelper.w(12),
                      vertical: ResponsiveHelper.h(5),
                    ),
                    decoration: BoxDecoration(
                      color: controller.isTimerRunning.value
                          ? const Color(0xFFFF4D4D).withValues(alpha: 0.2)
                          : Colors.white10,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: controller.isTimerRunning.value
                            ? const Color(0xFFFF4D4D).withValues(alpha: 0.4)
                            : Colors.white24,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          controller.isTimerRunning.value ? Icons.pause_circle_filled : Icons.play_circle_fill,
                          color: controller.isTimerRunning.value ? const Color(0xFFFF4D4D) : Colors.white70,
                          size: 16,
                        ),
                        SizedBox(width: ResponsiveHelper.w(4)),
                        Text(
                          '$minutes:$seconds',
                          style: AppTypography.displayScoreSora.copyWith(
                            color: controller.isTimerRunning.value ? const Color(0xFFFF4D4D) : Colors.white70,
                            fontSize: ResponsiveHelper.sp(14),
                            fontWeight: FontWeight.bold,
                          ).responsive(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: ResponsiveHelper.h(16)),

            // Total Technical Points & Wrestler Names Row
            Row(
              children: [
                // Red Corner (Wrestler A)
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        wAName,
                        textAlign: TextAlign.center,
                        style: AppTypography.headlineSm.copyWith(
                          color: const Color(0xFFFF4D4D),
                          fontSize: ResponsiveHelper.sp(15),
                          fontWeight: FontWeight.bold,
                        ).responsive(context),
                      ),
                      SizedBox(height: ResponsiveHelper.h(6)),
                      Text(
                        '${state.sideAPoints}',
                        style: AppTypography.displayScoreSora.copyWith(
                          color: const Color(0xFFFF4D4D),
                          fontSize: ResponsiveHelper.sp(56),
                          fontWeight: FontWeight.w800,
                        ).responsive(context),
                      ),
                      Text(
                        'Cautions: ${state.wrestlerA.cautions}',
                        style: AppTypography.labelCaps.copyWith(
                          color: AppColors.mutedText,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
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

                // Blue Corner (Wrestler B)
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        wBName,
                        textAlign: TextAlign.center,
                        style: AppTypography.headlineSm.copyWith(
                          color: const Color(0xFF4D96FF),
                          fontSize: ResponsiveHelper.sp(15),
                          fontWeight: FontWeight.bold,
                        ).responsive(context),
                      ),
                      SizedBox(height: ResponsiveHelper.h(6)),
                      Text(
                        '${state.sideBPoints}',
                        style: AppTypography.displayScoreSora.copyWith(
                          color: const Color(0xFF4D96FF),
                          fontSize: ResponsiveHelper.sp(56),
                          fontWeight: FontWeight.w800,
                        ).responsive(context),
                      ),
                      Text(
                        'Cautions: ${state.wrestlerB.cautions}',
                        style: AppTypography.labelCaps.copyWith(
                          color: AppColors.mutedText,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ).responsive(context),
                      ),
                    ],
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
