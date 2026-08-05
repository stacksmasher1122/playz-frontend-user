import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Kho_Kho/khokho_controller.dart';

class KhoKhoScoreDisplay extends StatelessWidget {
  const KhoKhoScoreDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<KhoKhoController>();

    return Obx(() {
      final state = controller.liveState.value;
      if (state == null) return const SizedBox.shrink();

      final homeName = controller.currentMatch.value?.homeTeam ?? 'Side A';
      final awayName = controller.currentMatch.value?.awayTeam ?? 'Side B';

      final activeChasingTeamName = state.activeChasingTeam == 'sideA' ? homeName : awayName;
      final activeDefendingTeamName = state.activeChasingTeam == 'sideA' ? awayName : homeName;

      final inningNumber = ((state.currentTurn - 1) ~/ 2) + 1;
      final turnInInning = ((state.currentTurn - 1) % 2) + 1;

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
            // Turn Badge & Active Role Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Inning / Turn Pill
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
                    'Inn $inningNumber • Turn $turnInInning (Turn ${state.currentTurn}/4)',
                    style: AppTypography.labelCaps.copyWith(
                      color: AppColors.accent,
                      fontSize: ResponsiveHelper.sp(12),
                      fontWeight: FontWeight.bold,
                    ).responsive(context),
                  ),
                ),

                // Active Chaser Pill
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.w(12),
                    vertical: ResponsiveHelper.h(5),
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B6B).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFFF6B6B).withValues(alpha: 0.4)),
                  ),
                  child: Text(
                    '⚡ Chasing: $activeChasingTeamName',
                    style: AppTypography.bodySm.copyWith(
                      color: const Color(0xFFFF6B6B),
                      fontSize: ResponsiveHelper.sp(11),
                      fontWeight: FontWeight.bold,
                    ).responsive(context),
                  ),
                ),
              ],
            ),

            SizedBox(height: ResponsiveHelper.h(16)),

            // Points Display Row
            Row(
              children: [
                // Team A Points
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
                        '${state.pointsA}',
                        style: AppTypography.displayScoreSora.copyWith(
                          color: AppColors.accent,
                          fontSize: ResponsiveHelper.sp(56),
                          fontWeight: FontWeight.w800,
                        ).responsive(context),
                      ),
                      Text(
                        state.activeChasingTeam == 'sideA' ? 'CHASING' : 'DEFENDING',
                        style: AppTypography.labelCaps.copyWith(
                          color: state.activeChasingTeam == 'sideA' ? AppColors.accent : AppColors.mutedText,
                          fontSize: 10,
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

                // Team B Points
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
                        '${state.pointsB}',
                        style: AppTypography.displayScoreSora.copyWith(
                          color: const Color(0xFF4D96FF),
                          fontSize: ResponsiveHelper.sp(56),
                          fontWeight: FontWeight.w800,
                        ).responsive(context),
                      ),
                      Text(
                        state.activeChasingTeam == 'sideB' ? 'CHASING' : 'DEFENDING',
                        style: AppTypography.labelCaps.copyWith(
                          color: state.activeChasingTeam == 'sideB' ? const Color(0xFF4D96FF) : AppColors.mutedText,
                          fontSize: 10,
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
