import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

import '../../../../../../controller/User_Controller/Tournament_Controller/register_team_controller.dart';

class PaymentStep extends StatelessWidget {
  final RegisterTeamController controller;

  const PaymentStep({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: ResponsiveHelper.h(32)),
        Icon(Icons.check_circle_outline, color: AppColors.accent, size: ResponsiveHelper.w(64)),
        SizedBox(height: ResponsiveHelper.h(16)),
        Text(
          "Ready to Register",
          style: AppTypography.displaySm.copyWith(color: AppColors.onPrimary),
        ),
        SizedBox(height: ResponsiveHelper.h(8)),
        Text(
          "Team: ${controller.teamNameController.text}",
          style: AppTypography.bodyLg.copyWith(color: AppColors.muted),
        ),
        SizedBox(height: ResponsiveHelper.h(32)),

        Container(
          padding: EdgeInsets.all(ResponsiveHelper.w(16)),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Roster Size", style: AppTypography.bodyLg.copyWith(color: AppColors.muted)),
                  Text("${controller.selectedPlayers.length} Players", style: AppTypography.bodyLg.copyWith(color: AppColors.onPrimary)),
                ],
              ),
              SizedBox(height: ResponsiveHelper.h(16)),
              Divider(color: AppColors.surface, height: 1),
              SizedBox(height: ResponsiveHelper.h(16)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Entry Fee", style: AppTypography.headlineSm.copyWith(color: AppColors.onPrimary)),
                  Text(
                    controller.isFree ? "FREE" : "₹${controller.entryFeeAmount}",
                    style: AppTypography.headlineSm.copyWith(color: AppColors.accent)
                  ),
                ],
              ),
            ],
          ),
        ),

        SizedBox(height: ResponsiveHelper.h(48)),

        Obx(() {
          if (controller.isRegistering.value) {
            return Center(child: CircularProgressIndicator(color: AppColors.accent));
          }
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              minimumSize: Size(double.infinity, ResponsiveHelper.h(56)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ResponsiveHelper.w(12))),
            ),
            onPressed: controller.submitRegistration,
            child: Text(
              controller.isFree ? "CONFIRM REGISTRATION" : "PAY & REGISTER",
              style: AppTypography.headlineSm.copyWith(
                color: AppColors.background,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }),

        if (!controller.isFree) ...[
          SizedBox(height: ResponsiveHelper.h(16)),
          Text(
            "Note: This is a test payment environment.",
            style: AppTypography.bodySm.copyWith(color: AppColors.error),
          ),
        ]
      ],
    );
  }
}
