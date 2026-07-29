import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/user_profile_controller.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class PublicProfileToggle extends StatelessWidget {
  const PublicProfileToggle({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<UserProfileController>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Public Profile',
                style: AppTypography.headlineSm.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: context.responsiveFont(16),
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: context.heightPct(0.4)),
              Text(
                'Allow anyone to see your stats',
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.muted,
                  fontSize: context.responsiveFont(12),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Obx(
          () => Switch.adaptive(
            value: controller.rxUser.value?.isPublicProfile ?? true,
            onChanged: (value) {
              final user = controller.rxUser.value;
              if (user != null) {
                controller.setUser(user.copyWith(isPublicProfile: value));
              }
            },
            activeThumbColor: AppColors.background,
            activeTrackColor: AppColors.accent,
            inactiveThumbColor: AppColors.muted,
            inactiveTrackColor: AppColors.textPrimary.withValues(alpha: 0.1),
          ),
        ),
      ],
    );
  }
}
