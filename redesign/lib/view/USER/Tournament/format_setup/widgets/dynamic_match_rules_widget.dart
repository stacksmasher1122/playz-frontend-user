import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
// Corrected: was '../../../../controller/...' but widgets/ is one level deeper, so 5 levels up are needed
import '../../../../../controller/User_Controller/Tournament_Controller/format_setup_controller.dart';

class DynamicMatchRulesWidget extends StatelessWidget {
  final FormatSetupController controller;

  const DynamicMatchRulesWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      String sport = controller.selectedSport;

      if (sport == "Badminton" || sport == "Tennis" || sport == "Table Tennis" || sport == "Pickleball") {
        return Column(
          children: [
            _buildNumberRule("Points Per Game/Set", "pointsPerGame"),
            SizedBox(height: ResponsiveHelper.h(16)),
            _buildNumberRule("Best of N Sets", "bestOf"),
          ],
        );
      } else if (sport == "Cricket") {
        return Column(
          children: [
            _buildNumberRule("Overs per Innings", "overs"),
            SizedBox(height: ResponsiveHelper.h(16)),
            _buildNumberRule("Powerplay Overs", "powerplayOvers"),
          ],
        );
      } else if (sport == "Football") {
        return Column(
          children: [
            _buildNumberRule("Half Length (mins)", "halfLength"),
            SizedBox(height: ResponsiveHelper.h(16)),
            _buildToggleRule("Extra Time", "extraTime"),
            SizedBox(height: ResponsiveHelper.h(16)),
            _buildToggleRule("Penalties", "penalties"),
          ],
        );
      } else if (sport == "Volleyball") {
        return Column(
          children: [
            _buildNumberRule("Points Per Set", "pointsPerSet"),
            SizedBox(height: ResponsiveHelper.h(16)),
            _buildNumberRule("Best of N Sets", "bestOf"),
          ],
        );
      } else if (sport == "Basketball") {
        return Column(
          children: [
            _buildNumberRule("Quarter Length (mins)", "quarterLength"),
          ],
        );
      } else {
        return Center(
          child: Text(
            "Custom rules will be available soon.",
            style: AppTypography.bodyMd.copyWith(color: AppColors.muted),
          ),
        );
      }
    });
  }

  Widget _buildNumberRule(String label, String key) {
    int value = controller.sportRules[key] ?? 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.bodyLg.copyWith(color: AppColors.onPrimary),
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                if (value > 1) {
                  controller.updateRule(key, value - 1);
                }
              },
              child: Container(
                padding: EdgeInsets.all(ResponsiveHelper.w(8)),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
                ),
                child: Icon(Icons.remove, color: AppColors.onPrimary, size: ResponsiveHelper.w(20)),
              ),
            ),
            SizedBox(width: ResponsiveHelper.w(16)),
            SizedBox(
              width: ResponsiveHelper.w(30),
              child: Center(
                child: Text(
                  "$value",
                  style: AppTypography.headlineSm.copyWith(color: AppColors.onPrimary),
                ),
              ),
            ),
            SizedBox(width: ResponsiveHelper.w(16)),
            GestureDetector(
              onTap: () {
                controller.updateRule(key, value + 1);
              },
              child: Container(
                padding: EdgeInsets.all(ResponsiveHelper.w(8)),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
                ),
                child: Icon(Icons.add, color: AppColors.onPrimary, size: ResponsiveHelper.w(20)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildToggleRule(String label, String key) {
    bool value = controller.sportRules[key] ?? false;
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
        border: Border.all(
          color: value ? AppColors.accent : AppColors.card,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.bodyLg.copyWith(color: AppColors.onPrimary),
          ),
          Switch(
            value: value,
            onChanged: (val) {
              controller.updateRule(key, val);
            },
            activeColor: AppColors.accent,
            inactiveTrackColor: AppColors.surface,
          ),
        ],
      ),
    );
  }
}
