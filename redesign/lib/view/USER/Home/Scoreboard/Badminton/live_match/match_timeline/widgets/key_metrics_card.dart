import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Badminton/match_timeline_controller.dart';
import 'metric_progress_widget.dart';
import 'package:redesign/theme/responsive_helper.dart';

class KeyMetricsCard extends StatelessWidget {
  KeyMetricsCard({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<MatchTimelineController>();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16.0), vertical: ResponsiveHelper.h(12.0)),
      padding: EdgeInsets.all(ResponsiveHelper.w(20)),
      decoration: BoxDecoration(
        color: Colors.grey.shade900.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Obx(() {
        final metrics = controller.metrics.value;
        if (metrics == null) return SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'KEY METRICS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.sp(12),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
                Icon(
                  Icons.trending_up,
                  color: Color(0xFFC6FF00), // Neon Yellow-Green
                  size: 16,
                ),
              ],
            ),
            SizedBox(height: 24),
            MetricProgressWidget(
              label: 'Match Duration',
              valueText: '${metrics.matchDuration}m',
              fillRatio: 0.85, // Mock value
            ),
            SizedBox(height: 12),
            MetricProgressWidget(
              label: 'Longest Rally',
              valueText: '${metrics.longestRally} Shots',
              fillRatio: 0.90, // Mock value
            ),
            SizedBox(height: 24),
            Divider(color: Colors.grey.shade800),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.bar_chart,
                  color: Colors.grey,
                  size: 14,
                ),
                SizedBox(width: 8),
                Text(
                  metrics.intensity,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: ResponsiveHelper.sp(10),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}
