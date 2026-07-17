import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

import '../../../../../controller/User_Controller/Tournament_Controller/review_publish_controller.dart';

class PublishSettingTile extends StatelessWidget {
  final ReviewPublishController controller;

  const PublishSettingTile({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Make Public",
                style: AppTypography.bodyLg.copyWith(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: ResponsiveHelper.h(4)),
              Text(
                "Allow anyone to find and register",
                style: AppTypography.bodySm.copyWith(color: AppColors.muted),
              ),
            ],
          ),
          Obx(() => Switch(
                value: controller.isPublic.value,
                onChanged: controller.togglePublicSetting,
                activeThumbColor: AppColors.accent,
                activeTrackColor: AppColors.accent.withValues(alpha: 0.3),
                inactiveThumbColor: AppColors.card,
                inactiveTrackColor: AppColors.surface,
              )),
        ],
      ),
    );
  }
}
