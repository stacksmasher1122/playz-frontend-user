import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../theme/app_colors.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Tennis/live_scoring_controller.dart';
import 'widgets/ls_appbar_widget.dart';
import 'widgets/ls_match_duration_widget.dart';
import 'widgets/ls_scoreboard_card_widget.dart';
import 'widgets/ls_quick_action_grid_widget.dart';
import 'widgets/ls_match_stats_widget.dart';
import 'widgets/ls_point_actions_widget.dart';
import 'widgets/ls_bottom_nav_widget.dart';

class LiveScoringScreen extends StatefulWidget {
  const LiveScoringScreen({super.key});

  @override
  State<LiveScoringScreen> createState() => _LiveScoringScreenState();
}

class _LiveScoringScreenState extends State<LiveScoringScreen> {
  late final LiveScoringController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(LiveScoringController());
  }

  @override
  void dispose() {
    Get.delete<LiveScoringController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const LsAppbarWidget(),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const LsMatchDurationWidget(),
                    const SizedBox(height: 24),
                    
                    const LsScoreboardCardWidget(),
                    const SizedBox(height: 24),
                    
                    const LsQuickActionGridWidget(),
                    const SizedBox(height: 32),
                    
                    const LsMatchStatsWidget(),
                    
                    // Extra padding so bottom nav / actions don't cover content
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // Sticky bottom point actions just above the bottom nav
      bottomNavigationBar: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LsPointActionsWidget(),
          LsBottomNavWidget(),
        ],
      ),
    );
  }
}
