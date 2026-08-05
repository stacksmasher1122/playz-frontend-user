import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Squash/squash_state_models.dart';

class SquashScoreDisplay extends StatelessWidget {
  final SquashMatchState state;
  final Function(PlayerSide) onScoreRally;
  final Function(ServeBox) onSelectServeBox;
  final VoidCallback onSwitchServeBox;
  final Function(int) onSelectHihoDeuceOption;

  const SquashScoreDisplay({
    super.key,
    required this.state,
    required this.onScoreRally,
    required this.onSelectServeBox,
    required this.onSwitchServeBox,
    required this.onSelectHihoDeuceOption,
  });

  @override
  Widget build(BuildContext context) {
    String sideAName = state.teamA.isNotEmpty ? state.teamA.first.name : 'Side A';
    String sideBName = state.teamB.isNotEmpty ? state.teamB.first.name : 'Side B';

    if (state.config.isDoubles) {
      if (state.teamA.length >= 2) {
        sideAName = '${state.teamA[0].name} & ${state.teamA[1].name}';
      }
      if (state.teamB.length >= 2) {
        sideBName = '${state.teamB[0].name} & ${state.teamB[1].name}';
      }
    }

    final isServerA = state.currentServer == PlayerSide.sideA;
    final isServerB = state.currentServer == PlayerSide.sideB;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Deuce Banner for HIHO at 8-8 (Responsive Wrap)
        if (state.isDeuceChoicePending)
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(bottom: ResponsiveHelper.h(8)),
            padding: EdgeInsets.all(ResponsiveHelper.w(10)),
            decoration: BoxDecoration(
              color: AppColors.coinsGold.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
              border: Border.all(color: AppColors.coinsGold, width: 1),
            ),
            child: Column(
              children: [
                Text(
                  'DEUCE CHOICE AT 8-8',
                  style: AppTypography.labelCaps.copyWith(
                    color: AppColors.coinsGold,
                    fontSize: context.responsiveFont(11),
                  ),
                ),
                SizedBox(height: ResponsiveHelper.h(4)),
                Text(
                  'Receiver chooses match length (Set 1 to 9 vs Set 2 to 10):',
                  style: AppTypography.bodyXs.copyWith(color: AppColors.textPrimary),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: ResponsiveHelper.h(6)),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.surfaceElevated,
                        foregroundColor: AppColors.primaryGreen,
                        side: const BorderSide(color: AppColors.primaryGreen),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      ),
                      onPressed: () => onSelectHihoDeuceOption(9),
                      child: const Text('Set 1 (Play to 9)'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      ),
                      onPressed: () => onSelectHihoDeuceOption(10),
                      child: const Text('Set 2 (Play to 10 - Sudden Death)'),
                    ),
                  ],
                ),
              ],
            ),
          ),

        // 2. Main Live Scoreboard Display Card
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.w(12),
            vertical: ResponsiveHelper.h(14),
          ),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
            border: Border.all(color: AppColors.borderDark, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Side A Score Box
              Expanded(
                child: _buildSideScoreBox(
                  context: context,
                  sideName: sideAName,
                  score: state.sideAPointScore,
                  gamesWon: state.sideAGamesWon,
                  isServer: isServerA,
                  serveBox: state.currentServeBox,
                  accentColor: AppColors.error,
                  onTapScore: () => onScoreRally(PlayerSide.sideA),
                  onSelectBox: onSelectServeBox,
                ),
              ),

              // VS Divider & Game Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(6)),
                child: Column(
                  children: [
                    Text(
                      'VS',
                      style: AppTypography.headlineSm.copyWith(
                        color: AppColors.mutedText,
                        fontSize: context.responsiveFont(12),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.h(6)),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelper.w(8),
                        vertical: ResponsiveHelper.h(3),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
                        border: Border.all(color: AppColors.borderDark),
                      ),
                      child: Text(
                        'Game ${state.currentGameIndex}',
                        style: AppTypography.labelCaps.copyWith(
                          color: AppColors.primaryGreen,
                          fontSize: context.responsiveFont(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Side B Score Box
              Expanded(
                child: _buildSideScoreBox(
                  context: context,
                  sideName: sideBName,
                  score: state.sideBPointScore,
                  gamesWon: state.sideBGamesWon,
                  isServer: isServerB,
                  serveBox: state.currentServeBox,
                  accentColor: AppColors.primary,
                  onTapScore: () => onScoreRally(PlayerSide.sideB),
                  onSelectBox: onSelectServeBox,
                ),
              ),
            ],
          ),
        ),

        // 3. WSF Rule 4.2 Initial Box Selector Banner (Only in Pro Mode)
        if (state.mustSelectServeBox && !state.config.isFriendlyRules)
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: ResponsiveHelper.h(8)),
            padding: EdgeInsets.all(ResponsiveHelper.w(10)),
            decoration: BoxDecoration(
              color: AppColors.surfaceEmerald,
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
              border: Border.all(color: AppColors.primaryGreen),
            ),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 6,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.sports_handball, color: AppColors.primaryGreen, size: 18),
                    SizedBox(width: ResponsiveHelper.w(6)),
                    Text(
                      'WSF Rule 4.2: Select Serving Box:',
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: context.responsiveFont(11),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: state.currentServeBox == ServeBox.left
                            ? AppColors.primaryGreen
                            : AppColors.card,
                        foregroundColor: state.currentServeBox == ServeBox.left
                            ? Colors.black
                            : AppColors.textPrimary,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      ),
                      onPressed: () => onSelectServeBox(ServeBox.left),
                      child: const Text('LEFT (L)'),
                    ),
                    SizedBox(width: ResponsiveHelper.w(6)),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: state.currentServeBox == ServeBox.right
                            ? AppColors.primaryGreen
                            : AppColors.card,
                        foregroundColor: state.currentServeBox == ServeBox.right
                            ? Colors.black
                            : AppColors.textPrimary,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      ),
                      onPressed: () => onSelectServeBox(ServeBox.right),
                      child: const Text('RIGHT (R)'),
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildSideScoreBox({
    required BuildContext context,
    required String sideName,
    required int score,
    required int gamesWon,
    required bool isServer,
    required ServeBox serveBox,
    required Color accentColor,
    required VoidCallback onTapScore,
    required Function(ServeBox) onSelectBox,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.w(8),
        vertical: ResponsiveHelper.h(10),
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        border: Border.all(
          color: isServer ? accentColor : AppColors.borderDark,
          width: isServer ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          // Server Status & 1-Tap Direct Box Badges
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isServer) ...[
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.w(6),
                    vertical: ResponsiveHelper.h(2),
                  ),
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'SERVE',
                    style: AppTypography.labelCaps.copyWith(
                      color: Colors.black,
                      fontSize: context.responsiveFont(9),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(4)),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => onSelectBox(ServeBox.left),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color: serveBox == ServeBox.left ? accentColor : AppColors.cardDark,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: accentColor),
                        ),
                        child: Text(
                          'L',
                          style: TextStyle(
                            color: serveBox == ServeBox.left ? Colors.black : accentColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 3),
                    GestureDetector(
                      onTap: () => onSelectBox(ServeBox.right),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color: serveBox == ServeBox.right ? accentColor : AppColors.cardDark,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: accentColor),
                        ),
                        child: Text(
                          'R',
                          style: TextStyle(
                            color: serveBox == ServeBox.right ? Colors.black : accentColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ] else
                const SizedBox(height: 18),
            ],
          ),
          SizedBox(height: ResponsiveHelper.h(4)),

          // Big Point Score Display (Tap to score +1)
          GestureDetector(
            onTap: onTapScore,
            child: Text(
              '$score',
              style: AppTypography.displayScoreSora.copyWith(
                color: isServer ? AppColors.textPrimary : AppColors.textSecondary,
                fontSize: context.responsiveFont(54),
                fontWeight: FontWeight.bold,
                height: 1.0,
              ),
            ),
          ),
          SizedBox(height: ResponsiveHelper.h(6)),

          // Player/Side Name
          Text(
            sideName,
            style: AppTypography.headlineSm.copyWith(
              color: AppColors.textPrimary,
              fontSize: context.responsiveFont(12),
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: ResponsiveHelper.h(4)),

          // Games Won Pill
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.w(8),
              vertical: ResponsiveHelper.h(2),
            ),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Games: $gamesWon',
              style: AppTypography.bodyXs.copyWith(
                color: AppColors.mutedText,
                fontSize: context.responsiveFont(11),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
