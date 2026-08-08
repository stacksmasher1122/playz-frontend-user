import 'package:flutter/material.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Tennis/tennis_state_models.dart';

/// Tennis Live Scoreboard Header Card designed strictly matching reference UI pixel-for-pixel.
class TennisScoreboardHeader extends StatelessWidget {
  final TennisMatchState state;

  const TennisScoreboardHeader({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final homeName = state.matchConfig.homeTeamName;
    final awayName = state.matchConfig.awayTeamName;
    final currentSetNum = state.currentSetIndex + 1;
    final maxSetsLabel = state.matchConfig.setsFormat.replaceAll('BEST_OF_', 'Best of ');

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0D1117),
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 1.0,
        ),
      ),
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ─── 1. TOP HEADER ROW (NO LIVE BADGE PER USER INSTRUCTION) ───
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Set $currentSetNum of $maxSetsLabel',
                style: AppTypography.bodySm.copyWith(
                  color: const Color(0xFF8E8E93),
                  fontSize: ResponsiveHelper.sp(12),
                  fontWeight: FontWeight.w600,
                ).responsive(context),
              ),
            ],
          ),

          SizedBox(height: ResponsiveHelper.h(16)),

          // ─── 2. MAIN TEAMS & SCORE BOXES ───
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ─── SIDE A (HOME TEAM) BOX ───
              Expanded(
                child: _buildTeamScoreBox(
                  context,
                  name: homeName,
                  pointScore: state.sideAPointScore,
                  setsWon: state.sideASetsWon,
                  isServing: state.servingSide == 'A',
                  isGreenAccent: true,
                ),
              ),

              SizedBox(width: ResponsiveHelper.w(12)),

              // ─── CENTER VS & SET GAMES COLUMN ───
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'VS',
                    style: AppTypography.labelCaps.copyWith(
                      color: const Color(0xFF8E8E93),
                      fontSize: ResponsiveHelper.sp(13),
                      fontWeight: FontWeight.w900,
                    ).responsive(context),
                  ),
                  SizedBox(height: ResponsiveHelper.h(6)),
                  Text(
                    state.setScores.isNotEmpty
                        ? '${state.setScores[state.currentSetIndex].sideAGames} - ${state.setScores[state.currentSetIndex].sideBGames}'
                        : '0 - 0',
                    style: AppTypography.headlineSm.copyWith(
                      color: Colors.white,
                      fontSize: ResponsiveHelper.sp(20),
                      fontWeight: FontWeight.w900,
                    ).responsive(context),
                  ),
                ],
              ),

              SizedBox(width: ResponsiveHelper.w(12)),

              // ─── SIDE B (AWAY TEAM) BOX ───
              Expanded(
                child: _buildTeamScoreBox(
                  context,
                  name: awayName,
                  pointScore: state.sideBPointScore,
                  setsWon: state.sideBSetsWon,
                  isServing: state.servingSide == 'B',
                  isGreenAccent: false,
                ),
              ),
            ],
          ),

          SizedBox(height: ResponsiveHelper.h(20)),

          // ─── 3. SET SCORE DIVIDER ROW ───
          Column(
            children: [
              Text(
                'SET SCORE',
                style: AppTypography.labelCaps.copyWith(
                  color: const Color(0xFF8E8E93),
                  fontSize: ResponsiveHelper.sp(10),
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0,
                ).responsive(context),
              ),
              SizedBox(height: ResponsiveHelper.h(8)),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 1,
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(12)),
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveHelper.w(14),
                      vertical: ResponsiveHelper.h(6),
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0A2417),
                      borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
                      border: Border.all(color: const Color(0xFF00E676), width: 1.0),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: state.setScores.map((s) {
                          final String tiebreakStr = (s.tiebreakSideAPoints > 0 || s.tiebreakSideBPoints > 0)
                              ? ' (${s.winnerSide == 'A' ? s.tiebreakSideBPoints : s.tiebreakSideAPoints})'
                              : '';
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(4)),
                            child: Text(
                              'S${s.setNumber}: ${s.sideAGames} - ${s.sideBGames}$tiebreakStr',
                              style: AppTypography.monoMd.copyWith(
                                color: const Color(0xFF00E676),
                                fontSize: ResponsiveHelper.sp(12),
                                fontWeight: FontWeight.w800,
                              ).responsive(context),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 1,
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: ResponsiveHelper.h(16)),

          // ─── 4. BOTTOM SERVER & SET FORMAT INFO ROW ───
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Server info
              Expanded(
                child: Row(
                  children: [
                    const Icon(
                      Icons.sports_tennis_rounded,
                      size: 16,
                      color: Color(0xFF00E676),
                    ),
                    SizedBox(width: ResponsiveHelper.w(6)),
                    Flexible(
                      child: Text(
                        'Server: ${state.servingSide == 'A' ? homeName : awayName} (${state.servingCourt} Court)',
                        style: AppTypography.bodySm.copyWith(
                          color: Colors.white,
                          fontSize: ResponsiveHelper.sp(11),
                          fontWeight: FontWeight.w600,
                        ).responsive(context),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              // Vertical Divider
              Container(
                height: 14,
                width: 1,
                color: Colors.white24,
                margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(8)),
              ),

              // Match / Set Mode indicator
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.sync_alt_rounded,
                    size: 16,
                    color: Color(0xFF00E676),
                  ),
                  SizedBox(width: ResponsiveHelper.w(6)),
                  Text(
                    state.isTiebreak || state.isMatchTiebreak ? 'Tiebreak' : 'Normal Set',
                    style: AppTypography.bodySm.copyWith(
                      color: Colors.white,
                      fontSize: ResponsiveHelper.sp(11),
                      fontWeight: FontWeight.w600,
                    ).responsive(context),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTeamScoreBox(
    BuildContext context, {
    required String name,
    required String pointScore,
    required int setsWon,
    required bool isServing,
    required bool isGreenAccent,
  }) {
    final Color borderColor = isServing ? const Color(0xFF00E676) : Colors.white.withValues(alpha: 0.08);
    final Color scoreColor = isServing || isGreenAccent ? const Color(0xFF00E676) : Colors.white;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.w(12),
        vertical: ResponsiveHelper.h(14),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF14181F),
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        border: Border.all(
          color: borderColor,
          width: isServing ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        children: [
          // Player Name & Serving Racquet Icon Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  name,
                  style: AppTypography.bodyMd.copyWith(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.sp(13),
                    fontWeight: FontWeight.bold,
                  ).responsive(context),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isServing) ...[
                SizedBox(width: ResponsiveHelper.w(4)),
                const Icon(
                  Icons.sports_tennis_rounded,
                  size: 14,
                  color: Color(0xFF00E676),
                ),
              ],
            ],
          ),

          SizedBox(height: ResponsiveHelper.h(10)),

          // Big Center Point Score Number
          Text(
            pointScore,
            style: AppTypography.headlineLg.copyWith(
              color: scoreColor,
              fontSize: ResponsiveHelper.sp(42),
              fontWeight: FontWeight.w900,
              height: 1.0,
            ).responsive(context),
          ),

          SizedBox(height: ResponsiveHelper.h(12)),

          // Sets Count Subtitle Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: isServing ? const Color(0xFF00E676) : const Color(0xFF8E8E93),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: ResponsiveHelper.w(6)),
              Text(
                'SETS: $setsWon',
                style: AppTypography.labelCaps10.copyWith(
                  color: const Color(0xFF8E8E93),
                  fontSize: ResponsiveHelper.sp(11),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ).responsive(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
