import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Pickleball/pickleball_stats_controller.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Pickleball/live_match/widgets/live_match_appbar.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Pickleball/live_match/widgets/live_bottom_navigation.dart';
import 'widgets/score_summary_card.dart';
import 'widgets/match_statistics_card.dart';
import 'widgets/error_breakdown_card.dart';
import 'widgets/mvp_analysis_card.dart';
import 'widgets/game_breakdown_card.dart';
import 'widgets/heatmap_widget.dart';
import 'widgets/player_comparison_widget.dart';
import 'widgets/advanced_analytics_card.dart';
import 'widgets/coach_insight_widget.dart';

class PickleballStatsScreen extends StatefulWidget {
  const PickleballStatsScreen({super.key});

  @override
  State<PickleballStatsScreen> createState() => _PickleballStatsScreenState();
}

class _PickleballStatsScreenState extends State<PickleballStatsScreen> with TickerProviderStateMixin {
  late final PickleballStatsController controller;
  late AnimationController _barAnimController;

  @override
  void initState() {
    super.initState();
    controller = Get.put(PickleballStatsController());
    
    _barAnimController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _barAnimController.forward();
  }

  @override
  void dispose() {
    _barAnimController.dispose();
    Get.delete<PickleballStatsController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const LiveMatchAppbar(), // Reusing shared app bar
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() {
            if (controller.statsModel.value.matchId.isEmpty) return const SizedBox.shrink();
            final model = controller.statsModel.value;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ScoreSummaryCard(controller: controller),
                const SizedBox(height: 24),
                MatchStatisticsCard(
                  statistics: model.statistics,
                  barAnimController: _barAnimController,
                ),
                const SizedBox(height: 24),
                ErrorBreakdownCard(errors: model.errors),
                const SizedBox(height: 24),
                const MvpAnalysisCard(),
                const SizedBox(height: 24),
                GameBreakdownCard(controller: controller),
                const SizedBox(height: 24),
                const HeatmapWidget(),
                const SizedBox(height: 24),
                const PlayerComparisonWidget(),
                const SizedBox(height: 24),
                const AdvancedAnalyticsCard(),
                const SizedBox(height: 24),
                CoachInsightWidget(insights: model.coachInsights),
                const SizedBox(height: 32),
              ],
            );
          }),
        ),
      ),
      bottomNavigationBar: LiveBottomNavigation(
        selectedIndex: 1, // Stats tab
        onTabSelected: (index) {
          if (index == 0) {
            Navigator.pop(context); // Go back to scoring if they came from there
          } else {
            Get.snackbar("Navigation", "Navigating to tab $index", backgroundColor: AppColors.surfaceContainerHigh, colorText: AppColors.primary);
          }
        },
      ),
    );
  }
}
