import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Tennis/tennis_state_models.dart';

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

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(24)),
        border: Border.all(
          color: state.isTiebreak || state.isMatchTiebreak
              ? AppColors.coinsGold.withValues(alpha: 0.5)
              : AppColors.cardSurface,
          width: 1.5,
        ),
      ),
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top Badges Bar: Match Status, Rule Mode, Tiebreak Banner
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Match Status Badge
              Flexible(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.w(10),
                    vertical: ResponsiveHelper.h(4),
                  ),
                  decoration: BoxDecoration(
                    color: state.matchStatus == 'COMPLETED'
                        ? AppColors.infoBlue.withValues(alpha: 0.2)
                        : (state.matchStatus == 'RETIRED'
                            ? AppColors.error.withValues(alpha: 0.2)
                            : AppColors.primaryGreen.withValues(alpha: 0.2)),
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
                  ),
                  child: Text(
                    state.matchStatus,
                    style: AppTypography.labelCaps.copyWith(
                      color: state.matchStatus == 'COMPLETED'
                          ? Colors.lightBlue
                          : (state.matchStatus == 'RETIRED'
                              ? AppColors.liveRed
                              : AppColors.primaryGreen),
                      fontSize: context.responsiveFont(11),
                      fontWeight: FontWeight.w800,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              SizedBox(width: ResponsiveHelper.w(8)),

              // Tiebreak or Current Set badge indicator
              Flexible(
                child: state.isTiebreak || state.isMatchTiebreak
                    ? Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveHelper.w(10),
                          vertical: ResponsiveHelper.h(4),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.coinsGold.withValues(alpha: 0.2),
                          borderRadius:
                              BorderRadius.circular(ResponsiveHelper.w(8)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.flash_on_rounded,
                                size: 14, color: AppColors.coinsGold),
                            SizedBox(width: ResponsiveHelper.w(4)),
                            Flexible(
                              child: Text(
                                state.isMatchTiebreak
                                    ? 'MATCH TIEBREAK (to 10)'
                                    : 'TIEBREAK (to ${state.matchConfig.tiebreakTarget})',
                                style: AppTypography.labelCaps.copyWith(
                                  color: AppColors.coinsGold,
                                  fontSize: context.responsiveFont(10),
                                  fontWeight: FontWeight.w800,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Text(
                        'Set ${state.currentSetIndex + 1} of ${state.matchConfig.setsFormat.replaceAll('BEST_OF_', 'Best of ')}',
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.mutedText,
                          fontSize: context.responsiveFont(12),
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.h(16)),

          // Team Scores & Server Display Row
          Row(
            children: [
              // Team A Card
              Expanded(
                child: _buildTeamScoreCard(
                  context: context,
                  name: homeName,
                  pointScore: state.sideAPointScore,
                  setsWon: state.sideASetsWon,
                  isServing: state.servingSide == 'A',
                  accentColor: AppColors.primaryGreen,
                  court: state.servingCourt,
                  isSecondServe: state.isSecondServe,
                ),
              ),

              SizedBox(width: ResponsiveHelper.w(10)),

              // VS & Current Set Score Divider
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'VS',
                    style: AppTypography.labelCaps.copyWith(
                      color: AppColors.mutedText,
                      fontSize: context.responsiveFont(13),
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.h(4)),
                  if (state.setScores.isNotEmpty)
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '${state.setScores[state.currentSetIndex].sideAGames} - ${state.setScores[state.currentSetIndex].sideBGames}',
                        style: AppTypography.monoLg.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: context.responsiveFont(20),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                ],
              ),

              SizedBox(width: ResponsiveHelper.w(10)),

              // Team B Card
              Expanded(
                child: _buildTeamScoreCard(
                  context: context,
                  name: awayName,
                  pointScore: state.sideBPointScore,
                  setsWon: state.sideBSetsWon,
                  isServing: state.servingSide == 'B',
                  accentColor: AppColors.infoBlue,
                  court: state.servingCourt,
                  isSecondServe: state.isSecondServe,
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.h(14)),

          // Set Scores History & Server / Court Indicator Bar
          Container(
            padding: EdgeInsets.all(ResponsiveHelper.w(12)),
            decoration: BoxDecoration(
              color: AppColors.cardSurface,
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Set score history row
                Row(
                  children: [
                    Text(
                      'Sets Score:',
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.mutedText,
                        fontSize: context.responsiveFont(12),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: ResponsiveHelper.w(8)),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: state.setScores.map((s) {
                            final isCurrent =
                                s.setNumber == (state.currentSetIndex + 1);
                            final tiebreakInfo = (s.tiebreakSideAPoints > 0 ||
                                    s.tiebreakSideBPoints > 0)
                                ? '(${s.winnerSide == 'A' ? s.tiebreakSideBPoints : s.tiebreakSideAPoints})'
                                : '';
                            return Container(
                              margin: EdgeInsets.only(
                                  right: ResponsiveHelper.w(6)),
                              padding: EdgeInsets.symmetric(
                                horizontal: ResponsiveHelper.w(8),
                                vertical: ResponsiveHelper.h(3),
                              ),
                              decoration: BoxDecoration(
                                color: isCurrent
                                    ? AppColors.primaryGreen
                                        .withValues(alpha: 0.2)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'S${s.setNumber}: ${s.sideAGames}-${s.sideBGames}$tiebreakInfo',
                                style: AppTypography.monoMd.copyWith(
                                  color: isCurrent
                                      ? AppColors.primaryGreen
                                      : AppColors.textPrimary,
                                  fontSize: context.responsiveFont(12),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ResponsiveHelper.h(8)),
                Divider(
                    color: Colors.white.withValues(alpha: 0.08), height: 1),
                SizedBox(height: ResponsiveHelper.h(8)),

                // Server court & ends switch indicator row
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.sports_tennis_rounded,
                            size: 16,
                            color: AppColors.primaryGreen,
                          ),
                          SizedBox(width: ResponsiveHelper.w(6)),
                          Text(
                            'Server: ${state.servingSide == 'A' ? homeName : awayName} (${state.servingCourt} Court)',
                            style: AppTypography.bodySm.copyWith(
                              color: AppColors.textPrimary,
                              fontSize: context.responsiveFont(12),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (state.isSecondServe) ...[
                            SizedBox(width: ResponsiveHelper.w(6)),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: ResponsiveHelper.w(6),
                                vertical: ResponsiveHelper.h(2),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '2nd Serve',
                                style: AppTypography.labelCaps10.copyWith(
                                  color: Colors.orangeAccent,
                                  fontSize: context.responsiveFont(10),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(width: ResponsiveHelper.w(16)),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.sync_alt_rounded,
                            size: 14,
                            color: state.isEndsSwitched
                                ? AppColors.coinsGold
                                : AppColors.mutedText,
                          ),
                          SizedBox(width: ResponsiveHelper.w(4)),
                          Text(
                            state.isEndsSwitched
                                ? 'Sides Switched'
                                : 'Normal Side',
                            style: AppTypography.bodySm.copyWith(
                              color: state.isEndsSwitched
                                  ? AppColors.coinsGold
                                  : AppColors.mutedText,
                              fontSize: context.responsiveFont(11),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamScoreCard({
    required BuildContext context,
    required String name,
    required String pointScore,
    required int setsWon,
    required bool isServing,
    required Color accentColor,
    required String court,
    required bool isSecondServe,
  }) {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(12)),
      decoration: BoxDecoration(
        color: isServing
            ? accentColor.withValues(alpha: 0.12)
            : AppColors.cardSurface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        border: Border.all(
          color: isServing ? accentColor : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  name,
                  style: AppTypography.headlineSm.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: context.responsiveFont(14),
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isServing) ...[
                SizedBox(width: ResponsiveHelper.w(4)),
                const Icon(
                  Icons.sports_tennis_rounded,
                  size: 14,
                  color: AppColors.primaryGreen,
                ),
              ],
            ],
          ),
          SizedBox(height: ResponsiveHelper.h(6)),

          // Point Score Display (Sora font, scaleDown fitted)
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              pointScore,
              style: AppTypography.displayScoreSora.copyWith(
                color: isServing ? accentColor : AppColors.textPrimary,
                fontSize: context.responsiveFont(36),
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          SizedBox(height: ResponsiveHelper.h(4)),

          Text(
            'Sets: $setsWon',
            style: AppTypography.bodySm.copyWith(
              color: AppColors.mutedText,
              fontSize: context.responsiveFont(12),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
