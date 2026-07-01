import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Football/football_match_statistics_controller.dart';


class MatchMomentumCard extends StatelessWidget {
  const MatchMomentumCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FootballMatchStatisticsController>();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade900.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.show_chart, color: Color(0xFFC6FF00), size: 20),
              const SizedBox(width: 8),
              Text(
                'MATCH MOMENTUM',
                style: TextStyle(
                  color: const Color(0xFFC6FF00).withValues(alpha: 0.8),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Obx(() {
            return MomentumChartWidget(points: controller.momentumPoints.toList());
          }),
        ],
      ),
    );
  }
}


class MomentumChartWidget extends StatelessWidget {
  final dynamic points;
  const MomentumChartWidget({super.key, this.points});
  @override
  Widget build(BuildContext context) => const SizedBox();
}
