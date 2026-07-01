import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Badminton/match_stats_controller.dart';
import 'widgets/quick_stats_grid.dart';
import 'widgets/performance_metrics_card.dart';
import 'widgets/point_distribution_card.dart';
import 'widgets/game_timeline_section.dart';
import 'widgets/dominance_card.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MatchStatsScreen extends StatefulWidget {
  MatchStatsScreen({super.key});

  @override
  State<MatchStatsScreen> createState() => _MatchStatsScreenState();
}

class _MatchStatsScreenState extends State<MatchStatsScreen> {
  late final MatchStatsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(MatchStatsController());
    controller.loadStatistics();
    controller.loadPerformanceMetrics();
    controller.loadTimeline();
    controller.loadPointDistribution();
  }

  @override
  void dispose() {
    // Controller is managed by GetX, but we could delete it if not needed
    // However, it's better to let parent manage it or keep it alive while screen is in IndexedStack
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: CircularProgressIndicator(
            color: Color(0xFFC6FF00), // Neon Yellow-Green
          ),
        );
      }

      return SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 16),
            QuickStatsGrid(),
            PerformanceMetricsCard(),
            PointDistributionCard(),
            GameTimelineSection(),
            DominanceCard(),
            SizedBox(height: 24), // Bottom padding before bottom nav
          ],
        ),
      );
    });
  }
}
