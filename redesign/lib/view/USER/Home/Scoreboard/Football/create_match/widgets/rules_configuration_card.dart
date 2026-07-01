import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Football/football_create_match_controller.dart';
import 'duration_slider_widget.dart';
import 'halves_selector_widget.dart';
import 'toggle_option_widget.dart';

class RulesConfigurationCard extends StatelessWidget {
  const RulesConfigurationCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FootballCreateMatchController>();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade900.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade800),
      ),
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
                'RULES CONFIGURATION',
                style: TextStyle(
                  color: Color(0xFFC6FF00),
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Obx(() {
            return DurationSliderWidget(
              duration: controller.duration.value,
              onChanged: controller.updateDuration,
            );
          }),
          const SizedBox(height: 16),
          Divider(color: Colors.grey.shade800),
          const SizedBox(height: 16),
          Obx(() {
            return HalvesSelectorWidget(
              halves: controller.halves.value,
              onIncrease: controller.increaseHalves,
              onDecrease: controller.decreaseHalves,
            );
          }),
          const SizedBox(height: 16),
          Divider(color: Colors.grey.shade800),
          const SizedBox(height: 8),
          Obx(() {
            return Column(
              children: [
                ToggleOptionWidget(
                  label: 'Extra Time Allowed',
                  value: controller.extraTime.value,
                  onChanged: (val) => controller.toggleExtraTime(),
                ),
                ToggleOptionWidget(
                  label: 'Penalty Shootout',
                  value: controller.penaltyShootout.value,
                  onChanged: (val) => controller.togglePenaltyShootout(),
                ),
                ToggleOptionWidget(
                  label: 'VAR Simulation',
                  value: controller.varSimulation.value,
                  onChanged: (val) => controller.toggleVAR(),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
