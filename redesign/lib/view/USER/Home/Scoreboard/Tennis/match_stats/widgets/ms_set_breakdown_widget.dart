import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../theme/app_colors.dart';
import '../../../../../../../theme/app_typography.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Tennis/match_stats_controller.dart';
import '../../../../../../../model/User_Models/Home_Models/Scoreboard_Model/Tennis/match_stats_model.dart';

class MsSetBreakdownWidget extends StatelessWidget {
  const MsSetBreakdownWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MatchStatsController>();

    return Obx(() {
      final stats = controller.stats.value;
      if (stats == null) return const SizedBox.shrink();

      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.02),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SET BREAKDOWN',
              style: AppTypography.labelCaps.copyWith(color: AppColors.onSurfaceVariant, letterSpacing: 2.0),
            ),
            const SizedBox(height: 24),
            ...stats.setBreakdowns.map((set) => _buildSetRow(set)),
          ],
        ),
      );
    });
  }

  Widget _buildSetRow(SetBreakdownModel setModel) {
    final bool isS3 = setModel.setNumber == 3;
    final bgColor = AppColors.surfaceContainerHigh.withValues(alpha: 0.5);
    final borderColor = isS3 ? AppColors.primaryContainer.withValues(alpha: 0.5) : Colors.white.withValues(alpha: 0.05);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
        boxShadow: isS3 ? [BoxShadow(color: AppColors.primaryContainer.withValues(alpha: 0.1), blurRadius: 10)] : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                'S${setModel.setNumber}',
                style: AppTypography.headlineMd.copyWith(
                  color: setModel.isP1Winner ? AppColors.primaryContainer : AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${setModel.p1Score} — ${setModel.p2Score}',
                    style: AppTypography.headlineMd.copyWith(color: AppColors.primary, fontSize: 18),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'DURATION: ${setModel.duration}',
                    style: AppTypography.labelCaps.copyWith(color: AppColors.onSurfaceVariant, fontSize: 10),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: setModel.isMatchPoint ? AppColors.primaryContainer : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: setModel.isMatchPoint ? Colors.transparent : (setModel.isP1Winner ? AppColors.primaryContainer.withValues(alpha: 0.5) : AppColors.onSurfaceVariant.withValues(alpha: 0.5))),
            ),
            child: Text(
              setModel.keyInsight,
              style: AppTypography.labelCaps.copyWith(
                color: setModel.isMatchPoint ? AppColors.onPrimaryContainer : (setModel.isP1Winner ? AppColors.primaryContainer : AppColors.onSurfaceVariant),
                fontSize: 9,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
