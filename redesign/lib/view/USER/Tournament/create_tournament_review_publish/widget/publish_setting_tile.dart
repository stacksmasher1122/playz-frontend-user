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
    ResponsiveHelper.init(context);

    return Container(
      padding: EdgeInsets.all(context.widthPct(4)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Make Public",
                  style: AppTypography.bodyLg.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: context.responsiveFont(15),
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: context.heightPct(0.5)),
                Text(
                  "Allow anyone to find and register",
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.muted,
                    fontSize: context.responsiveFont(12.5),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: context.widthPct(2)),
          Obx(() => Switch(
                value: controller.isPublic.value,
                onChanged: controller.togglePublicSetting,
                activeThumbColor: AppColors.background,
                activeTrackColor: AppColors.accent,
                inactiveThumbColor: AppColors.muted,
                inactiveTrackColor: AppColors.card,
              )),
        ],
      ),
    );
  }
}
