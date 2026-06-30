import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Badminton/match_timeline_controller.dart';
import 'metric_progress_widget.dart';

class KeyMetricsCard extends StatelessWidget {
  const KeyMetricsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MatchTimelineController>();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade900.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Obx(() {
        final metrics = controller.metrics.value;
        if (metrics == null) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'KEY METRICS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
                Icon(
                  Icons.trending_up,
                  color: const Color(0xFFC6FF00), // Neon Yellow-Green
                  size: 16,
                ),
              ],
            ),
            const SizedBox(height: 24),
            MetricProgressWidget(
              label: 'Match Duration',
              valueText: '${metrics.matchDuration}m',
              fillRatio: 0.85, // Mock value
            ),
            const SizedBox(height: 12),
            MetricProgressWidget(
              label: 'Longest Rally',
              valueText: '${metrics.longestRally} Shots',
              fillRatio: 0.90, // Mock value
            ),
            const SizedBox(height: 24),
            Divider(color: Colors.grey.shade800),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(
                  Icons.bar_chart,
                  color: Colors.grey,
                  size: 14,
                ),
                const SizedBox(width: 8),
                Text(
                  metrics.intensity,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
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
