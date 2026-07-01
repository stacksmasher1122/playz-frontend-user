import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../theme/app_colors.dart';
import '../../../../../../../theme/app_typography.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Tennis/match_stats_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MsMatchStatsBarsWidget extends StatelessWidget {
  MsMatchStatsBarsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<MatchStatsController>();

    return Obx(() {
      final stats = controller.stats.value;
      if (stats == null) return SizedBox.shrink();

      return Container(
        padding: EdgeInsets.all(ResponsiveHelper.w(24)),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.02),
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'MATCH STATS',
              style: AppTypography.labelCaps.copyWith(color: AppColors.onSurfaceVariant, letterSpacing: 2.0),
            ),
            SizedBox(height: 32),
            
            _buildStatBar(
              label: 'ACES',
              val1: stats.p1Aces,
              val2: stats.p2Aces,
              color1: AppColors.primaryContainer,
              color2: AppColors.onSurfaceVariant,
            ),
            SizedBox(height: 24),
            _buildStatBar(
              label: 'D.FAULTS',
              val1: stats.p1DoubleFaults,
              val2: stats.p2DoubleFaults,
              color1: AppColors.onSurfaceVariant,
              color2: AppColors.error,
              reverse: true, // p2 had more, so they get the error color
            ),
            SizedBox(height: 24),
            _buildStatBar(
              label: 'WINNERS',
              val1: stats.p1Winners,
              val2: stats.p2Winners,
              color1: AppColors.primaryContainer,
              color2: AppColors.onSurfaceVariant,
            ),
            SizedBox(height: 24),
            _buildStatBar(
              label: 'U.ERRORS',
              val1: stats.p1UnforcedErrors,
              val2: stats.p2UnforcedErrors,
              color1: AppColors.onSurfaceVariant,
              color2: AppColors.error,
              reverse: true,
            ),
            SizedBox(height: 24),
            _buildStatBar(
              label: 'SERVE %',
              val1: stats.p1FirstServePercent,
              val2: stats.p2FirstServePercent,
              color1: AppColors.primaryContainer,
              color2: AppColors.onSurfaceVariant,
              isPercentage: true,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildStatBar({
    required String label,
    required num val1,
    required num val2,
    required Color color1,
    required Color color2,
    bool reverse = false,
    bool isPercentage = false,
  }) {
    final double total = (val1 + val2) == 0 ? 1.0 : (val1 + val2).toDouble();
    final double pct1 = val1 / total;
    final double pct2 = val2 / total;

    final str1 = isPercentage ? '${val1.toInt()}% SERVE' : '${val1.toInt()} $label';
    final str2 = isPercentage ? '${val2.toInt()}% SERVE' : '${val2.toInt()} $label';

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(str1, style: AppTypography.labelCaps.copyWith(color: color1, fontSize: 10)),
            Text(str2, style: AppTypography.labelCaps.copyWith(color: color2, fontSize: 10)),
          ],
        ),
        SizedBox(height: 8),
        Container(
          height: ResponsiveHelper.h(8),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(4)),
          ),
          child: Row(
            children: [
              Expanded(
                flex: (pct1 * 100).toInt(),
                child: Container(
                  decoration: BoxDecoration(
                    color: color1,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(ResponsiveHelper.w(4)), bottomLeft: Radius.circular(ResponsiveHelper.w(4))),
                    boxShadow: color1 == AppColors.primaryContainer 
                        ? [BoxShadow(color: AppColors.primaryContainer.withValues(alpha: 0.5), blurRadius: 8)] 
                        : null,
                  ),
                ),
              ),
              Expanded(
                flex: (pct2 * 100).toInt(),
                child: Container(
                  decoration: BoxDecoration(
                    color: color2,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(ResponsiveHelper.w(4)), bottomRight: Radius.circular(ResponsiveHelper.w(4))),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
