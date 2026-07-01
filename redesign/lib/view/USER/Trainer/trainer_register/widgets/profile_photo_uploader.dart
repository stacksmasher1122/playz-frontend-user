import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kGreen = AppColors.accent;
const kCard = Color(0xFF1A1A1A);
const kMuted = Color(0xFFA7A7A7);

class ProfilePhotoUploader extends StatelessWidget {
  ProfilePhotoUploader({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 46,
            backgroundColor: kCard,
            child: Icon(Icons.person, size: 42, color: kMuted),
          ),
          Positioned(
            bottom: ResponsiveHelper.h(0),
            right: ResponsiveHelper.w(0),
            child: Container(
              decoration: BoxDecoration(
                color: kGreen,
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(ResponsiveHelper.w(6)),
              child: Icon(
                Icons.camera_alt,
                size: 16,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
