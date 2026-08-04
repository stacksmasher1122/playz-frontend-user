import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Table_Tennis/table_tennis_state_models.dart';

class TtScoreboardHeader extends StatelessWidget {
  final TableTennisMatchState state;

  const TtScoreboardHeader({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    final homeName = state.matchConfig.homeTeamName;
    final awayName = state.matchConfig.awayTeamName;
    final isCompleted = state.matchStatus == 'COMPLETED' || state.matchStatus == 'RETIRED';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(24)),
        border: Border.all(
          color: state.isDeuce
              ? AppColors.coinsGold
              : AppColors.primaryGreen.withValues(alpha: 0.3),
          width: state.isDeuce ? 2.0 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: (state.isDeuce ? AppColors.coinsGold : AppColors.primaryGreen)
                .withValues(alpha: 0.1),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: EdgeInsets.all(ResponsiveHelper.w(20)),
      child: Column(
        children: [
          // Top Status Line
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.w(10),
                    vertical: ResponsiveHelper.h(4),
                  ),
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? AppColors.primaryGreen.withValues(alpha: 0.2)
                        : AppColors.liveRed.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: ResponsiveHelper.w(8),
                        height: ResponsiveHelper.h(8),
                        decoration: BoxDecoration(
                          color: isCompleted ? AppColors.primaryGreen : AppColors.liveRed,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: ResponsiveHelper.w(6)),
                      Flexible(
                        child: Text(
                          isCompleted
                              ? 'COMPLETED'
                              : 'LIVE • GAME ${state.currentGameIndex + 1}',
                          style: AppTypography.labelCaps.copyWith(
                            color: isCompleted ? AppColors.primaryGreen : AppColors.liveRed,
                            fontSize: context.responsiveFont(10),
                            fontWeight: FontWeight.w900,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (state.isDeuce && !isCompleted) ...[
                SizedBox(width: ResponsiveHelper.w(8)),
                Flexible(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveHelper.w(10),
                      vertical: ResponsiveHelper.h(4),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.coinsGold.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
                      border: Border.all(color: AppColors.coinsGold, width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.bolt_rounded,
                          color: AppColors.coinsGold,
                          size: 14,
                        ),
                        SizedBox(width: ResponsiveHelper.w(4)),
                        Flexible(
                          child: Text(
                            'DEUCE (1 Pt Serve)',
                            style: AppTypography.labelCaps.copyWith(
                              color: AppColors.coinsGold,
                              fontSize: context.responsiveFont(10),
                              fontWeight: FontWeight.w900,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: ResponsiveHelper.h(16)),

          // Hero Point Scoreboard Row
          Row(
            children: [
              // Side A Player Box
              Expanded(
                child: _buildTeamScoreBox(
                  context,
                  name: homeName,
                  points: state.sideAPoints,
                  gamesWon: state.sideAGamesWon,
                  isServing: state.servingSide == 'A',
                  accentColor: AppColors.error,
                ),
              ),

              // Vs Divider & Serve Count Indicator
              Padding(
                padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(12)),
                child: Column(
                  children: [
                    Text(
                      'VS',
                      style: AppTypography.labelCaps.copyWith(
                        color: AppColors.mutedText,
                        fontSize: context.responsiveFont(12),
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.h(6)),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelper.w(8),
                        vertical: ResponsiveHelper.h(4),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(ResponsiveHelper.w(6)),
                      ),
                      child: Text(
                        state.isDeuce
                            ? 'Serve 1/1'
                            : 'Serve ${state.serveCount + 1}/2',
                        style: AppTypography.monoMd.copyWith(
                          color: AppColors.primaryGreen,
                          fontSize: context.responsiveFont(11),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Side B Player Box
              Expanded(
                child: _buildTeamScoreBox(
                  context,
                  name: awayName,
                  points: state.sideBPoints,
                  gamesWon: state.sideBGamesWon,
                  isServing: state.servingSide == 'B',
                  accentColor: AppColors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.h(16)),

          // Completed Games Breakdown Scroll View
          if (state.gameScores.isNotEmpty) ...[
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: state.gameScores.map((g) {
                  final isActive = g.gameNumber == (state.currentGameIndex + 1);
                  return Container(
                    margin: EdgeInsets.only(right: ResponsiveHelper.w(8)),
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveHelper.w(10),
                      vertical: ResponsiveHelper.h(6),
                    ),
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.primaryGreen.withValues(alpha: 0.15)
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
                      border: Border.all(
                        color: isActive
                            ? AppColors.primaryGreen
                            : AppColors.borderDark,
                      ),
                    ),
                    child: Text(
                      'G${g.gameNumber}: ${g.sideAPoints}-${g.sideBPoints}',
                      style: AppTypography.monoMd.copyWith(
                        color: isActive ? AppColors.primaryGreen : AppColors.textPrimary,
                        fontSize: context.responsiveFont(12),
                        fontWeight: isActive ? FontWeight.w800 : FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: ResponsiveHelper.h(12)),
          ],

          // Sides Switched Banner
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.sync_alt_rounded,
                color: state.isEndsSwitched ? AppColors.warning : AppColors.mutedText,
                size: 16,
              ),
              SizedBox(width: ResponsiveHelper.w(6)),
              Text(
                state.isEndsSwitched ? 'Sides Switched' : 'Normal Side',
                style: AppTypography.bodySm.copyWith(
                  color: state.isEndsSwitched ? AppColors.warning : AppColors.mutedText,
                  fontSize: context.responsiveFont(12),
                  fontWeight: FontWeight.w600,
                ),
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
    required int points,
    required int gamesWon,
    required bool isServing,
    required Color accentColor,
  }) {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(12)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        border: Border.all(
          color: isServing ? AppColors.coinsGold : AppColors.borderDark,
          width: isServing ? 2.0 : 1.0,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isServing) ...[
                const Icon(
                  Icons.sports_tennis_rounded,
                  color: AppColors.coinsGold,
                  size: 16,
                ),
                SizedBox(width: ResponsiveHelper.w(4)),
              ],
              Flexible(
                child: Text(
                  name,
                  style: AppTypography.headlineSm.copyWith(
                    color: isServing ? AppColors.coinsGold : AppColors.textPrimary,
                    fontSize: context.responsiveFont(14),
                    fontWeight: FontWeight.w800,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.h(8)),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '$points',
              style: AppTypography.displayScoreSora.copyWith(
                color: AppColors.textPrimary,
                fontSize: context.responsiveFont(52),
              ),
            ),
          ),
          SizedBox(height: ResponsiveHelper.h(4)),
          Text(
            'Games: $gamesWon',
            style: AppTypography.labelCaps.copyWith(
              color: AppColors.mutedText,
              fontSize: context.responsiveFont(11),
            ),
          ),
        ],
      ),
    );
  }
}
