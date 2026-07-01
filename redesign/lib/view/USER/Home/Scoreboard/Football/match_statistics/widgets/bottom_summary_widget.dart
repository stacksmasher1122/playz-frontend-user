import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Football/football_match_statistics_controller.dart';

class BottomSummaryWidget extends StatelessWidget {
  const BottomSummaryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FootballMatchStatisticsController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
      child: TextButton(
        onPressed: controller.openFullAnalytics,
        child: const Text(
          'VIEW FULL SQUAD ANALYTICS',
          style: TextStyle(
            color: Color(0xFFC6FF00), // Lime Green
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }
}
