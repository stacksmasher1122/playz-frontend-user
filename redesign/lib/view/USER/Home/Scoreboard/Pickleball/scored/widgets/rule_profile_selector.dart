import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Pickleball/pickleball_rule_engine.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Pickleball/pickleball_initialize_match_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';

class RuleProfileSelector extends StatelessWidget {
  final PickleballInitializeMatchController controller;

  const RuleProfileSelector({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
        border: Border.all(color: Colors.transparent),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.gavel, color: AppColors.accent, size: 20),
              SizedBox(width: 8),
              Text('Rule Engine Profile', style: AppTypography.headlineMd),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Select a predefined tournament rule set, or customize individual rules below.',
            style: AppTypography.bodySm.copyWith(color: AppColors.muted),
          ),
          SizedBox(height: 16),
          Obx(
            () => Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.outlineVariant),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<PickleballRuleProfile>(
                  isExpanded: true,
                  dropdownColor: AppColors.card,
                  value: controller.currentProfile.value,
                  icon: Icon(Icons.arrow_drop_down, color: AppColors.textPrimary),
                  items: controller.availableProfiles.map((profile) {
                    return DropdownMenuItem<PickleballRuleProfile>(
                      value: profile,
                      child: Text(profile.profileName, style: AppTypography.bodyMd),
                    );
                  }).toList(),
                  onChanged: (newProfile) {
                    if (newProfile != null) {
                      controller.changeProfile(newProfile);
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
