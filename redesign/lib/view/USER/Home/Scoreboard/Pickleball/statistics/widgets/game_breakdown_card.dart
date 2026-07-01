import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Pickleball/pickleball_stats_controller.dart';
import 'momentum_chart_widget.dart';
import 'timeline_widget.dart';
import 'package:get/get.dart';

class GameBreakdownCard extends StatelessWidget {
  final PickleballStatsController controller;

  const GameBreakdownCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceContainerHighest, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Game Breakdown',
                style: AppTypography.headlineSm.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
              ),
              Obx(() => Row(
                children: controller.statsModel.value.games.map((game) {
                  return _buildGameChip(
                    game['name'],
                    '${game['scoreA']}-${game['scoreB']}',
                    controller.selectedGame.value == game['name'],
                  );
                }).toList(),
              )),
            ],
          ),
          const SizedBox(height: 24),
          Obx(() => MomentumChartWidget(
            momentumData: controller.momentumData,
            selectedGame: controller.selectedGame.value,
          )),
          const SizedBox(height: 24),
          Obx(() => TimelineWidget(
            timeline: controller.statsModel.value.timeline,
          )),
        ],
      ),
    );
  }

  Widget _buildGameChip(String label, String score, bool isSelected) {
    return GestureDetector(
      onTap: () => controller.selectGame(label),
      child: Container(
        margin: const EdgeInsets.only(left: 8),
        padding: EdgeInsets.symmetric(horizontal: isSelected ? 12 : 8, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryContainer : AppColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(20), // Pill vs circle badge
          shape: isSelected ? BoxShape.rectangle : BoxShape.rectangle, // Approximating circle via radius if short
        ),
        child: Text(
          '$label: $score',
          style: AppTypography.labelCaps10.copyWith(
            color: isSelected ? Colors.black : AppColors.muted,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
