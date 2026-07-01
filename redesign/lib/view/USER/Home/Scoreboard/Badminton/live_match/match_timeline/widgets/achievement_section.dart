import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Badminton/match_timeline_controller.dart';
import 'achievement_card.dart';
import 'package:redesign/theme/responsive_helper.dart';

class AchievementSection extends StatelessWidget {
  AchievementSection({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<MatchTimelineController>();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16.0), vertical: ResponsiveHelper.h(12.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: ResponsiveHelper.w(4),
                height: ResponsiveHelper.h(16),
                color: Color(0xFFC6FF00), // Neon Yellow-Green
              ),
              SizedBox(width: 8),
              Text(
                'MATCH ACHIEVEMENTS',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.sp(14),
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Obx(() {
            return Column(
              children: controller.achievements.asMap().entries.map((entry) {
                return AchievementCard(
                  achievement: entry.value,
                  index: entry.key,
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }
}
