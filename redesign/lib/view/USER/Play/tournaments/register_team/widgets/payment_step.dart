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
    ResponsiveHelper.init(context);

    final iconSize = context.minDimensionPct(18).clamp(52.0, 72.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: context.heightPct(3)),
        Icon(
          Icons.check_circle_outline_rounded,
          color: AppColors.accent,
          size: iconSize,
        ),
        SizedBox(height: context.heightPct(2)),
        Text(
          "Ready to Register",
          style: AppTypography.displayLg.copyWith(
            color: AppColors.textPrimary,
            fontSize: context.responsiveFont(22),
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: context.heightPct(1)),
        Text(
          "Team: ${controller.teamNameController.text}",
          style: AppTypography.bodyLg.copyWith(
            color: AppColors.muted,
            fontSize: context.responsiveFont(15),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: context.heightPct(3.5)),

        Container(
          padding: EdgeInsets.all(context.widthPct(4)),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
            border: Border.all(color: AppColors.borderDark),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Roster Size",
                    style: AppTypography.bodyLg.copyWith(
                      color: AppColors.muted,
                      fontSize: context.responsiveFont(14),
                    ),
                  ),
                  Text(
                    "${controller.selectedPlayers.length} Players",
                    style: AppTypography.bodyLg.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: context.responsiveFont(14),
                    ),
                  ),
                ],
              ),
              SizedBox(height: context.heightPct(1.5)),
              const Divider(color: AppColors.borderDark, height: 1),
              SizedBox(height: context.heightPct(1.5)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Entry Fee",
                    style: AppTypography.headlineSm.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: context.responsiveFont(15),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    controller.isFree ? "FREE" : "₹${controller.entryFeeAmount}",
                    style: AppTypography.headlineSm.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.bold,
                      fontSize: context.responsiveFont(16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        SizedBox(height: context.heightPct(5)),

        Obx(() {
          if (controller.isRegistering.value) {
            return const Center(child: CircularProgressIndicator(color: AppColors.accent));
          }
          return SizedBox(
            width: double.infinity,
            height: context.heightPct(6).clamp(48.0, 56.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
                ),
              ),
              onPressed: controller.submitRegistration,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  controller.isFree ? "CONFIRM REGISTRATION" : "PAY & REGISTER",
                  style: AppTypography.headlineSm.copyWith(
                    color: AppColors.background,
                    fontWeight: FontWeight.bold,
                    fontSize: context.responsiveFont(15),
                  ),
                ),
              ),
            ),
          );
        }),

        if (!controller.isFree) ...[
          SizedBox(height: context.heightPct(2)),
          Text(
            "Note: This is a test payment environment.",
            style: AppTypography.bodySm.copyWith(
              color: AppColors.error,
              fontSize: context.responsiveFont(12),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
