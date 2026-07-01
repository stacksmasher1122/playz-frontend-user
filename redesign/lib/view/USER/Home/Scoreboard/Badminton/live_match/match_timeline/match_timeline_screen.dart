import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Badminton/match_timeline_controller.dart';
import 'widgets/winner_summary_card.dart';
import 'widgets/key_metrics_card.dart';
import 'widgets/player_of_match_card.dart';
import 'widgets/achievement_section.dart';
import 'widgets/action_button_grid.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MatchTimelineScreen extends StatefulWidget {
  MatchTimelineScreen({super.key});

  @override
  State<MatchTimelineScreen> createState() => _MatchTimelineScreenState();
}

class _MatchTimelineScreenState extends State<MatchTimelineScreen> {
  late final MatchTimelineController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(MatchTimelineController());
    controller.loadMatchResult();
    controller.loadWinner();
    controller.loadAchievements();
    controller.loadMetrics();
  }

  @override
  void dispose() {
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
            WinnerSummaryCard(),
            KeyMetricsCard(),
            Obx(() {
              // We could store full object in Rx or individual fields. Let's use static mock data for Player of Match here
              // The requirements specified these static mock values in the controller loadWinner section or directly here
              return PlayerOfMatchCard(
                playerName: 'VIKTOR AXELSEN',
                description: 'Dominant performance with consistent precision. Maintained 94% smash accuracy in the final set.',
                winStreak: '12-0',
                tournamentRank: '#1',
                formRating: 4, // 4 out of 5
              );
            }),
            AchievementSection(),
            ActionButtonGrid(),
            SizedBox(height: 24), // Bottom padding before bottom nav
          ],
        ),
      );
    });
  }
}
