import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Badminton/match_stats_controller.dart';
import 'game_timeline_card.dart';

class GameTimelineSection extends StatelessWidget {
  const GameTimelineSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MatchStatsController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'GAME TIMELINE',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 16),
          Obx(() {
            return Column(
              children: controller.timeline.map((item) {
                return GameTimelineCard(timeline: item);
              }).toList(),
            );
          }),
        ],
      ),
    );
  }
}
