import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../theme/app_colors.dart';
import '../../../../../../../theme/app_typography.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Tennis/live_scoring_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';

class LsScoreboardCardWidget extends StatelessWidget {
  LsScoreboardCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<LiveScoringController>();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Obx(() {
        final stats = controller.matchStats.value;
        return Column(
          children: [
            _buildPlayerRow(
              name: stats.playerAName,
              rank: stats.playerARank,
              country: stats.playerACountry,
              sets: stats.playerASets,
              games: stats.playerAGames,
              points: stats.playerAPoints,
              isServing: stats.isPlayerAServing,
              isTopRow: true,
            ),
            Divider(color: Colors.white.withValues(alpha: 0.05), height: 1),
            _buildPlayerRow(
              name: stats.playerBName,
              rank: stats.playerBRank,
              country: stats.playerBCountry,
              sets: stats.playerBSets,
              games: stats.playerBGames,
              points: stats.playerBPoints,
              isServing: !stats.isPlayerAServing,
              isTopRow: false,
            ),
          ],
        );
      }),
    );
  }

  Widget _buildPlayerRow({
    required String name,
    required String rank,
    required String country,
    required int sets,
    required String games,
    required String points,
    required bool isServing,
    required bool isTopRow,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left neon indicator if serving
          Container(
            width: ResponsiveHelper.w(6),
            decoration: BoxDecoration(
              color: isServing ? AppColors.accent : Colors.transparent,
              borderRadius: isTopRow
                  ? BorderRadius.only(topLeft: Radius.circular(ResponsiveHelper.w(16)))
                  : BorderRadius.only(bottomLeft: Radius.circular(ResponsiveHelper.w(16))),
            ),
          ),
          
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(ResponsiveHelper.w(20.0)),
              child: Row(
                children: [
                  // Server icon placeholder
                  SizedBox(
                    width: ResponsiveHelper.w(32),
                    child: isServing 
                        ? Icon(Icons.sports_tennis, color: AppColors.accent)
                        : null,
                  ),
                  SizedBox(width: 8),
                  
                  // Name and info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          name,
                          style: AppTypography.headlineLg.copyWith(
                            color: isServing ? AppColors.accent : AppColors.muted,
                            fontWeight: FontWeight.w800,
                            height: ResponsiveHelper.h(1.1),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'RANK $rank | $country',
                          style: AppTypography.labelCaps.copyWith(color: AppColors.muted),
                        ),
                      ],
                    ),
                  ),
                  
                  // Score components
                  _buildScoreColumn('SET', sets.toString(), isServing),
                  SizedBox(width: 24),
                  _buildScoreColumn('GAMES', games, isServing),
                  SizedBox(width: 24),
                  
                  // Large points
                  SizedBox(
                    width: ResponsiveHelper.w(64),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        points,
                        style: TextStyle(
                          fontFamily: 'Sora',
                          fontSize: ResponsiveHelper.sp(48),
                          fontWeight: FontWeight.w900,
                          color: isServing ? AppColors.accent : AppColors.muted.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreColumn(String label, String value, bool isServing) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(label, style: AppTypography.labelCaps.copyWith(color: AppColors.muted, fontSize: 10)),
        SizedBox(height: 4),
        Text(
          value,
          style: AppTypography.headlineMd.copyWith(
            color: isServing ? AppColors.accent : AppColors.muted,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
