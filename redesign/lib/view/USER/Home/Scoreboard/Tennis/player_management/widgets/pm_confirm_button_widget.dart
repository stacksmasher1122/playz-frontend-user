import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../theme/app_colors.dart';
import '../../../../../../../theme/app_typography.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Tennis/player_management_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';

class PmConfirmButtonWidget extends StatelessWidget {
  PmConfirmButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<PlayerManagementController>();

    return Obx(() {
      final canConfirm = controller.playerA.value != null && controller.playerB.value != null;
      
      return GestureDetector(
        onTap: () {
          if (canConfirm) {
            Get.snackbar(
              'Match Confirmed',
              'Players have been successfully verified.',
              backgroundColor: AppColors.accent,
              colorText: AppColors.background,
              snackPosition: SnackPosition.BOTTOM,
            );
          } else {
            Get.snackbar(
              'Incomplete',
              'Please select Player B before confirming.',
              backgroundColor: AppColors.error,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(24), horizontal: ResponsiveHelper.w(24)),
          decoration: BoxDecoration(
            color: AppColors.card,
            border: Border(
              top: BorderSide(
                color: canConfirm ? AppColors.accent : Colors.transparent,
                width: ResponsiveHelper.w(2),
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'CONFIRM MATCH\nPARTICIPANTS',
                  style: AppTypography.headlineMd.copyWith(
                    color: canConfirm ? AppColors.accent : AppColors.muted,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward,
                color: canConfirm ? AppColors.accent : AppColors.muted,
                size: 24,
              ),
            ],
          ),
        ),
      );
    });
  }
}
