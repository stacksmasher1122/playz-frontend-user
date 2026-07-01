import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Football/football_match_statistics_controller.dart';

class PlayerSearchWidget extends StatelessWidget {
  const PlayerSearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FootballMatchStatisticsController>();

    return Container(
      margin: const EdgeInsets.only(top: 16.0, bottom: 24.0),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search Players...',
          hintStyle: TextStyle(color: Colors.grey.shade600),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        onChanged: controller.searchPlayers,
      ),
    );
  }
}
