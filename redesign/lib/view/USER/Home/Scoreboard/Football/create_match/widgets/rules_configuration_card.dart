import 'package:redesign/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Football/football_create_match_controller.dart';
import 'duration_slider_widget.dart';
import 'halves_selector_widget.dart';
import 'toggle_option_widget.dart';
import 'package:redesign/theme/responsive_helper.dart';

class RulesConfigurationCard extends StatelessWidget {
  RulesConfigurationCard({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<FootballCreateMatchController>();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16.0), vertical: ResponsiveHelper.h(8.0)),
      padding: EdgeInsets.all(ResponsiveHelper.w(20)),
      decoration: BoxDecoration(
        color: Color(0xFF121212).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        border: Border.all(color: Color(0xFF1E1E1E)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: ResponsiveHelper.w(4),
                height: ResponsiveHelper.h(16),
                color: AppColors.accent, // Lime Green
              ),
              SizedBox(width: 8),
              Text(
                'RULES CONFIGURATION',
                style: TextStyle(
                  color: AppColors.accent,
                  fontSize: ResponsiveHelper.sp(12),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          Obx(() {
            return DurationSliderWidget(
              duration: controller.duration.value,
              onChanged: controller.updateDuration,
            );
          }),
          SizedBox(height: 16),
          Divider(color: Color(0xFF1E1E1E)),
          SizedBox(height: 16),
          Obx(() {
            return HalvesSelectorWidget(
              halves: controller.halves.value,
              onIncrease: controller.increaseHalves,
              onDecrease: controller.decreaseHalves,
            );
          }),
          SizedBox(height: 16),
          Divider(color: Color(0xFF1E1E1E)),
          SizedBox(height: 8),
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
