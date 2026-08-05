import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Squash/squash_state_models.dart';

class SquashGameHistoryBar extends StatelessWidget {
  final SquashMatchState state;

  const SquashGameHistoryBar({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final systemText = state.config.scoringSystem == SquashScoringSystem.pars
        ? 'PARS (Point-a-Rally) to ${state.config.pointsToWin}'
        : 'HIHO (Server Score Only) to ${state.hihoTargetPoints}';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.w(16),
        vertical: ResponsiveHelper.h(12),
      ),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'MATCH STATUS & GAMES',
                style: AppTypography.labelCaps.copyWith(
                  color: AppColors.mutedText,
                  fontSize: context.responsiveFont(10),
                ),
              ),
              Text(
                systemText,
                style: AppTypography.bodyXs.copyWith(
                  color: AppColors.primaryGreen,
                  fontWeight: FontWeight.w600,
                  fontSize: context.responsiveFont(11),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.h(8)),
          if (state.gameHistory.isEmpty)
            Text(
              'No completed games yet.',
              style: AppTypography.bodyXs.copyWith(
                color: AppColors.mutedText,
                fontStyle: FontStyle.italic,
                fontSize: context.responsiveFont(11),
              ),
            )
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: state.gameHistory.map((g) {
                  final isSideAWinner = g.winner == PlayerSide.sideA;
                  return Container(
                    margin: EdgeInsets.only(right: ResponsiveHelper.w(8)),
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveHelper.w(10),
                      vertical: ResponsiveHelper.h(6),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSideAWinner
                            ? AppColors.error.withValues(alpha: 0.5)
                            : AppColors.primary.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'G${g.gameNumber}: ',
                          style: AppTypography.bodyXs.copyWith(
                            color: AppColors.mutedText,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${g.sideAScore} - ${g.sideBScore}',
                          style: AppTypography.bodySm.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
