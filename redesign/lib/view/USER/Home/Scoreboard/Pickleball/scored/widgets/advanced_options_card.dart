import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Pickleball/pickleball_initialize_match_controller.dart';
import 'category_chip_group.dart'; // for MatchCustomChip
import 'toggle_rule_tile.dart';
import 'package:redesign/theme/responsive_helper.dart';

class AdvancedOptionsCard extends StatelessWidget {
  final PickleballInitializeMatchController controller;

  AdvancedOptionsCard({
    super.key,
    required this.controller,
  });

  Widget _buildSection(String title, List<String> options, String selectedValue, ValueChanged<String> onSelect) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTypography.bodySm.copyWith(color: AppColors.muted)),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((opt) => MatchCustomChip(
            label: opt,
            isSelected: opt == selectedValue,
            onTap: () => onSelect(opt),
          )).toList(),
        ),
      ],
    );
  }

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
          Text('PICKLEBALL ADVANCED SETTINGS', style: AppTypography.labelCaps.copyWith(color: AppColors.muted)),
          SizedBox(height: 16),
          Obx(() => _buildSection("Match Type", controller.matchTypeOptions, controller.selectedMatchType.value, controller.changeMatchType)),
          SizedBox(height: 16),
          Obx(() => _buildSection("Court Surface", controller.surfaceOptions, controller.selectedSurface.value, controller.changeCourtSurface)),
          SizedBox(height: 16),
          Obx(() => _buildSection("Skill Level", controller.skillLevelOptions, controller.selectedSkillLevel.value, controller.changeSkillLevel)),
          SizedBox(height: 16),
          Obx(() => _buildSection("Serving Rule", controller.servingRuleOptions, controller.selectedServingRule.value, controller.changeServingRule)),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Timeouts Per Team", style: AppTypography.bodySm.copyWith(color: AppColors.muted)),
              Row(
                children: [
                  IconButton(
                    onPressed: controller.decrementTimeouts,
                    icon: Icon(Icons.remove_circle_outline, color: AppColors.accent),
                  ),
                  Obx(() => Text('${controller.timeouts.value}', style: AppTypography.headlineMd)),
                  IconButton(
                    onPressed: controller.incrementTimeouts,
                    icon: Icon(Icons.add_circle_outline, color: AppColors.accent),
                  ),
                ],
              )
            ],
          ),
          SizedBox(height: 16),
          Obx(() => _buildSection("Maximum Score", ["11", "15", "21"], controller.maximumScore.value.toString(), (v) => controller.selectMaxScore(int.parse(v)))),
          SizedBox(height: 16),
          Obx(() => ToggleRuleTile(
            title: "Golden Point",
            subtitle: "Default OFF",
            value: controller.goldenPoint.value,
            onChanged: (v) => controller.toggleGoldenPoint(),
          )),
          Divider(color: AppColors.outlineVariant, height: 1),
          Obx(() => ToggleRuleTile(
            title: "Medical Timeout",
            subtitle: "Default ON",
            value: controller.medicalTimeout.value,
            onChanged: (v) => controller.toggleMedicalTimeout(),
          )),
          SizedBox(height: 16),
          Obx(() => _buildSection("Court Side", ["Random", "Manual"], controller.courtSideSelection.value, controller.selectCourtSide)),
        ],
      ),
    );
  }
}
