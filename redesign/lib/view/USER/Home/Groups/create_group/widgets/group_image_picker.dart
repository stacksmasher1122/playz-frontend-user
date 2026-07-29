import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Groups_Controller/groups_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';

class GroupImagePicker extends StatelessWidget {
  const GroupImagePicker({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final ctrl = Get.find<GroupsController>();
    final size = context.minDimensionPct(22).clamp(70.0, 90.0);

    return Center(
      child: GestureDetector(
        onTap: ctrl.pickGroupImage,
        child: Column(
          children: [
            Obx(() {
              final img = ctrl.pickedImage.value;
              return Container(
                height: size,
                width: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.accent.withValues(alpha: 0.5),
                    width: 1.5,
                  ),
                  color: Colors.transparent,
                  image: img != null
                      ? DecorationImage(
                          image: FileImage(img),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: img == null
                    ? const Center(
                        child: Icon(Icons.camera_alt, color: AppColors.accent, size: 28),
                      )
                    : null,
              );
            }),
            SizedBox(height: context.heightPct(1.5)),
            Text(
              'Add Group Photo',
              style: AppTypography.bodySm.copyWith(
                color: AppColors.accent,
                fontSize: context.responsiveFont(13),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
