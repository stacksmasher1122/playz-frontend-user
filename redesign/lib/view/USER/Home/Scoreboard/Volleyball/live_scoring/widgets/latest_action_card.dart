import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Volleyball/volleyball_live_scoring_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';

class LatestActionCard extends StatelessWidget {
  final VolleyballLiveScoringController controller;

  LatestActionCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Obx(() {
      if (controller.latestActions.isEmpty) return SizedBox.shrink();

      String latest = controller.latestActions.first;
      List<String> parts = latest.split(" - ");
      String time = parts[0];
      String action = parts.length > 1 ? parts[1] : "";

      return Container(
        padding: EdgeInsets.all(ResponsiveHelper.w(20)),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
          border: Border.all(color: AppColors.surfaceContainerHighest),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('LATEST ACTION', style: AppTypography.labelCaps10.copyWith(color: AppColors.muted, letterSpacing: 1.5)),
                Text(time, style: AppTypography.labelCaps10.copyWith(color: AppColors.primaryContainer, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(ResponsiveHelper.w(8)),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.sports_volleyball, color: AppColors.primaryContainer, size: 24),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        action,
                        style: AppTypography.headlineSm.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
