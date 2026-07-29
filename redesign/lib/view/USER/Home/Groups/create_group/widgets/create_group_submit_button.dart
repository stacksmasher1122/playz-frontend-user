import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Groups_Controller/groups_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';

class CreateGroupSubmitButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CreateGroupSubmitButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final ctrl = Get.find<GroupsController>();
    final buttonHeight = context.heightPct(6.5).clamp(48.0, 56.0);

    return Obx(() {
      final creating = ctrl.isCreating.value;
      return SizedBox(
        width: double.infinity,
        height: buttonHeight,
        child: ElevatedButton(
          onPressed: creating ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accent,
            disabledBackgroundColor: AppColors.accent.withValues(alpha: 0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
            ),
            elevation: 0,
          ),
          child: creating
              ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: AppColors.background,
                  ),
                )
              : FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'CREATE GROUP',
                    style: AppTypography.headlineSm.copyWith(
                      color: AppColors.background,
                      fontSize: context.responsiveFont(15),
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
        ),
      );
    });
  }
}
