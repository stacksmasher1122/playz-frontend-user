import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Groups_Controller/groups_controller.dart';

const kGreen = Color(0xFF6EDC6A);

class CreateGroupSubmitButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CreateGroupSubmitButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<GroupsController>();

    return Obx(() {
      final creating = ctrl.isCreating.value;
      return SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: creating ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: kGreen,
            disabledBackgroundColor: kGreen.withOpacity(0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 0,
          ),
          child: creating
              ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.black,
                  ),
                )
              : const Text(
                  'CREATE GROUP',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.0,
                  ),
                ),
        ),
      );
    });
  }
}
