import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Badminton/match_stats_controller.dart';
import 'quick_stat_card.dart';
import 'service_points_card.dart';

class QuickStatsGrid extends StatelessWidget {
  const QuickStatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MatchStatsController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Obx(() {
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: QuickStatCard(
                    label: 'TOTAL POINTS\nWON',
                    value: controller.totalPoints.value.toString(),
                    valueColor: const Color(0xFFC6FF00), // Neon Yellow-Green
                    backgroundIcon: Icons.analytics_outlined,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: QuickStatCard(
                    label: 'LONGEST RALLY\n',
                    value: controller.longestRally.value.toString(),
                    suffix: 'SHOTS',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ServicePointsCard(
              percentage: controller.servicePercentage.value,
            ),
          ],
        );
      }),
    );
  }
}
