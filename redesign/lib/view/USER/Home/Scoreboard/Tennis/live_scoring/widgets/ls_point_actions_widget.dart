import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../theme/app_colors.dart';
import '../../../../../../../theme/app_typography.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Tennis/live_scoring_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';

class LsPointActionsWidget extends StatelessWidget {
  LsPointActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<LiveScoringController>();

    return Container(
      color: AppColors.background,
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16), vertical: ResponsiveHelper.h(12)),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: controller.addPointPlayerA,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(20)),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
                  boxShadow: [
                    BoxShadow(color: AppColors.accent.withValues(alpha: 0.3), blurRadius: 10),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('POINT', style: AppTypography.labelCaps.copyWith(color: AppColors.background, fontSize: 10)),
                    SizedBox(height: 4),
                    Text(
                      'REYES', // Will usually come from the model split (last name) but hardcoded here for layout match
                      style: AppTypography.headlineMd.copyWith(color: AppColors.background, fontWeight: FontWeight.w800, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: controller.addPointPlayerB,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(20)),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
                  border: Border.all(color: AppColors.accent, width: 2),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('POINT', style: AppTypography.labelCaps.copyWith(color: AppColors.accent, fontSize: 10)),
                    SizedBox(height: 4),
                    Text(
                      'JENKINS',
                      style: AppTypography.headlineMd.copyWith(color: AppColors.accent, fontWeight: FontWeight.w800, fontSize: 18),
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
