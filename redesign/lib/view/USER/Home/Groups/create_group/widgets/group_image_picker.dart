import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Groups_Controller/groups_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kGreen = Color(0xFF6EDC6A);

class GroupImagePicker extends StatelessWidget {
  GroupImagePicker({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final ctrl = Get.find<GroupsController>();

    return Center(
      child: GestureDetector(
        onTap: ctrl.pickGroupImage,
        child: Column(
          children: [
            Obx(() {
              final img = ctrl.pickedImage.value;
              return Container(
                height: ResponsiveHelper.h(80),
                width: ResponsiveHelper.w(80),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: kGreen.withValues(alpha: 0.5),
                    width: ResponsiveHelper.w(1.5),
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
                    ? Center(
                        child: Icon(Icons.camera_alt, color: kGreen, size: 28),
                      )
                    : null,
              );
            }),
            SizedBox(height: 12),
            Text(
              'Add Group Photo',
              style: TextStyle(
                color: kGreen,
                fontSize: ResponsiveHelper.sp(13),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
