import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Badminton/match_timeline_controller.dart';
import 'achievement_card.dart';

class AchievementSection extends StatelessWidget {
  const AchievementSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MatchTimelineController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 16,
                color: const Color(0xFFC6FF00), // Neon Yellow-Green
              ),
              const SizedBox(width: 8),
              const Text(
                'MATCH ACHIEVEMENTS',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
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
