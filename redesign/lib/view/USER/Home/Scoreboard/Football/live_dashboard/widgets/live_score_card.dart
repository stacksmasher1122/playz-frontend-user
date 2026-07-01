import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Football/live_football_dashboard_controller.dart';
import 'team_score_widget.dart';
import 'match_timer_widget.dart';
import 'score_board_widget.dart';

class LiveScoreCard extends StatelessWidget {
  const LiveScoreCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LiveFootballDashboardController>();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade900.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Obx(() {
        final match = controller.match.value;
        if (match == null) return const SizedBox.shrink();

        return Column(
          children: [
            MatchTimerWidget(
              currentHalf: controller.currentHalf.value,
              currentMinute: controller.currentMinute.value,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TeamScoreWidget(
                  teamName: match.teamAName,
                  logoUrl: match.teamALogo,
                ),
                ScoreBoardWidget(
                  scoreA: controller.scoreA.value,
                  scoreB: controller.scoreB.value,
                ),
                TeamScoreWidget(
                  teamName: match.teamBName,
                  logoUrl: match.teamBLogo,
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}
