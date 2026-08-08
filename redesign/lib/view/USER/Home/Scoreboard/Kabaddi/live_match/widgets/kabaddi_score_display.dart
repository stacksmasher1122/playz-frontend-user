import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Kabaddi/kabaddi_controller.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Kabaddi/kabaddi_state_models.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

/// Top Scoreboard Display Card for Kabaddi with top-left timer pill and centered half header.
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
    ResponsiveHelper.init(context);
    final controller = Get.find<KabaddiController>();

    final String sideAName = controller.homeTeamName.value.isNotEmpty
        ? controller.homeTeamName.value
        : (state.teamA.isNotEmpty ? state.teamA.first.name : 'Side A');

    final String sideBName = controller.awayTeamName.value.isNotEmpty
        ? controller.awayTeamName.value
        : (state.teamB.isNotEmpty ? state.teamB.first.name : 'Side B');

    final bool isRaidingA = (state.raidingSide == PlayerSide.sideA);
    final bool isRaidingB = (state.raidingSide == PlayerSide.sideB);
    final int maxActive = state.config.activePlayersPerTeam;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Left Timer Pill (Outside the Card)
        Obx(() {
          final sec = controller.secondsRemaining.value;
          final minsStr = (sec ~/ 60).toString().padLeft(2, '0');
          final secsStr = (sec % 60).toString().padLeft(2, '0');
          final bool isRunning = controller.isTimerRunning.value;

          return GestureDetector(
            onTap: controller.toggleHalfTimer,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.w(12.0),
                vertical: ResponsiveHelper.h(6.0),
              ),
              decoration: BoxDecoration(
                color: AppColors.cardSurface,
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(16.0)),
                border: Border.all(color: AppColors.accent, width: 1.2),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    color: AppColors.accent,
                    size: ResponsiveHelper.w(18.0),
                  ),
                  SizedBox(width: ResponsiveHelper.w(6.0)),
                  Text(
                    '$minsStr:$secsStr',
                    style: AppTypography.headlineSm.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.bold,
                      fontSize: ResponsiveHelper.sp(15.0),
                      fontFamily: 'JetBrains Mono',
                    ).responsive(context),
                  ),
                ],
              ),
            ),
          );
        }),
        SizedBox(height: ResponsiveHelper.h(10.0)),

        // Main Live Scoreboard Container Card
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(ResponsiveHelper.w(16.0)),
          decoration: BoxDecoration(
            color: AppColors.cardSurface,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(20.0)),
            border: Border.all(color: AppColors.borderDark),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Centered Half Header: — 1st Half —
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: ResponsiveHelper.w(20.0),
                      height: 1.5,
                      color: AppColors.accent.withValues(alpha: 0.6),
                    ),
                    SizedBox(width: ResponsiveHelper.w(8.0)),
                    Text(
                      '${state.currentHalf}${state.currentHalf == 1 ? 'st' : 'nd'} Half',
                      style: AppTypography.labelCaps.copyWith(
                        color: AppColors.accent,
                        fontSize: ResponsiveHelper.sp(13.0),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ).responsive(context),
                    ),
                    SizedBox(width: ResponsiveHelper.w(8.0)),
                    Container(
                      width: ResponsiveHelper.w(20.0),
                      height: 1.5,
                      color: AppColors.accent.withValues(alpha: 0.6),
                    ),
                  ],
                ),
              ),
              SizedBox(height: ResponsiveHelper.h(16.0)),

              // 2 Team Cards Side-by-Side (Side A vs Side B)
              Row(
                children: [
                  // Side A Team Box
                  Expanded(
                    child: _buildTeamCardBox(
                      context,
                      teamName: sideAName,
                      score: state.sideAScore,
                      activeCount: state.sideAActiveCount,
                      maxActive: maxActive,
                      isRaiding: isRaidingA,
                      isDoOrDie: isRaidingA && state.isDoOrDieA,
                    ),
                  ),

                  // VS Divider
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(10.0)),
                    child: Column(
                      children: [
                        Container(
                          width: 3.0,
                          height: 3.0,
                          decoration: const BoxDecoration(
                            color: AppColors.mutedText,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(height: ResponsiveHelper.h(8.0)),
                        Text(
                          'VS',
                          style: AppTypography.headlineSm.copyWith(
                            color: AppColors.mutedText,
                            fontSize: ResponsiveHelper.sp(14.0),
                            fontWeight: FontWeight.w900,
                          ).responsive(context),
                        ),
                        SizedBox(height: ResponsiveHelper.h(8.0)),
                        Container(
                          width: 3.0,
                          height: 3.0,
                          decoration: const BoxDecoration(
                            color: AppColors.mutedText,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Side B Team Box
                  Expanded(
                    child: _buildTeamCardBox(
                      context,
                      teamName: sideBName,
                      score: state.sideBScore,
                      activeCount: state.sideBActiveCount,
                      maxActive: maxActive,
                      isRaiding: isRaidingB,
                      isDoOrDie: isRaidingB && state.isDoOrDieB,
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

  Widget _buildTeamCardBox(
    BuildContext context, {
    required String teamName,
    required int score,
    required int activeCount,
    required int maxActive,
    required bool isRaiding,
    required bool isDoOrDie,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        // Card Body Container
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.w(12.0),
            vertical: ResponsiveHelper.h(14.0),
          ),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(18.0)),
            border: Border.all(
              color: isRaiding ? AppColors.accent : AppColors.borderDark,
              width: isRaiding ? 2.0 : 1.0,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: isRaiding ? ResponsiveHelper.h(8.0) : ResponsiveHelper.h(2.0)),

              // Shield Icon (Filled green if raiding, else muted outline)
              Icon(
                isRaiding ? Icons.shield_rounded : Icons.shield_outlined,
                color: isRaiding ? AppColors.accent : AppColors.mutedText,
                size: ResponsiveHelper.w(26.0),
              ),
              SizedBox(height: ResponsiveHelper.h(6.0)),

              // Large Score Digit
              Text(
                '$score',
                style: AppTypography.displayLg.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: ResponsiveHelper.sp(44.0),
                  fontWeight: FontWeight.w900,
                  height: 1.0,
                ).responsive(context),
              ),
              SizedBox(height: ResponsiveHelper.h(8.0)),

              // Team Name
              Text(
                teamName,
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: ResponsiveHelper.sp(13.0),
                  fontWeight: FontWeight.bold,
                ).responsive(context),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: ResponsiveHelper.h(8.0)),

              // Active Players Pill
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.w(10.0),
                  vertical: ResponsiveHelper.h(3.0),
                ),
                decoration: BoxDecoration(
                  color: AppColors.cardSurface,
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(12.0)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: ResponsiveHelper.w(4.0)),
                    Text(
                      'Active: $activeCount/$maxActive',
                      style: AppTypography.labelCaps.copyWith(
                        color: AppColors.accent,
                        fontSize: ResponsiveHelper.sp(10.0),
                        fontWeight: FontWeight.bold,
                      ).responsive(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // RAIDING / DO-OR-DIE Top Floating Pill Badge
        if (isRaiding)
          Positioned(
            top: -11,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.w(10.0),
                vertical: ResponsiveHelper.h(3.0),
              ),
              decoration: BoxDecoration(
                color: isDoOrDie ? AppColors.error : AppColors.accent,
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(10.0)),
              ),
              child: Text(
                isDoOrDie ? 'DO-OR-DIE' : 'RAIDING',
                style: AppTypography.labelCaps.copyWith(
                  color: AppColors.background,
                  fontSize: ResponsiveHelper.sp(9.0),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.8,
                ).responsive(context),
              ),
            ),
          ),
      ],
    );
  }
}
