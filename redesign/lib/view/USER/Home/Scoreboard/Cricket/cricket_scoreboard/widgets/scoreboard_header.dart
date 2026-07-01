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

  ScoreboardHeader({
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
    String teamName = 'Batting Team';
    String oppName = 'Bowling Team';

    if (controller.currentMatch.value != null) {
      if (inningsNumber == 1) {
        teamName = controller.currentMatch.value!.battingFirstTeam;
        oppName = controller.currentMatch.value!.bowlingFirstTeam;
      } else {
        teamName = controller.currentMatch.value!.bowlingFirstTeam;
        oppName = controller.currentMatch.value!.battingFirstTeam;
      }
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
              _teamLogo(teamCode, Colors.blue),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      teamName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.sp(18),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'vs $oppName · ${inningsNumber == 1 ? "1st" : "2nd"} Innings',
                      style: TextStyle(color: AppColors.muted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Text(
                          '$totalRuns',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ResponsiveHelper.sp(42),
                            fontWeight: FontWeight.w800,
                            height: ResponsiveHelper.h(1),
                          ),
                        ),
                      ),
                      Text(
                        ' /$wickets',
                        style: TextStyle(color: AppColors.muted, fontSize: 24),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
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
                      SizedBox(width: 8),
                      Text(
                        'P$inningsNumber  $oversDisplay Overs',
                        style: TextStyle(color: AppColors.muted, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _statBadge('CRR ${currentRunRate.toStringAsFixed(2)}'),
              if (targetScore != null)
                _projBadge('Proj: $projectedScore - ${projectedScore + 12}')
              else
                _projBadge('Proj: $projectedScore'),
              _statBadge(
                'Avg ${(totalRuns / (wickets == 0 ? 1 : wickets)).round()}',
              ),
            ],
          ),
          if (targetScore != null) ...[
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Target: $targetScore',
                  style: TextStyle(color: AppColors.muted, fontSize: 13),
                ),
                Text(
                  'Need ${targetScore! - totalRuns} off ${(controller.engine.maxOvers - overs) * 6 - balls} balls',
                  style: TextStyle(color: Colors.amber, fontSize: 13),
                ),
              ],
            ),
          ],
          if (matchStatus == 'MATCH_COMPLETED') ...[
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16), vertical: ResponsiveHelper.h(8)),
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
            SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(12), vertical: ResponsiveHelper.h(8)),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(10)),
                border: Border.all(color: Colors.amber, width: 1.2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shield_rounded, color: Colors.amber, size: 16),
                  SizedBox(width: 8),
                  Text(
                    'FREE HIT — batter cannot be dismissed (except Run Out)',
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: ResponsiveHelper.sp(12),
                      fontWeight: FontWeight.w600,
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
      width: ResponsiveHelper.w(48),
      height: ResponsiveHelper.h(48),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        code,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: ResponsiveHelper.sp(14),
        ),
      ),
    );
  }

  Widget _statBadge(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(10), vertical: ResponsiveHelper.h(4)),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.white70, fontSize: 12),
      ),
    );
  }

  Widget _projBadge(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(12), vertical: ResponsiveHelper.h(4)),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.accent,
          fontSize: ResponsiveHelper.sp(12),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
