import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:redesign/controller/user_profile_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ProfilePhotoPicker extends StatelessWidget {
  final File? imageFile;
  final VoidCallback onPickImage;

  ProfilePhotoPicker({
    super.key,
    required this.imageFile,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<UserProfileController>();

    return Center(
      child: GestureDetector(
        onTap: onPickImage,
        child: Column(
          children: [
            Container(
              width: ResponsiveHelper.w(100),
              height: ResponsiveHelper.h(100),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.15),
                  width: ResponsiveHelper.w(1),
                ),
              ),
              child: imageFile != null
                  ? ClipOval(
                      child: Image.file(
                        imageFile!,
                        width: ResponsiveHelper.w(100),
                        height: ResponsiveHelper.h(100),
                        fit: BoxFit.cover,
                      ),
                    )
                  : Obx(() => controller.profileImageUrl.isNotEmpty
                      ? ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: controller.profileImageUrl,
                            width: ResponsiveHelper.w(100),
                            height: ResponsiveHelper.h(100),
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Shimmer.fromColors(
                              baseColor: Colors.grey.shade800,
                              highlightColor: Colors.grey.shade700,
                              child: Container(
                                width: ResponsiveHelper.w(100),
                                height: ResponsiveHelper.h(100),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            errorWidget: (_, __, ___) => _buildPlaceholderAvatar(),
                          ),
                        )
                      : _buildPlaceholderAvatar()),
            ),
            SizedBox(height: 12),
            Text(
              'Change photo',
              style: GoogleFonts.inter(
                color: Colors.white70,
                fontSize: ResponsiveHelper.sp(14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderAvatar() {
    return Container(
      width: ResponsiveHelper.w(100),
      height: ResponsiveHelper.h(100),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.1),
      ),
      child: Icon(
        Icons.person,
        color: Colors.white.withValues(alpha: 0.4),
        size: 48,
      ),
    );
  }
}
