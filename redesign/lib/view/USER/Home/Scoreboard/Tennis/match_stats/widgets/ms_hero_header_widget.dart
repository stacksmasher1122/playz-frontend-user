import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../theme/app_colors.dart';
import '../../../../../../../theme/app_typography.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Tennis/match_stats_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MsHeroHeaderWidget extends StatelessWidget {
  MsHeroHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<MatchStatsController>();

    return Obx(() {
      final stats = controller.stats.value;
      if (stats == null) return SizedBox.shrink();

      return Container(
        padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(32), horizontal: ResponsiveHelper.w(16)),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.02),
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Column(
          children: [
            // Player 1
            Column(
              children: [
                Text(
                  'PLAYER 1',
                  style: AppTypography.labelCaps.copyWith(color: AppColors.accent),
                ),
                SizedBox(height: 4),
                Text(
                  stats.player1Name,
                  style: AppTypography.headlineLg.copyWith(color: AppColors.accent),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildBadge(stats.player1Country),
                    SizedBox(width: 8),
                    _buildBadge(stats.player1Rank),
                  ],
                ),
              ],
            ),
            
            // Score
            Padding(
              padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(24)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        stats.player1SetsWon.toString(),
                        style: TextStyle(fontFamily: 'Sora', fontSize: ResponsiveHelper.sp(64), fontWeight: FontWeight.w800, color: AppColors.accent, height: 1),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
                        child: Text(
                          ':',
                          style: TextStyle(fontFamily: 'Sora', fontSize: ResponsiveHelper.sp(64), fontWeight: FontWeight.w800, color: AppColors.outlineVariant, height: 1),
                        ),
                      ),
                      Text(
                        stats.player2SetsWon.toString(),
                        style: TextStyle(fontFamily: 'Sora', fontSize: ResponsiveHelper.sp(64), fontWeight: FontWeight.w800, color: AppColors.onPrimary, height: 1),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16), vertical: ResponsiveHelper.h(8)),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(ResponsiveHelper.w(30)),
                      border: Border.all(color: AppColors.accent.withValues(alpha: 0.2)),
                    ),
                    child: Text(
                      'MATCH COMPLETED',
                      style: AppTypography.labelCaps.copyWith(color: AppColors.accent, fontSize: 10),
                    ),
                  ),
                ],
              ),
            ),
            
            // Player 2
            Column(
              children: [
                Text(
                  'PLAYER 2',
                  style: AppTypography.labelCaps.copyWith(color: AppColors.muted),
                ),
                SizedBox(height: 4),
                Text(
                  stats.player2Name,
                  style: AppTypography.headlineLg.copyWith(color: AppColors.muted),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildBadge(stats.player2Country),
                    SizedBox(width: 8),
                    _buildBadge(stats.player2Rank),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildBadge(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(8), vertical: ResponsiveHelper.h(4)),
      decoration: BoxDecoration(
        color: AppColors.outlineVariant,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(4)),
      ),
      child: Text(
        text,
        style: AppTypography.labelCaps.copyWith(color: AppColors.accent, fontSize: 10),
      ),
    );
  }
}
