import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Football/football_create_match_controller.dart';
import 'team_card_widget.dart';

class TeamSelectionCard extends StatelessWidget {
  const TeamSelectionCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FootballCreateMatchController>();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 16,
                color: const Color(0xFFC6FF00), // Lime Green
              ),
              const SizedBox(width: 8),
              const Text(
                'TEAM SELECTION',
                style: TextStyle(
                  color: Color(0xFFC6FF00),
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() {
            return Column(
              children: [
                TeamCardWidget(
                  isHome: true,
                  team: controller.homeTeam.value,
                  onSelect: controller.selectHomeTeam,
                  onUploadLogo: () => controller.uploadTeamLogo(true),
                ),
                const SizedBox(height: 16),
                TeamCardWidget(
                  isHome: false,
                  team: controller.awayTeam.value,
                  onSelect: controller.selectAwayTeam,
                  onUploadLogo: () => controller.uploadTeamLogo(false),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
