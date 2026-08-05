import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/MuayThai/muay_thai_controller.dart';

class MuayThaiScoreDisplay extends StatelessWidget {
  const MuayThaiScoreDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<MuayThaiController>();

    return Obx(() {
      final state = controller.liveState.value;
      if (state == null) return const SizedBox.shrink();

      final redName = controller.currentMatch.value?.fighterA ?? 'RED Corner';
      final blueName = controller.currentMatch.value?.fighterB ?? 'BLUE Corner';

      final isRest = state.isRestTime;
      final timeVal = isRest ? state.restTimeRemaining : state.roundTimeRemaining;
      final minutes = (timeVal ~/ 60).toString().padLeft(2, '0');
      final seconds = (timeVal % 60).toString().padLeft(2, '0');

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
            // Muay Thai Badge, Round Badge & Timer Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Round / Rest Pill
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.w(12),
                    vertical: ResponsiveHelper.h(5),
                  ),
                  decoration: BoxDecoration(
                    color: isRest
                        ? Colors.amber.withValues(alpha: 0.2)
                        : AppColors.accent.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isRest ? Colors.amber : AppColors.accent.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Text(
                    isRest
                        ? 'REST BREAK'
                        : 'ROUND ${state.currentRound} / ${state.config.totalRounds}',
                    style: AppTypography.labelCaps.copyWith(
                      color: isRest ? Colors.amber : AppColors.accent,
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

            // Total 10-Point Must Scores & Fighter Names Row
            Row(
              children: [
                // RED CORNER
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        redName,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.headlineSm.copyWith(
                          color: const Color(0xFFFF4D4D),
                          fontSize: ResponsiveHelper.sp(15),
                          fontWeight: FontWeight.bold,
                        ).responsive(context),
                      ),
                      SizedBox(height: ResponsiveHelper.h(6)),
                      Text(
                        '${state.totalScoreA}',
                        style: AppTypography.displayScoreSora.copyWith(
                          color: const Color(0xFFFF4D4D),
                          fontSize: ResponsiveHelper.sp(56),
                          fontWeight: FontWeight.w800,
                        ).responsive(context),
                      ),
                      if (state.fighterA.knockdownsCount > 0)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.amber.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.amber),
                          ),
                          child: Text(
                            '${state.fighterA.knockdownsCount} KD',
                            style: const TextStyle(color: Colors.amber, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
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

                // BLUE CORNER
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        blueName,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.headlineSm.copyWith(
                          color: const Color(0xFF4D96FF),
                          fontSize: ResponsiveHelper.sp(15),
                          fontWeight: FontWeight.bold,
                        ).responsive(context),
                      ),
                      SizedBox(height: ResponsiveHelper.h(6)),
                      Text(
                        '${state.totalScoreB}',
                        style: AppTypography.displayScoreSora.copyWith(
                          color: const Color(0xFF4D96FF),
                          fontSize: ResponsiveHelper.sp(56),
                          fontWeight: FontWeight.w800,
                        ).responsive(context),
                      ),
                      if (state.fighterB.knockdownsCount > 0)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.amber.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.amber),
                          ),
                          child: Text(
                            '${state.fighterB.knockdownsCount} KD',
                            style: const TextStyle(color: Colors.amber, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),

            if (state.roundScores.isNotEmpty) ...[
              SizedBox(height: ResponsiveHelper.h(16)),
              const Divider(color: Colors.white10),
              SizedBox(height: ResponsiveHelper.h(8)),
              Text(
                'ROUND SCORECARDS (10-MUST)',
                style: AppTypography.labelCaps.copyWith(
                  color: AppColors.mutedText,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ).responsive(context),
              ),
              SizedBox(height: ResponsiveHelper.h(8)),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: state.roundScores.map((r) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF141414),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                    ),
                    child: Text(
                      'R${r.roundNumber}: ${r.scoreA} - ${r.scoreB}',
                      style: GoogleFonts.inter(
                        color: AppColors.accent,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
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
