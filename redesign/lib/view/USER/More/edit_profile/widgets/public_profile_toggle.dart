import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/user_profile_controller.dart';
import '../edit_profile_constants.dart';
import 'package:redesign/theme/responsive_helper.dart';

class PublicProfileToggle extends StatelessWidget {
  PublicProfileToggle({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<UserProfileController>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Public Profile',
              style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveHelper.sp(16),
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Allow anyone to see your stats',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: ResponsiveHelper.sp(12),
              ),
            ),
          ],
        ),
        Obx(
          () => Switch(
            value: controller.rxUser.value?.isPublicProfile ?? true,
            onChanged: (value) {
              final user = controller.rxUser.value;
              if (user != null) {
                controller.setUser(user.copyWith(isPublicProfile: value));
              }
            },
            activeThumbColor: Colors.black,
            activeTrackColor: kEditProfileGreen,
            inactiveThumbColor: Colors.white54,
            inactiveTrackColor: Colors.white.withValues(alpha: 0.1),
          ),
        ),
      ],
    );
  }
}
