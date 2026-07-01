import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../theme/app_colors.dart';
import '../../../../../../../theme/app_typography.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Tennis/match_stats_controller.dart';

class MsHeroHeaderWidget extends StatelessWidget {
  const MsHeroHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MatchStatsController>();

    return Obx(() {
      final stats = controller.stats.value;
      if (stats == null) return const SizedBox.shrink();

      return Container(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.02),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Column(
          children: [
            // Player 1
            Column(
              children: [
                Text(
                  'PLAYER 1',
                  style: AppTypography.labelCaps.copyWith(color: AppColors.primaryContainer),
                ),
                const SizedBox(height: 4),
                Text(
                  stats.player1Name,
                  style: AppTypography.headlineLg.copyWith(color: AppColors.primary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildBadge(stats.player1Country),
                    const SizedBox(width: 8),
                    _buildBadge(stats.player1Rank),
                  ],
                ),
              ],
            ),
            
            // Score
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        stats.player1SetsWon.toString(),
                        style: const TextStyle(fontFamily: 'Sora', fontSize: 64, fontWeight: FontWeight.w800, color: AppColors.primaryContainer, height: 1),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          ':',
                          style: TextStyle(fontFamily: 'Sora', fontSize: 64, fontWeight: FontWeight.w800, color: AppColors.surfaceContainerHighest, height: 1),
                        ),
                      ),
                      Text(
                        stats.player2SetsWon.toString(),
                        style: const TextStyle(fontFamily: 'Sora', fontSize: 64, fontWeight: FontWeight.w800, color: AppColors.onSurface, height: 1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: AppColors.primaryContainer.withValues(alpha: 0.2)),
                    ),
                    child: Text(
                      'MATCH COMPLETED',
                      style: AppTypography.labelCaps.copyWith(color: AppColors.primaryContainer, fontSize: 10),
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
                  style: AppTypography.labelCaps.copyWith(color: AppColors.onSurfaceVariant),
                ),
                const SizedBox(height: 4),
                Text(
                  stats.player2Name,
                  style: AppTypography.headlineLg.copyWith(color: AppColors.onSurfaceVariant),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildBadge(stats.player2Country),
                    const SizedBox(width: 8),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: AppTypography.labelCaps.copyWith(color: AppColors.primary, fontSize: 10),
      ),
    );
  }
}
