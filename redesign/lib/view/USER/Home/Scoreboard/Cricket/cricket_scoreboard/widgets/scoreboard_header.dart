import 'package:flutter/material.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/cricket_controller.dart';
import 'package:redesign/theme/app_colors.dart';

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
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _teamLogo(teamCode, Colors.blue),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      teamName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'vs $oppName · ${inningsNumber == 1 ? "1st" : "2nd"} Innings',
                      style: const TextStyle(color: AppColors.muted, fontSize: 12),
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
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '$totalRuns',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 42,
                            fontWeight: FontWeight.w800,
                            height: 1,
                          ),
                        ),
                      ),
                      Text(
                        ' /$wickets',
                        style: const TextStyle(color: AppColors.muted, fontSize: 24),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          currentPhase,
                          style: const TextStyle(
                            color: AppColors.accent,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'P${inningsNumber}  $oversDisplay Overs',
                        style: const TextStyle(color: AppColors.muted, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
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
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Target: $targetScore',
                  style: const TextStyle(color: AppColors.muted, fontSize: 13),
                ),
                Text(
                  'Need ${targetScore! - totalRuns} off ${(controller.engine.maxOvers - overs) * 6 - balls} balls',
                  style: const TextStyle(color: Colors.amber, fontSize: 13),
                ),
              ],
            ),
          ],
          if (matchStatus == 'MATCH_COMPLETED') ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                matchResult,
                style: const TextStyle(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
          if (isFreeHit) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.amber, width: 1.2),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shield_rounded, color: Colors.amber, size: 16),
                  SizedBox(width: 8),
                  Text(
                    'FREE HIT — batter cannot be dismissed (except Run Out)',
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 12,
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
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        code,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _statBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white70, fontSize: 12),
      ),
    );
  }

  Widget _projBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.accent,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
