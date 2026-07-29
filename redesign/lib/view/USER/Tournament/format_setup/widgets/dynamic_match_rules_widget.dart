import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

import '../../../../../controller/User_Controller/Tournament_Controller/format_setup_controller.dart';

class DynamicMatchRulesWidget extends StatelessWidget {
  final FormatSetupController controller;

  const DynamicMatchRulesWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Obx(() {
      String sport = controller.selectedSport;

      if (sport == "Badminton" || sport == "Tennis" || sport == "Table Tennis" || sport == "Pickleball") {
        return Column(
          children: [
            _buildNumberRule(context, "Points Per Game/Set", "pointsPerGame"),
            SizedBox(height: context.heightPct(1.5)),
            _buildNumberRule(context, "Best of N Sets", "bestOf"),
          ],
        );
      } else if (sport == "Cricket") {
        return Column(
          children: [
            _buildNumberRule(context, "Overs per Innings", "overs"),
            SizedBox(height: context.heightPct(1.5)),
            _buildNumberRule(context, "Powerplay Overs", "powerplayOvers"),
          ],
        );
      } else if (sport == "Football") {
        return Column(
          children: [
            _buildNumberRule(context, "Half Length (mins)", "halfLength"),
            SizedBox(height: context.heightPct(1.5)),
            _buildToggleRule(context, "Extra Time", "extraTime"),
            SizedBox(height: context.heightPct(1.5)),
            _buildToggleRule(context, "Penalties", "penalties"),
          ],
        );
      } else if (sport == "Volleyball") {
        return Column(
          children: [
            _buildNumberRule(context, "Points Per Set", "pointsPerSet"),
            SizedBox(height: context.heightPct(1.5)),
            _buildNumberRule(context, "Best of N Sets", "bestOf"),
          ],
        );
      } else if (sport == "Basketball") {
        return Column(
          children: [
            _buildNumberRule(context, "Quarter Length (mins)", "quarterLength"),
          ],
        );
      } else {
        return Center(
          child: Text(
            "Custom rules will be available soon.",
            style: AppTypography.bodyMd.copyWith(
              color: AppColors.muted,
              fontSize: context.responsiveFont(14),
            ),
          ),
        );
      }
    });
  }

  Widget _buildNumberRule(BuildContext context, String label, String key) {
    int value = controller.sportRules[key] ?? 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTypography.bodyLg.copyWith(
              color: AppColors.textPrimary,
              fontSize: context.responsiveFont(14.5),
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
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
                padding: EdgeInsets.all(context.widthPct(2)),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(context.minDimensionPct(2.5)),
                ),
                child: Icon(
                  Icons.remove_rounded,
                  color: AppColors.textPrimary,
                  size: context.responsiveFont(18),
                ),
              ),
            ),
            SizedBox(width: context.widthPct(3)),
            SizedBox(
              width: context.widthPct(8),
              child: Center(
                child: Text(
                  "$value",
                  style: AppTypography.headlineSm.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: context.responsiveFont(16),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(width: context.widthPct(3)),
            GestureDetector(
              onTap: () {
                controller.updateRule(key, value + 1);
              },
              child: Container(
                padding: EdgeInsets.all(context.widthPct(2)),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(context.minDimensionPct(2.5)),
                ),
                child: Icon(
                  Icons.add_rounded,
                  color: AppColors.textPrimary,
                  size: context.responsiveFont(18),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildToggleRule(BuildContext context, String label, String key) {
    bool value = controller.sportRules[key] ?? false;
    return Container(
      padding: EdgeInsets.all(context.widthPct(3.5)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
        border: Border.all(
          color: value ? AppColors.accent : AppColors.card,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTypography.bodyLg.copyWith(
                color: AppColors.textPrimary,
                fontSize: context.responsiveFont(14.5),
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Switch(
            value: value,
            onChanged: (val) {
              controller.updateRule(key, val);
            },
            activeThumbColor: AppColors.background,
            activeTrackColor: AppColors.accent,
            inactiveThumbColor: AppColors.muted,
            inactiveTrackColor: AppColors.card,
          ),
        ],
      ),
    );
  }
}
