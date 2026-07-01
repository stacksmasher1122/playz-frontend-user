import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../theme/app_colors.dart';
import '../../../../../../../theme/app_typography.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Tennis/live_scoring_controller.dart';

class LsPointActionsWidget extends StatelessWidget {
  const LsPointActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LiveScoringController>();

    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: controller.addPointPlayerA,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: AppColors.primaryContainer.withValues(alpha: 0.3), blurRadius: 10),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('POINT', style: AppTypography.labelCaps.copyWith(color: AppColors.onPrimaryContainer, fontSize: 10)),
                    const SizedBox(height: 4),
                    Text(
                      'REYES', // Will usually come from the model split (last name) but hardcoded here for layout match
                      style: AppTypography.headlineMd.copyWith(color: AppColors.onPrimaryContainer, fontWeight: FontWeight.w800, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: controller.addPointPlayerB,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primaryContainer, width: 2),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('POINT', style: AppTypography.labelCaps.copyWith(color: AppColors.primaryContainer, fontSize: 10)),
                    const SizedBox(height: 4),
                    Text(
                      'JENKINS',
                      style: AppTypography.headlineMd.copyWith(color: AppColors.primaryContainer, fontWeight: FontWeight.w800, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
