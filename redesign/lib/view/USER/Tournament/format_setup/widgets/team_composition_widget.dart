import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

import '../../../../../controller/User_Controller/Tournament_Controller/format_setup_controller.dart';

class TeamCompositionWidget extends StatelessWidget {
  final FormatSetupController controller;

  const TeamCompositionWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Obx(() {
      String sport = controller.selectedSport;
      bool isRacquet = (sport == "Badminton" || sport == "Tennis" || sport == "Table Tennis" || sport == "Pickleball");

      if (isRacquet) {
        return Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => controller.setTeamMode("singles"),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: context.heightPct(1.5)),
                  decoration: BoxDecoration(
                    color: controller.teamMode.value == "singles" ? AppColors.accent.withValues(alpha: 0.1) : AppColors.card,
                    borderRadius: BorderRadius.circular(context.minDimensionPct(2.5)),
                    border: Border.all(
                      color: controller.teamMode.value == "singles" ? AppColors.accent : AppColors.card,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Singles",
                      style: AppTypography.bodyMd.copyWith(
                        color: controller.teamMode.value == "singles" ? AppColors.accent : AppColors.textPrimary,
                        fontSize: context.responsiveFont(14),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: context.widthPct(4)),
            Expanded(
              child: GestureDetector(
                onTap: () => controller.setTeamMode("doubles"),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: context.heightPct(1.5)),
                  decoration: BoxDecoration(
                    color: controller.teamMode.value == "doubles" ? AppColors.accent.withValues(alpha: 0.1) : AppColors.card,
                    borderRadius: BorderRadius.circular(context.minDimensionPct(2.5)),
                    border: Border.all(
                      color: controller.teamMode.value == "doubles" ? AppColors.accent : AppColors.card,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Doubles",
                      style: AppTypography.bodyMd.copyWith(
                        color: controller.teamMode.value == "doubles" ? AppColors.accent : AppColors.textPrimary,
                        fontSize: context.responsiveFont(14),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      } else {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Team Size",
              style: AppTypography.bodyLg.copyWith(
                color: AppColors.textPrimary,
                fontSize: context.responsiveFont(14.5),
                fontWeight: FontWeight.w600,
              ),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if (controller.teamSize.value > 1) {
                      controller.teamSize.value--;
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
                Text(
                  "${controller.teamSize.value}",
                  style: AppTypography.headlineSm.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: context.responsiveFont(16),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: context.widthPct(3)),
                GestureDetector(
                  onTap: () {
                    controller.teamSize.value++;
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
    });
  }
}
