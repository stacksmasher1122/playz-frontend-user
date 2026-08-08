import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/badminton_controller.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/badminton_state_models.dart';

class BadmintonScoreboardHeader extends StatelessWidget {
  final BadmintonController controller;
  final BadmintonMatchState state;

  const BadmintonScoreboardHeader({
    super.key,
    required this.controller,
    required this.state,
  });

  String _getInitials(String name, String fallback) {
    final cleanName = name.trim().isEmpty ? fallback : name.trim();
    final parts = cleanName.split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.length >= 3) {
      return (parts[0][0] + parts[1][0] + parts[2][0]).toUpperCase();
    } else if (parts.length == 2) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    } else if (cleanName.length >= 3) {
      return cleanName.substring(0, 3).toUpperCase();
    }
    return cleanName.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    final int gameNumber = state.currentGameIndex + 1;
    final int scoreA = state.currentScoreA;
    final int scoreB = state.currentScoreB;
    final int gamesWonA = state.games.where((g) => g.isCompleted && g.winner == PlayerSide.sideA).length;
    final int gamesWonB = state.games.where((g) => g.isCompleted && g.winner == PlayerSide.sideB).length;

    final String homeName = controller.homeTeamName.value.isNotEmpty
        ? controller.homeTeamName.value
        : 'SIDE A';
    final String awayName = controller.awayTeamName.value.isNotEmpty
        ? controller.awayTeamName.value
        : 'SIDE B';

    final String initialsA = _getInitials(homeName, 'AAA');
    final String initialsB = _getInitials(awayName, 'BBB');

    final String? logoA = controller.currentMatch.value?.teamALogo;
    final String? logoB = controller.currentMatch.value?.teamBLogo;

    final int targetSets = state.config.gamesToWin;
    final String setsFormatText = targetSets == 1
        ? 'Best of 1'
        : targetSets == 3
            ? 'Best of 5'
            : 'Best of 3';

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.w(20.0),
        vertical: ResponsiveHelper.h(18.0),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1117),
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(20.0)),
        border: Border.all(color: Colors.white10, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Subtitle Row: GAME 1   Best of 3
          Row(
            children: [
              Text(
                state.status == MatchStatus.completed ? 'FINAL' : 'GAME $gameNumber',
                style: AppTypography.headlineSm.copyWith(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.sp(15.0),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                ).responsive(context),
              ),
              SizedBox(width: ResponsiveHelper.w(12.0)),
              Text(
                setsFormatText,
                style: AppTypography.bodySm.copyWith(
                  color: const Color(0xFF8E8E93),
                  fontSize: ResponsiveHelper.sp(14.0),
                  fontWeight: FontWeight.w500,
                ).responsive(context),
              ),
              const Spacer(),
              if (state.config.intervalsEnabled && state.hasIntervalOccurred)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.w(8.0),
                    vertical: ResponsiveHelper.h(4.0),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(6.0)),
                  ),
                  child: Text(
                    'INTERVAL',
                    style: TextStyle(
                      color: AppColors.warning,
                      fontSize: ResponsiveHelper.sp(10.0),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.h(20.0)),

          // Main Scoreboard Area with Vertical Divider + Shuttlecock Icon
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Side A Column
              Expanded(
                child: _TeamScoreColumn(
                  initials: initialsA,
                  imageUrl: logoA,
                  teamName: homeName.toUpperCase(),
                  circleColor: const Color(0xFFEF4444),
                  gamesWon: gamesWonA,
                  score: scoreA,
                  isServing: state.servingSide == PlayerSide.sideA,
                ),
              ),

              // Center Divider Line with Shuttlecock Icon & SET label
              SizedBox(
                height: ResponsiveHelper.h(160.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 1.2,
                      color: Colors.white12,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelper.w(6.0),
                        vertical: ResponsiveHelper.h(6.0),
                      ),
                      color: const Color(0xFF0D1117),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.sports_tennis_rounded,
                            color: Colors.white70,
                            size: ResponsiveHelper.w(18.0),
                          ),
                          SizedBox(height: ResponsiveHelper.h(2.0)),
                          Text(
                            'SET',
                            style: AppTypography.labelCaps.copyWith(
                              color: const Color(0xFF22C55E),
                              fontSize: ResponsiveHelper.sp(10.0),
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2,
                            ).responsive(context),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Side B Column
              Expanded(
                child: _TeamScoreColumn(
                  initials: initialsB,
                  imageUrl: logoB,
                  teamName: awayName.toUpperCase(),
                  circleColor: const Color(0xFF22C55E),
                  gamesWon: gamesWonB,
                  score: scoreB,
                  isServing: state.servingSide == PlayerSide.sideB,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TeamScoreColumn extends StatelessWidget {
  final String initials;
  final String? imageUrl;
  final String teamName;
  final Color circleColor;
  final int gamesWon;
  final int score;
  final bool isServing;

  const _TeamScoreColumn({
    required this.initials,
    this.imageUrl,
    required this.teamName,
    required this.circleColor,
    required this.gamesWon,
    required this.score,
    required this.isServing,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final bool hasImage = imageUrl != null && imageUrl!.trim().isNotEmpty;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Glowing Circle Avatar
        Container(
          width: ResponsiveHelper.w(58.0),
          height: ResponsiveHelper.w(58.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF0D1117),
            border: Border.all(color: circleColor, width: 2.0),
            boxShadow: [
              BoxShadow(
                color: circleColor.withValues(alpha: 0.4),
                blurRadius: 14,
                spreadRadius: 1,
              ),
            ],
            image: hasImage
                ? DecorationImage(
                    image: CachedNetworkImageProvider(imageUrl!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          alignment: Alignment.center,
          child: !hasImage
              ? Text(
                  initials,
                  style: AppTypography.headlineSm.copyWith(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.sp(16.0),
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ).responsive(context),
                )
              : null,
        ),
        SizedBox(height: ResponsiveHelper.h(8.0)),

        // Team Name Label (e.g., SIDE A / SIDE B)
        Text(
          teamName,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.labelCaps.copyWith(
            color: circleColor,
            fontSize: ResponsiveHelper.sp(13.0),
            fontWeight: FontWeight.w800,
            letterSpacing: 1.0,
          ).responsive(context),
        ),
        SizedBox(height: ResponsiveHelper.h(4.0)),

        // GAMES WON count
        Text(
          'GAMES: $gamesWon',
          style: AppTypography.bodySm.copyWith(
            color: const Color(0xFF8E8E93),
            fontSize: ResponsiveHelper.sp(11.0),
            fontWeight: FontWeight.w600,
          ).responsive(context),
        ),
        SizedBox(height: ResponsiveHelper.h(8.0)),

        // Big Point Score
        Text(
          '$score',
          style: AppTypography.displayLg.copyWith(
            color: Colors.white,
            fontSize: ResponsiveHelper.sp(46.0),
            fontWeight: FontWeight.w900,
            height: 1.0,
          ).responsive(context),
        ),
        SizedBox(height: ResponsiveHelper.h(10.0)),

        // Serving Dot Indicator
        Container(
          width: ResponsiveHelper.w(12.0),
          height: ResponsiveHelper.w(12.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isServing ? circleColor : Colors.transparent,
            border: Border.all(
              color: isServing ? circleColor : const Color(0xFF374151),
              width: 2.0,
            ),
            boxShadow: isServing
                ? [
                    BoxShadow(
                      color: circleColor.withValues(alpha: 0.6),
                      blurRadius: 6,
                    ),
                  ]
                : [],
          ),
        ),
      ],
    );
  }
}
