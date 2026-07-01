import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Badminton/match_stats_controller.dart';
import 'game_timeline_card.dart';
import 'package:redesign/theme/responsive_helper.dart';

class GameTimelineSection extends StatelessWidget {
  GameTimelineSection({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<MatchStatsController>();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16.0), vertical: ResponsiveHelper.h(12.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'GAME TIMELINE',
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.sp(14),
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
            ),
          ),
          SizedBox(height: 16),
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
