import 'package:flutter/material.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/cricket_controller.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ScoreboardHeader extends StatelessWidget {
  final CricketController controller;
  final int totalRuns;
  final int wickets;
  final int inningsNumber;
  final String oversDisplay;
  final String currentPhase;
  final double currentRunRate;
  final int projectedScore;
  final int? targetScore;
  final String matchResult;
  final String matchStatus;
  final bool isFreeHit;
  final int overs;
  final int balls;

  const ScoreboardHeader({
    super.key,
    required this.controller,
    required this.totalRuns,
    required this.wickets,
    required this.inningsNumber,
    required this.oversDisplay,
    required this.currentPhase,
    required this.currentRunRate,
    required this.projectedScore,
    this.targetScore,
    required this.matchResult,
    required this.matchStatus,
    required this.isFreeHit,
    required this.overs,
    required this.balls,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    String teamCode = 'BAT';

    if (controller.currentMatch.value != null) {
      final String teamName = inningsNumber == 1
          ? controller.currentMatch.value!.battingFirstTeam
          : controller.currentMatch.value!.bowlingFirstTeam;
      teamCode = teamName.length >= 3
          ? teamName.substring(0, 3).toUpperCase()
          : teamName.toUpperCase();
    }

    return Container(
      margin: EdgeInsets.all(ResponsiveHelper.w(16)),
      padding: EdgeInsets.all(ResponsiveHelper.w(20)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(18)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _teamLogo(teamCode, AppColors.infoBlue),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '$totalRuns',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: ResponsiveHelper.sp(42),
                            fontWeight: FontWeight.w800,
                            height: ResponsiveHelper.h(1),
                          ),
                        ),
                      ),
                      Text(
                        ' /$wickets',
                        style: TextStyle(
                          color: AppColors.muted,
                          fontSize: ResponsiveHelper.sp(14),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveHelper.w(6),
                          vertical: ResponsiveHelper.h(2),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(ResponsiveHelper.w(4)),
                        ),
                        child: Text(
                          currentPhase,
                          style: TextStyle(
                            color: AppColors.accent,
                            fontSize: ResponsiveHelper.sp(10),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: ResponsiveHelper.w(8)),
                      Text(
                        'P$inningsNumber  $oversDisplay Overs',
                        style: TextStyle(
                          color: AppColors.muted,
                          fontSize: ResponsiveHelper.sp(12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          if (targetScore != null) ...[
            SizedBox(height: ResponsiveHelper.h(12)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Target: $targetScore',
                  style: TextStyle(
                    color: AppColors.muted,
                    fontSize: ResponsiveHelper.sp(12),
                  ),
                ),
                Text(
                  'Need ${targetScore! - totalRuns} off ${(controller.engine.maxOvers - overs) * 6 - balls} balls',
                  style: TextStyle(
                    color: AppColors.coinsGold,
                    fontSize: ResponsiveHelper.sp(12),
                  ),
                ),
              ],
            ),
          ],
          if (matchStatus == 'MATCH_COMPLETED') ...[
            SizedBox(height: ResponsiveHelper.h(8)),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.w(16),
                vertical: ResponsiveHelper.h(8),
              ),
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
              ),
              child: Text(
                matchResult,
                style: TextStyle(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
          if (isFreeHit) ...[
            SizedBox(height: ResponsiveHelper.h(8)),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.w(12),
                vertical: ResponsiveHelper.h(8),
              ),
              decoration: BoxDecoration(
                color: AppColors.coinsGold.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(10)),
                border: Border.all(color: AppColors.coinsGold, width: 1.2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shield_rounded, color: AppColors.coinsGold, size: 16),
                  SizedBox(width: ResponsiveHelper.w(8)),
                  Expanded(
                    child: Text(
                      'FREE HIT — only Run Out & non-bowling dismissals apply',
                      style: TextStyle(
                        color: AppColors.coinsGold,
                        fontSize: ResponsiveHelper.sp(12),
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _teamLogo(String code, Color color) {
    return Container(
      width: ResponsiveHelper.w(52),
      height: ResponsiveHelper.h(52),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: 0.5), width: 1.5),
      ),
      alignment: Alignment.center,
      child: Text(
        code,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w800,
          fontSize: ResponsiveHelper.sp(16),
        ),
      ),
    );
  }
}
