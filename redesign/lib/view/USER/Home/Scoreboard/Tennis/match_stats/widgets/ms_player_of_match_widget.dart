import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../theme/app_colors.dart';
import '../../../../../../../theme/app_typography.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Tennis/match_stats_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';


class MsPlayerOfMatchWidget extends StatelessWidget {
  MsPlayerOfMatchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MatchStatsController>();

    return Obx(() {
      final stats = controller.stats.value;
      if (stats == null) return SizedBox.shrink();

      return Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.02),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primaryContainer, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(14), topRight: Radius.circular(14)),
                image: DecorationImage(
                  image: NetworkImage(stats.player1Image),
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
            
            Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PLAYER OF THE MATCH',
                            style: AppTypography.labelCaps.copyWith(color: AppColors.primaryContainer, fontSize: 10),
                          ),
                          SizedBox(height: ResponsiveHelper.h(4)),
                          Text(
                            stats.player1Name,
                            style: AppTypography.headlineMd.copyWith(color: AppColors.primary),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.emoji_events, color: AppColors.primaryContainer, size: 24),
                          SizedBox(width: ResponsiveHelper.w(8)),
                          Icon(Icons.star, color: AppColors.primaryContainer, size: 24),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: ResponsiveHelper.h(24)),
                  
                  // AI Insight
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerHigh.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.smart_toy, color: AppColors.primaryContainer, size: 16),
                            SizedBox(width: ResponsiveHelper.w(8)),
                            Text('AI INSIGHT SUMMARY', style: AppTypography.labelCaps.copyWith(color: AppColors.primaryContainer, fontSize: 9)),
                          ],
                        ),
                        SizedBox(height: ResponsiveHelper.h(8)),
                        Text(
                          stats.mvpInsight,
                          style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.h(16)),
                  
                  // Tags
                  Row(
                    children: [
                      _buildTag(Icons.bolt, 'CLUTCH PERFORMER'),
                      SizedBox(width: ResponsiveHelper.w(8)),
                      _buildTag(Icons.speed, '220 KM/H SERVE'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTag(IconData icon, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 12),
          SizedBox(width: ResponsiveHelper.w(4)),
          Text(label, style: AppTypography.labelCaps.copyWith(color: AppColors.primary, fontSize: 9)),
        ],
      ),
    );
  }
}
