import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../theme/app_colors.dart';
import '../../../../../../../theme/app_typography.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Tennis/live_scoring_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';

class LsMatchStatsWidget extends StatelessWidget {
  LsMatchStatsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<LiveScoringController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'LIVE MATCH STATS',
          style: AppTypography.labelCaps.copyWith(color: AppColors.onSurfaceVariant, letterSpacing: 2.0),
        ),
        SizedBox(height: 24),
        
        Obx(() {
          final stats = controller.matchStats.value;
          return Column(
            children: [
              _buildStatRow(
                label: '1ST SERVE %',
                valA: '${stats.playerAFirstServePercent}%',
                valB: '${stats.playerBFirstServePercent}%',
                pctA: stats.playerAFirstServePercent / 100,
                pctB: stats.playerBFirstServePercent / 100,
              ),
              SizedBox(height: 24),
              _buildStatRow(
                label: 'ACES',
                valA: '${stats.playerAAces}',
                valB: '${stats.playerBAces}',
                pctA: stats.playerAAces / (stats.playerAAces + stats.playerBAces == 0 ? 1 : stats.playerAAces + stats.playerBAces),
                pctB: stats.playerBAces / (stats.playerAAces + stats.playerBAces == 0 ? 1 : stats.playerAAces + stats.playerBAces),
              ),
              SizedBox(height: 24),
              _buildStatRow(
                label: 'NET POINTS',
                valA: '${stats.playerANetPointsWon}/${stats.playerANetPointsTotal}',
                valB: '${stats.playerBNetPointsWon}/${stats.playerBNetPointsTotal}',
                pctA: stats.playerANetPointsTotal == 0 ? 0 : stats.playerANetPointsWon / stats.playerANetPointsTotal,
                pctB: stats.playerBNetPointsTotal == 0 ? 0 : stats.playerBNetPointsWon / stats.playerBNetPointsTotal,
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildStatRow({
    required String label,
    required String valA,
    required String valB,
    required double pctA,
    required double pctB,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(valA, style: AppTypography.headlineMd.copyWith(color: AppColors.primary, fontSize: 16)),
            Text(label, style: AppTypography.labelCaps.copyWith(color: AppColors.onSurfaceVariant)),
            Text(valB, style: AppTypography.headlineMd.copyWith(color: AppColors.primary, fontSize: 16)),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: FractionallySizedBox(
                  widthFactor: pctA.clamp(0.0, 1.0),
                  child: Container(
                    height: ResponsiveHelper.h(6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(ResponsiveHelper.w(3)),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: pctB.clamp(0.0, 1.0),
                  child: Container(
                    height: ResponsiveHelper.h(6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(ResponsiveHelper.w(3)),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
