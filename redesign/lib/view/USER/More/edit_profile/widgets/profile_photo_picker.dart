import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:shimmer/shimmer.dart';
import 'package:redesign/controller/user_profile_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ProfilePhotoPicker extends StatelessWidget {
  final File? imageFile;
  final VoidCallback onPickImage;

  const ProfilePhotoPicker({
    super.key,
    required this.imageFile,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<UserProfileController>();
    final photoSize = context.widthPct(25).clamp(80.0, 120.0);

    return Center(
      child: GestureDetector(
        onTap: onPickImage,
        child: Column(
          children: [
            Container(
              width: photoSize,
              height: photoSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.borderDark,
                  width: 1,
                ),
              ),
              child: imageFile != null
                  ? ClipOval(
                      child: Image.file(
                        imageFile!,
                        width: photoSize,
                        height: photoSize,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Obx(() => controller.profileImageUrl.isNotEmpty
                      ? ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: controller.profileImageUrl,
                            width: photoSize,
                            height: photoSize,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Shimmer.fromColors(
                              baseColor: AppColors.surfaceElevated,
                              highlightColor: AppColors.borderDark,
                              child: Container(
                                width: photoSize,
                                height: photoSize,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.surface,
                                ),
                              ),
                            ),
                            errorWidget: (_, __, ___) => _buildPlaceholderAvatar(context, photoSize),
                          ),
                        )
                      : _buildPlaceholderAvatar(context, photoSize)),
            ),
            SizedBox(height: context.heightPct(1.2)),
            Text(
              'Change photo',
              style: AppTypography.bodySm.copyWith(
                color: AppColors.muted,
                fontSize: context.responsiveFont(14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderAvatar(BuildContext context, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.textPrimary.withValues(alpha: 0.1),
      ),
      child: const Icon(
        Icons.person,
        color: AppColors.muted,
        size: 48,
      ),
    );
  }
}
