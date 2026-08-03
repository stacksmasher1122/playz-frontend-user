import 'package:redesign/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Football/football_create_match_controller.dart';
import 'duration_slider_widget.dart';
import 'halves_selector_widget.dart';
import 'toggle_option_widget.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MatchDurationCard extends StatelessWidget {
  const MatchDurationCard({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<FootballCreateMatchController>();

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.w(16.0),
        vertical: ResponsiveHelper.h(8.0),
      ),
      padding: EdgeInsets.all(ResponsiveHelper.w(20)),
      decoration: BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        border: Border.all(color: Color(0xFF2A2A2A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: ResponsiveHelper.w(4),
                height: ResponsiveHelper.h(16),
                color: AppColors.accent,
              ),
              SizedBox(width: 8),
              Text(
                'MATCH DURATION',
                style: TextStyle(
                  color: AppColors.accent,
                  fontSize: ResponsiveHelper.sp(12),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Obx(() {
            return DurationSliderWidget(
              duration: controller.duration.value,
              onChanged: controller.updateDuration,
            );
          }),
        ],
      ),
    );
  }
}

class RulesConfigurationCard extends StatelessWidget {
  const RulesConfigurationCard({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<FootballCreateMatchController>();

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.w(16.0),
        vertical: ResponsiveHelper.h(8.0),
      ),
      child: Column(
        children: [
          // Pro Rules Switch Header Card
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
              border: Border.all(color: Color(0xFF2A2A2A)),
            ),
            padding: EdgeInsets.all(ResponsiveHelper.w(16)),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(ResponsiveHelper.w(10)),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
                  ),
                  child: Icon(
                    Icons.gavel,
                    color: AppColors.accent,
                    size: 22,
                  ),
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ALLOW PRO RULES',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ResponsiveHelper.sp(15),
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Customize halves & extra time',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: ResponsiveHelper.sp(12),
                        ),
                      ),
                    ],
                  ),
                ),
                Obx(
                  () => Switch(
                    value: controller.allowProRules.value,
                    onChanged: controller.toggleProRules,
                    activeThumbColor: AppColors.accent,
                    activeTrackColor: AppColors.accent.withValues(alpha: 0.4),
                    inactiveThumbColor: Colors.grey,
                    inactiveTrackColor: Color(0xFF2C2C2C),
                  ),
                ),
              ],
            ),
          ),

          // Advanced Rules Settings (Revealed only when Allow Pro Rules is ON)
          Obx(() {
            if (!controller.allowProRules.value) return const SizedBox.shrink();

            return Container(
              margin: EdgeInsets.only(top: ResponsiveHelper.h(12)),
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
                        color: AppColors.accent,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'PRO RULES CONFIGURATION',
                        style: TextStyle(
                          color: AppColors.accent,
                          fontSize: ResponsiveHelper.sp(12),
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  HalvesSelectorWidget(
                    halves: controller.halves.value,
                    onIncrease: controller.increaseHalves,
                    onDecrease: controller.decreaseHalves,
                  ),
                  SizedBox(height: 16),
                  Divider(color: Color(0xFF1E1E1E)),
                  SizedBox(height: 8),
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
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
