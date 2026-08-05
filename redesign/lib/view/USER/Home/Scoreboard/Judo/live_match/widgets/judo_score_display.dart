import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Judo/judo_controller.dart';

class JudoScoreDisplay extends StatelessWidget {
  const JudoScoreDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<JudoController>();

    return Obx(() {
      final state = controller.liveState.value;
      if (state == null) return const SizedBox.shrink();

      final whiteName = controller.currentMatch.value?.whiteFighter ?? 'WHITE Corner';
      final blueName = controller.currentMatch.value?.blueFighter ?? 'BLUE Corner';

      final minutes = (state.contestTimeRemaining ~/ 60).toString().padLeft(2, '0');
      final seconds = (state.contestTimeRemaining % 60).toString().padLeft(2, '0');

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
            // IJF Badge, Golden Score & Contest Timer Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // IJF Pill
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.w(12),
                    vertical: ResponsiveHelper.h(5),
                  ),
                  decoration: BoxDecoration(
                    color: state.isGoldenScore
                        ? Colors.amber.withValues(alpha: 0.25)
                        : AppColors.accent.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: state.isGoldenScore ? Colors.amber : AppColors.accent.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Text(
                    state.isGoldenScore ? 'GOLDEN SCORE' : 'IJF Judo Rules',
                    style: AppTypography.labelCaps.copyWith(
                      color: state.isGoldenScore ? Colors.amber : AppColors.accent,
                      fontSize: ResponsiveHelper.sp(12),
                      fontWeight: FontWeight.bold,
                    ).responsive(context),
                  ),
                ),

                // Contest Timer Pill
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

            // OSAEKOMI HOLD-DOWN LIVE PIN TIMER BAR (IF ACTIVE)
            if (state.isOsaekomiActive) ...[
              Container(
                margin: EdgeInsets.only(bottom: ResponsiveHelper.h(16)),
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.w(16),
                  vertical: ResponsiveHelper.h(10),
                ),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.amber, width: 1.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.timer, color: Colors.amber, size: 20),
                        SizedBox(width: ResponsiveHelper.w(8)),
                        Text(
                          'OSAEKOMI (${state.osaekomiSide == "white" ? "WHITE" : "BLUE"})',
                          style: GoogleFonts.inter(
                            color: Colors.amber,
                            fontWeight: FontWeight.w900,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${state.osaekomiTime}s / 20s',
                      style: GoogleFonts.sora(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Technical Scores & Competitor Names Row
            Row(
              children: [
                // WHITE CORNER (Judoka A)
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        whiteName,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.headlineSm.copyWith(
                          color: const Color(0xFFE0E0E0),
                          fontSize: ResponsiveHelper.sp(15),
                          fontWeight: FontWeight.bold,
                        ).responsive(context),
                      ),
                      SizedBox(height: ResponsiveHelper.h(6)),
                      Text(
                        state.whiteFighter.isIpponAwarded
                            ? 'IPPON'
                            : 'W:${state.whiteFighter.wazaAriCount}',
                        style: AppTypography.displayScoreSora.copyWith(
                          color: const Color(0xFFE0E0E0),
                          fontSize: state.whiteFighter.isIpponAwarded ? ResponsiveHelper.sp(32) : ResponsiveHelper.sp(48),
                          fontWeight: FontWeight.w800,
                        ).responsive(context),
                      ),
                      SizedBox(height: ResponsiveHelper.h(4)),
                      Text(
                        'Shido: ${state.whiteFighter.shidoCount} / 3',
                        style: AppTypography.labelCaps.copyWith(
                          color: state.whiteFighter.shidoCount >= 2 ? Colors.redAccent : AppColors.mutedText,
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

                // BLUE CORNER (Judoka B)
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
                        state.blueFighter.isIpponAwarded
                            ? 'IPPON'
                            : 'W:${state.blueFighter.wazaAriCount}',
                        style: AppTypography.displayScoreSora.copyWith(
                          color: const Color(0xFF4D96FF),
                          fontSize: state.blueFighter.isIpponAwarded ? ResponsiveHelper.sp(32) : ResponsiveHelper.sp(48),
                          fontWeight: FontWeight.w800,
                        ).responsive(context),
                      ),
                      SizedBox(height: ResponsiveHelper.h(4)),
                      Text(
                        'Shido: ${state.blueFighter.shidoCount} / 3',
                        style: AppTypography.labelCaps.copyWith(
                          color: state.blueFighter.shidoCount >= 2 ? Colors.redAccent : AppColors.mutedText,
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
