import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/badminton_controller.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/badminton_state_models.dart';

class BadmintonScoreboardHeader extends StatelessWidget {
  final BadmintonController controller;
  final BadmintonMatchState state;

  BadmintonScoreboardHeader({
    super.key,
    required this.controller,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    final int gameNumber = state.currentGameIndex + 1;
    final int scoreA = state.currentScoreA;
    final int scoreB = state.currentScoreB;
    final int gamesWonA = state.games.where((g) => g.isCompleted && g.winner == PlayerSide.sideA).length;
    final int gamesWonB = state.games.where((g) => g.isCompleted && g.winner == PlayerSide.sideB).length;

    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
        border: Border.all(color: Colors.white12, width: 1),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                state.status == MatchStatus.completed
                    ? 'FINAL'
                    : 'GAME $gameNumber',
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: ResponsiveHelper.sp(12),
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                ),
              ),
              if (state.config.intervalsEnabled && state.hasIntervalOccurred)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'INTERVAL',
                    style: TextStyle(
                      color: AppColors.warning,
                      fontSize: ResponsiveHelper.sp(10),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _TeamColumn(
                teamName: 'SIDE A',
                color: AppColors.error,
                gamesWon: gamesWonA,
                score: scoreA,
                isServing: state.servingSide == PlayerSide.sideA,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(20)),
                child: Text(
                  '-',
                  style: TextStyle(
                    color: Colors.white24,
                    fontSize: ResponsiveHelper.sp(40),
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              _TeamColumn(
                teamName: 'SIDE B',
                color: AppColors.primary,
                gamesWon: gamesWonB,
                score: scoreB,
                isServing: state.servingSide == PlayerSide.sideB,
              ),
            ],
          ),
          SizedBox(height: 16),
          // Game History
          if (state.games.isNotEmpty)
            Wrap(
              spacing: 8,
              children: state.games.asMap().entries.map((entry) {
                final idx = entry.key;
                final g = entry.value;
                if (!g.isCompleted) return SizedBox.shrink();
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'G${idx + 1}: ${g.scoreA}-${g.scoreB}',
                    style: TextStyle(
                      color: AppColors.muted,
                      fontSize: ResponsiveHelper.sp(12),
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}

class _TeamColumn extends StatelessWidget {
  final String teamName;
  final Color color;
  final int gamesWon;
  final int score;
  final bool isServing;

  const _TeamColumn({
    required this.teamName,
    required this.color,
    required this.gamesWon,
    required this.score,
    required this.isServing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          teamName,
          style: TextStyle(
            color: color,
            fontSize: ResponsiveHelper.sp(12),
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'GAMES: $gamesWon',
          style: TextStyle(
            color: AppColors.muted,
            fontSize: ResponsiveHelper.sp(10),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Container(
          width: ResponsiveHelper.w(80),
          alignment: Alignment.center,
          child: Text(
            '$score',
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.sp(64),
              fontWeight: FontWeight.w900,
              fontFamily: 'JetBrains Mono',
              height: 1.0,
            ),
          ),
        ),
        SizedBox(height: 8),
        // Serving Indicator
        Container(
          width: ResponsiveHelper.w(12),
          height: ResponsiveHelper.h(12),
          decoration: BoxDecoration(
            color: isServing ? color : Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(
              color: isServing ? color : Colors.white24,
              width: 2,
            ),
          ),
        ),
      ],
    );
  }
}
