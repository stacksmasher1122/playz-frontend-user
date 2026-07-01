import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Pickleball/live_pickleball_match_controller.dart';
import 'performance_progress.dart';
import 'package:get/get.dart';

class PerformanceCard extends StatelessWidget {
  final LivePickleballMatchController controller;

  const PerformanceCard({
    super.key,
    required this.controller,
  });

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
                'LIVE PERFORMANCE',
                style: AppTypography.labelCaps10.copyWith(color: AppColors.primaryContainer, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () => controller.goToStats(),
                child: Text(
                  'VIEW FULL STATS',
                  style: AppTypography.labelCaps10.copyWith(color: AppColors.primaryContainer, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() => PerformanceProgress(
            label: 'WIN PERCENTAGE',
            valueA: '${(controller.winPercentageA.value * 100).toInt()}%',
            valueB: '${(controller.winPercentageB.value * 100).toInt()}%',
            fillRatio: controller.winPercentageA.value,
            isPercentageBar: true,
          )),
          Obx(() => PerformanceProgress(
            label: 'UNFORCED ERRORS',
            valueA: '${controller.unforcedErrorsA.value}',
            valueB: '${controller.unforcedErrorsB.value}',
            isPercentageBar: false,
          )),
          Obx(() => PerformanceProgress(
            label: 'SERVE ACCURACY',
            valueA: '${(controller.serveAccuracyA.value * 100).toInt()}%',
            valueB: '${(controller.serveAccuracyB.value * 100).toInt()}%',
            isPercentageBar: false,
          )),
          Obx(() => PerformanceProgress(
            label: 'AVG RALLY LENGTH',
            valueA: '${controller.rallyLengthAvg.value} shots',
            valueB: '',
            isPercentageBar: false,
          )),
          Obx(() => PerformanceProgress(
            label: 'LONGEST RALLY',
            valueA: '${controller.longestRally.value} shots',
            valueB: '',
            isPercentageBar: false,
          )),
        ],
      ),
    );
  }
}
