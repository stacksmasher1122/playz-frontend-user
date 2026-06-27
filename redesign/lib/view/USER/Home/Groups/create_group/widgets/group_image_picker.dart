import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:redesign/controller/User_Controller/Home_Controller/Groups_Controller/groups_controller.dart';

const kGreen = Color(0xFF6EDC6A);

class GroupImagePicker extends StatelessWidget {
  const GroupImagePicker({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<GroupsController>();

    return Center(
      child: GestureDetector(
        onTap: ctrl.pickGroupImage,
        child: Column(
          children: [
            Obx(() {
              final img = ctrl.pickedImage.value;
              return Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: kGreen.withOpacity(0.5),
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
                        child: Icon(Icons.camera_alt, color: kGreen, size: 28),
                      )
                    : null,
              );
            }),
            const SizedBox(height: 12),
            const Text(
              'Add Group Photo',
              style: TextStyle(
                color: kGreen,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
