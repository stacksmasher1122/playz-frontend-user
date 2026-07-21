import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import '../../../../controller/User_Controller/Tournament_Controller/format_setup_controller.dart';

class TeamCompositionWidget extends StatelessWidget {
  final FormatSetupController controller;

  const TeamCompositionWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
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
                  padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(12)),
                  decoration: BoxDecoration(
                    color: controller.teamMode.value == "singles" ? AppColors.accent.withOpacity(0.1) : AppColors.card,
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
                    border: Border.all(
                      color: controller.teamMode.value == "singles" ? AppColors.accent : AppColors.card,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Singles",
                      style: AppTypography.bodyMd.copyWith(
                        color: controller.teamMode.value == "singles" ? AppColors.accent : AppColors.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: ResponsiveHelper.w(16)),
            Expanded(
              child: GestureDetector(
                onTap: () => controller.setTeamMode("doubles"),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(12)),
                  decoration: BoxDecoration(
                    color: controller.teamMode.value == "doubles" ? AppColors.accent.withOpacity(0.1) : AppColors.card,
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
                    border: Border.all(
                      color: controller.teamMode.value == "doubles" ? AppColors.accent : AppColors.card,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Doubles",
                      style: AppTypography.bodyMd.copyWith(
                        color: controller.teamMode.value == "doubles" ? AppColors.accent : AppColors.onPrimary,
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
              style: AppTypography.bodyLg.copyWith(color: AppColors.onPrimary),
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
                    padding: EdgeInsets.all(ResponsiveHelper.w(8)),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
                    ),
                    child: Icon(Icons.remove, color: AppColors.onPrimary, size: ResponsiveHelper.w(20)),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(16)),
                Text(
                  "${controller.teamSize.value}",
                  style: AppTypography.headlineSm.copyWith(color: AppColors.onPrimary),
                ),
                SizedBox(width: ResponsiveHelper.w(16)),
                GestureDetector(
                  onTap: () {
                    controller.teamSize.value++;
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
    });
  }
}
