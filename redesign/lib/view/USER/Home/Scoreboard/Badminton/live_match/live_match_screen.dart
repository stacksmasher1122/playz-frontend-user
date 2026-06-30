import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Badminton/live_match_controller.dart';
import 'widgets/live_match_appbar.dart';
import 'widgets/scoreboard_widget.dart';
import 'widgets/court_visualization_widget.dart';
import 'widgets/recent_points_widget.dart';
import 'widgets/action_toolbar_widget.dart';
import 'widgets/quick_score_panel.dart';
import 'widgets/bottom_navigation_widget.dart';
import 'match_stats/match_stats_screen.dart';
import 'match_timeline/match_timeline_screen.dart';
import 'match_timeline/widgets/match_timeline_appbar.dart';

class LiveMatchScreen extends StatefulWidget {
  const LiveMatchScreen({super.key});

  @override
  State<LiveMatchScreen> createState() => _LiveMatchScreenState();
}

class _LiveMatchScreenState extends State<LiveMatchScreen> {
  late final LiveMatchController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(LiveMatchController());
    controller.loadMatch();
    controller.startTimer();
  }

  @override
  void dispose() {
    // Controller cleans up its own timer in onClose()
    Get.delete<LiveMatchController>();
    super.dispose();
  }

  void _showEndMatchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: const Text('End Match?', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Are you sure you want to end this match prematurely?',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              controller.endMatch(context);
            },
            child: Text('End Match', style: TextStyle(color: Colors.red.shade400)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: Colors.black, // Dark background fallback
        appBar: controller.selectedTabIndex.value == 2
            ? const MatchTimelineAppbar()
            : const LiveMatchAppbar(),
        body: _buildBody(),
        bottomNavigationBar: const BottomNavigationWidget(),
      );
    });
  }

  Widget _buildBody() {
    if (controller.isLoading.value) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFFC6FF00), // Neon Yellow-Green
        ),
      );
    }

    return IndexedStack(
      index: controller.selectedTabIndex.value,
      children: [
        // Tab 0: Scoring
        Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const ScoreboardWidget(),
                    const CourtVisualizationWidget(),
                    const RecentPointsWidget(),
                    ActionToolbarWidget(
                      onUndo: controller.undoPoint,
                      onPause: () {
                        if (controller.isPaused.value) {
                          controller.resumeMatch();
                        } else {
                          controller.pauseMatch();
                        }
                      },
                      onEndMatch: _showEndMatchDialog,
                      isPaused: controller.isPaused.value,
                    ),
                    const QuickScorePanel(),
                    const SizedBox(height: 24), // Bottom padding
                  ],
                ),
              ),
            ),
          ],
        ),
        // Tab 1: Stats
        const MatchStatsScreen(),
        // Tab 2: Timeline
        const MatchTimelineScreen(),
        // Tab 3: More (Placeholder)
        const Center(
          child: Text(
            'Placeholder for More Tab',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
