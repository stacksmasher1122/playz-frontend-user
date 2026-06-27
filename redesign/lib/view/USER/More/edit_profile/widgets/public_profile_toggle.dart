import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/user_profile_controller.dart';
import '../edit_profile_constants.dart';

class PublicProfileToggle extends StatelessWidget {
  const PublicProfileToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserProfileController>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Public Profile',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Allow anyone to see your stats',
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 12,
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
            activeColor: Colors.black,
            activeTrackColor: kEditProfileGreen,
            inactiveThumbColor: Colors.white54,
            inactiveTrackColor: Colors.white.withOpacity(0.1),
          ),
        ),
      ],
    );
  }
}
