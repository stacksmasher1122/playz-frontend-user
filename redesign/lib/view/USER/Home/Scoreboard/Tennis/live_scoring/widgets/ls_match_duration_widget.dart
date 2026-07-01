import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../theme/app_colors.dart';
import '../../../../../../../theme/app_typography.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Tennis/live_scoring_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';

class LsMatchDurationWidget extends StatelessWidget {
  LsMatchDurationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<LiveScoringController>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'MATCH DURATION',
              style: AppTypography.labelCaps.copyWith(color: AppColors.onSurfaceVariant),
            ),
            SizedBox(height: 4),
            Obx(() => Text(
              controller.matchStats.value.duration,
              style: AppTypography.headlineLg.copyWith(color: AppColors.primary),
            )),
          ],
        ),
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16), vertical: ResponsiveHelper.h(8)),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
              child: Row(
                children: [
                  Icon(Icons.pause, color: AppColors.onSurfaceVariant, size: 16),
                  SizedBox(width: 8),
                  Text('PAUSE', style: AppTypography.labelCaps.copyWith(color: AppColors.onSurfaceVariant)),
                ],
              ),
            ),
            SizedBox(width: 12),
            Container(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16), vertical: ResponsiveHelper.h(8)),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
              child: Row(
                children: [
                  Icon(Icons.undo, color: AppColors.onSurfaceVariant, size: 16),
                  SizedBox(width: 8),
                  Text('UNDO', style: AppTypography.labelCaps.copyWith(color: AppColors.onSurfaceVariant)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
