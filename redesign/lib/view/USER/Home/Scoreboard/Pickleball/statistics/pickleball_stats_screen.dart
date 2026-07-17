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
import 'package:redesign/theme/responsive_helper.dart';

class PickleballStatsScreen extends StatefulWidget {
  PickleballStatsScreen({super.key});

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
    
    _barAnimController = AnimationController(vsync: this, duration: Duration(milliseconds: 1200));
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
    ResponsiveHelper.init(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: LiveMatchAppbar(), // Reusing shared app bar
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(ResponsiveHelper.w(16.0)),
          child: Obx(() {
            if (controller.statsModel.value.matchId.isEmpty) return SizedBox.shrink();
            final model = controller.statsModel.value;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ScoreSummaryCard(controller: controller),
                SizedBox(height: 24),
                MatchStatisticsCard(
                  statistics: model.statistics,
                  barAnimController: _barAnimController,
                ),
                SizedBox(height: 24),
                ErrorBreakdownCard(errors: model.errors),
                SizedBox(height: 24),
                MvpAnalysisCard(),
                SizedBox(height: 24),
                GameBreakdownCard(controller: controller),
                SizedBox(height: 24),
                HeatmapWidget(),
                SizedBox(height: 24),
                PlayerComparisonWidget(),
                SizedBox(height: 24),
                AdvancedAnalyticsCard(),
                SizedBox(height: 24),
                CoachInsightWidget(insights: model.coachInsights),
                SizedBox(height: 32),
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
            Get.snackbar("Navigation", "Navigating to tab $index", backgroundColor: AppColors.card, colorText: AppColors.accent);
          }
        },
      ),
    );
  }
}
