import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Groups_Controller/groups_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kGreen = Color(0xFF6EDC6A);

class CreateGroupOverlay extends StatelessWidget {
  CreateGroupOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final ctrl = Get.find<GroupsController>();

    return Obx(() {
      if (!ctrl.isCreating.value) return SizedBox.shrink();
      return Positioned.fill(
        child: Container(
          color: Colors.black.withValues(alpha: 0.5),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: kGreen),
                SizedBox(height: 16),
                Text(
                  'Creating your group...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.sp(15),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
