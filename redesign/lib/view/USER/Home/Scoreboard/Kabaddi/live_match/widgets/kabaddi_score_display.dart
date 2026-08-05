import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Kabaddi/kabaddi_controller.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Kabaddi/kabaddi_state_models.dart';

class KabaddiScoreDisplay extends StatelessWidget {
  final KabaddiMatchState state;
  final Function(PlayerSide) onScoreRaid;
  final Function(PlayerSide) onScoreTackle;

  const KabaddiScoreDisplay({
    super.key,
    required this.state,
    required this.onScoreRaid,
    required this.onScoreTackle,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<KabaddiController>();
    String sideAName = state.teamA.isNotEmpty ? state.teamA.first.name : 'Side A';
    String sideBName = state.teamB.isNotEmpty ? state.teamB.first.name : 'Side B';

    final isRaidingA = state.raidingSide == PlayerSide.sideA;
    final isRaidingB = state.raidingSide == PlayerSide.sideB;
    final maxActive = state.config.activePlayersPerTeam;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Live Scoreboard Container Card
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.w(12),
            vertical: ResponsiveHelper.h(14),
          ),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
            border: Border.all(color: AppColors.borderDark, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header: Half Timer & Pro Raid Clock
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Half Timer Pill
                  Obx(() {
                    final sec = controller.secondsRemaining.value;
                    final minsStr = (sec ~/ 60).toString().padLeft(2, '0');
                    final secsStr = (sec % 60).toString().padLeft(2, '0');
                    return GestureDetector(
                      onTap: controller.toggleHalfTimer,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveHelper.w(8),
                          vertical: ResponsiveHelper.h(4),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceElevated,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.primaryGreen, width: 1),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              controller.isTimerRunning.value ? Icons.pause : Icons.play_arrow,
                              color: AppColors.primaryGreen,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$minsStr:$secsStr',
                              style: AppTypography.labelCaps.copyWith(
                                color: AppColors.primaryGreen,
                                fontWeight: FontWeight.bold,
                                fontSize: context.responsiveFont(11),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

                  // 30s Raid Clock (in Pro Mode)
                  if (state.config.isProRules)
                    Obx(() {
                      final raidSec = controller.raidClockSeconds.value;
                      final isLow = raidSec <= 5;
                      return GestureDetector(
                        onTap: controller.toggleRaidClock,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveHelper.w(8),
                            vertical: ResponsiveHelper.h(4),
                          ),
                          decoration: BoxDecoration(
                            color: isLow ? AppColors.error.withValues(alpha: 0.2) : AppColors.surfaceElevated,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isLow ? AppColors.error : AppColors.coinsGold,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.timer,
                                color: isLow ? AppColors.error : AppColors.coinsGold,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Raid: 00:${raidSec.toString().padLeft(2, '0')}',
                                style: AppTypography.labelCaps.copyWith(
                                  color: isLow ? AppColors.error : AppColors.coinsGold,
                                  fontWeight: FontWeight.bold,
                                  fontSize: context.responsiveFont(11),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                ],
              ),
              SizedBox(height: ResponsiveHelper.h(10)),

              // Official Break Banner
              Obx(() {
                final isMatchStarted = controller.isMatchStarted.value;
                final isRunning = controller.isTimerRunning.value;
                if (isMatchStarted && !isRunning) {
                  return Container(
                    margin: EdgeInsets.only(bottom: ResponsiveHelper.h(8)),
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveHelper.w(10),
                      vertical: ResponsiveHelper.h(4),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.amber),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.pause_circle_filled, color: Colors.amber, size: 14),
                        const SizedBox(width: 6),
                        Text(
                          'MATCH ON BREAK - TAP RESUME TO CONTINUE',
                          style: AppTypography.labelCaps.copyWith(
                            color: Colors.amber,
                            fontWeight: FontWeight.bold,
                            fontSize: context.responsiveFont(10),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),

              Row(
                children: [
                  // Side A Box
                  Expanded(
                    child: _buildSideScoreBox(
                      context: context,
                      sideName: sideAName,
                      score: state.sideAScore,
                      activeCount: state.sideAActiveCount,
                      maxActive: maxActive,
                      isRaiding: isRaidingA,
                      isDoOrDie: isRaidingA && state.isDoOrDieA,
                      accentColor: AppColors.error,
                      onTapScore: () => onScoreRaid(PlayerSide.sideA),
                    ),
                  ),

                  // VS & Half Header
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(6)),
                    child: Column(
                      children: [
                        Text(
                          'VS',
                          style: AppTypography.headlineSm.copyWith(
                            color: AppColors.mutedText,
                            fontSize: context.responsiveFont(12),
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: ResponsiveHelper.h(6)),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveHelper.w(8),
                            vertical: ResponsiveHelper.h(3),
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceElevated,
                            borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
                            border: Border.all(color: AppColors.borderDark),
                          ),
                          child: Text(
                            '${state.currentHalf}st Half',
                            style: AppTypography.labelCaps.copyWith(
                              color: AppColors.primaryGreen,
                              fontSize: context.responsiveFont(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Side B Box
                  Expanded(
                    child: _buildSideScoreBox(
                      context: context,
                      sideName: sideBName,
                      score: state.sideBScore,
                      activeCount: state.sideBActiveCount,
                      maxActive: maxActive,
                      isRaiding: isRaidingB,
                      isDoOrDie: isRaidingB && state.isDoOrDieB,
                      accentColor: AppColors.primary,
                      onTapScore: () => onScoreRaid(PlayerSide.sideB),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSideScoreBox({
    required BuildContext context,
    required String sideName,
    required int score,
    required int activeCount,
    required int maxActive,
    required bool isRaiding,
    required bool isDoOrDie,
    required Color accentColor,
    required VoidCallback onTapScore,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.w(8),
        vertical: ResponsiveHelper.h(10),
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        border: Border.all(
          color: isRaiding ? (isDoOrDie ? AppColors.error : accentColor) : AppColors.borderDark,
          width: isRaiding ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          // Raiding Badge Status
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isRaiding)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.w(6),
                    vertical: ResponsiveHelper.h(2),
                  ),
                  decoration: BoxDecoration(
                    color: isDoOrDie ? AppColors.error : accentColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    isDoOrDie ? 'DO-OR-DIE' : 'RAIDING',
                    style: AppTypography.labelCaps.copyWith(
                      color: Colors.black,
                      fontSize: context.responsiveFont(9),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                )
              else
                const SizedBox(height: 18),
            ],
          ),
          SizedBox(height: ResponsiveHelper.h(4)),

          // Score Digits
          GestureDetector(
            onTap: onTapScore,
            child: Text(
              '$score',
              style: AppTypography.displayScoreSora.copyWith(
                color: isRaiding ? AppColors.textPrimary : AppColors.textSecondary,
                fontSize: context.responsiveFont(54),
                fontWeight: FontWeight.bold,
                height: 1.0,
              ),
            ),
          ),
          SizedBox(height: ResponsiveHelper.h(6)),

          // Team Title
          Text(
            sideName,
            style: AppTypography.headlineSm.copyWith(
              color: AppColors.textPrimary,
              fontSize: context.responsiveFont(12),
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: ResponsiveHelper.h(4)),

          // Active Players Pill
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.w(8),
              vertical: ResponsiveHelper.h(2),
            ),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Active: $activeCount/$maxActive',
              style: AppTypography.bodyXs.copyWith(
                color: AppColors.primaryGreen,
                fontSize: context.responsiveFont(11),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
