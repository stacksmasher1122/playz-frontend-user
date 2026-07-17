import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Volleyball/volleyball_stats_controller.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Volleyball/live_scoring/widgets/bottom_navigation.dart';

import 'widgets/match_score_header.dart';
import 'widgets/momentum_chart.dart';
import 'widgets/team_statistics_card.dart';
import 'widgets/top_scorer_card.dart';
import 'widgets/timeline_card.dart';
import 'widgets/match_insight_card.dart';

class VolleyballStatsScreen extends StatefulWidget {
  VolleyballStatsScreen({super.key});

  @override
  State<VolleyballStatsScreen> createState() => _VolleyballStatsScreenState();
}

class _VolleyballStatsScreenState extends State<VolleyballStatsScreen> {
  late VolleyballStatsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(VolleyballStatsController());
  }

  @override
  void dispose() {
    Get.delete<VolleyballStatsController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF111111),
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.accent),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Icon(Icons.sports_volleyball, color: AppColors.accent),
            SizedBox(width: 8),
            Text('PLAYZ SCOREBOARD', style: AppTypography.headlineMd.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                ),
                SizedBox(width: 8),
                Text('LIVE', style: AppTypography.labelCaps10.copyWith(color: AppColors.error, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          SizedBox(width: 16),
          Icon(Icons.account_circle, color: AppColors.muted),
          SizedBox(width: 16),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator(color: AppColors.accent));
        }

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 600),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MatchScoreHeader(controller: controller),
                        SizedBox(height: 32),
                        
                        MomentumChart(controller: controller),
                        SizedBox(height: 32),
                        
                        TeamStatisticsCard(controller: controller),
                        SizedBox(height: 32),
                        
                        TopScorerCard(controller: controller),
                        SizedBox(height: 32),
                        
                        TimelineCard(controller: controller),
                        SizedBox(height: 32),
                        
                        MatchInsightCard(controller: controller),
                        SizedBox(height: 48), // Padding before nav
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Fixed Bottom Navigation - hardcoded to index 2 (Stats)
            BottomNavigation(selectedIndex: 2),
          ],
        );
      }),
    );
  }
}
