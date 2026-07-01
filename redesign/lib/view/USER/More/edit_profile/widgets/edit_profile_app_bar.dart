import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/controller/user_profile_controller.dart';
import '../edit_profile_constants.dart';
import 'package:redesign/theme/responsive_helper.dart';

class EditProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onSave;

  EditProfileAppBar({
    super.key,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<UserProfileController>();

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Edit Profile',
        style: GoogleFonts.inter(
          color: Colors.white,
          fontSize: ResponsiveHelper.sp(18),
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: false,
      actions: [
        Obx(() => TextButton(
              onPressed: controller.isLoading.value ? null : onSave,
              child: controller.isLoading.value
                  ? SizedBox(
                      width: ResponsiveHelper.w(20),
                      height: ResponsiveHelper.h(20),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: kEditProfileGreen,
                      ),
                    )
                  : Text(
                      'Save',
                      style: GoogleFonts.inter(
                        color: kEditProfileGreen,
                        fontSize: ResponsiveHelper.sp(16),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            )),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
