import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/user_profile_controller.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class EditProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onSave;

  const EditProfileAppBar({
    super.key,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<UserProfileController>();

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Edit Profile',
        style: AppTypography.headlineSm.copyWith(
          color: AppColors.textPrimary,
          fontSize: context.responsiveFont(18),
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: false,
      actions: [
        Obx(() => TextButton(
              onPressed: controller.isLoading.value ? null : onSave,
              child: controller.isLoading.value
                  ? SizedBox(
                      width: context.widthPct(5),
                      height: context.widthPct(5),
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.accent,
                      ),
                    )
                  : Text(
                      'Save',
                      style: AppTypography.headlineSm.copyWith(
                        color: AppColors.accent,
                        fontSize: context.responsiveFont(16),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            )),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
