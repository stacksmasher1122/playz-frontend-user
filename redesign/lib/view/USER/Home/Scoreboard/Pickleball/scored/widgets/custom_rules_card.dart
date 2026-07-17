import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Pickleball/pickleball_initialize_match_controller.dart';
import 'toggle_rule_tile.dart';
import 'package:redesign/theme/responsive_helper.dart';

class CustomRulesCard extends StatelessWidget {
  final PickleballInitializeMatchController controller;

  CustomRulesCard({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
        border: Border.all(color: AppColors.outlineVariant, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.settings, color: AppColors.accent, size: 20),
              SizedBox(width: 8),
              Text('Custom Rules', style: AppTypography.headlineMd),
            ],
          ),
          SizedBox(height: 16),
          Obx(() => ToggleRuleTile(
            title: "Win By 2",
            subtitle: "Standard tournament rule",
            value: controller.winByTwo.value,
            onChanged: (v) => controller.toggleWinByTwo(),
          )),
          Divider(color: AppColors.outlineVariant, height: 1),
          Obx(() => ToggleRuleTile(
            title: "Rally Scoring",
            subtitle: "Point on every serve",
            value: controller.rallyScoring.value,
            onChanged: (v) => controller.toggleRallyScoring(),
          )),
          Divider(color: AppColors.outlineVariant, height: 1),
          Obx(() => ToggleRuleTile(
            title: "Traditional",
            subtitle: "Server scores only",
            value: controller.traditionalScoring.value,
            onChanged: (v) => controller.toggleTraditional(),
          )),
        ],
      ),
    );
  }
}
