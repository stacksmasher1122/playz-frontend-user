import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Groups_Controller/groups_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kGreen = Color(0xFF6EDC6A);

class CreateGroupSubmitButton extends StatelessWidget {
  final VoidCallback onPressed;

  CreateGroupSubmitButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final ctrl = Get.find<GroupsController>();

    return Obx(() {
      final creating = ctrl.isCreating.value;
      return SizedBox(
        width: double.infinity,
        height: ResponsiveHelper.h(52),
        child: ElevatedButton(
          onPressed: creating ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: kGreen,
            disabledBackgroundColor: kGreen.withValues(alpha: 0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
            ),
            elevation: 0,
          ),
          child: creating
              ? SizedBox(
                  height: ResponsiveHelper.h(22),
                  width: ResponsiveHelper.w(22),
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.black,
                  ),
                )
              : Text(
                  'CREATE GROUP',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: ResponsiveHelper.sp(15),
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.0,
                  ),
                ),
        ),
      );
    });
  }
}
