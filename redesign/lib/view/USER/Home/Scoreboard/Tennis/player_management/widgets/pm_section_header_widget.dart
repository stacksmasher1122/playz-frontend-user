import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Tennis/player_management_controller.dart';
import '../../../../../../../theme/app_colors.dart';
import '../../../../../../../theme/app_typography.dart';
import '../../../../../../../theme/app_dimensions.dart';
import 'package:redesign/theme/responsive_helper.dart';

class PmSectionHeaderWidget extends StatelessWidget {
  PmSectionHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<PlayerManagementController>();
    
    return Padding(
      padding: EdgeInsets.all(AppDimensions.paddingXl),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Left Column
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TOURNAMENT SETUP',
                style: AppTypography.labelCaps.copyWith(color: AppColors.accent),
              ),
              SizedBox(height: 8),
              Text(
                'Player Management',
                style: AppTypography.headlineSora.copyWith(
                  color: AppColors.accent,
                  fontSize: MediaQuery.of(context).size.width < 768 ? 24 : 32,
                ),
              ),
            ],
          ),
          
          // Right QR Check-in Button
          GestureDetector(
            onTap: controller.showQrModal,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16), vertical: ResponsiveHelper.h(12)),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(AppDimensions.borderRadiusXl),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                children: [
                  Icon(Icons.qr_code_scanner, color: AppColors.accent, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'QR CHECK-IN',
                    style: AppTypography.labelCaps.copyWith(color: AppColors.onPrimary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
