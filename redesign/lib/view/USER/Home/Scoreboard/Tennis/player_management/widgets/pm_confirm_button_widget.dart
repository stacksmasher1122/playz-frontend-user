import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../theme/app_colors.dart';
import '../../../../../../../theme/app_typography.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Tennis/player_management_controller.dart';

class PmConfirmButtonWidget extends StatelessWidget {
  const PmConfirmButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PlayerManagementController>();

    return Obx(() {
      final canConfirm = controller.playerA.value != null && controller.playerB.value != null;
      
      return GestureDetector(
        onTap: () {
          if (canConfirm) {
            Get.snackbar(
              'Match Confirmed',
              'Players have been successfully verified.',
              backgroundColor: AppColors.primaryContainer,
              colorText: AppColors.onPrimaryContainer,
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
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHigh,
            border: Border(
              top: BorderSide(
                color: canConfirm ? AppColors.primaryContainer : Colors.transparent,
                width: 2,
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
                    color: canConfirm ? AppColors.primaryContainer : AppColors.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward,
                color: canConfirm ? AppColors.primaryContainer : AppColors.onSurfaceVariant,
                size: 24,
              ),
            ],
          ),
        ),
      );
    });
  }
}
