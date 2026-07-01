import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/controller/user_profile_controller.dart';
import 'package:redesign/view/USER/More/edit_profile/edit_profile_screen.dart';
import 'elite_badge.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MenuProfileHeader extends StatelessWidget {
  MenuProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<UserProfileController>();
    return Obx(() {
      final user = controller.rxUser.value;
      final name = user?.fullName ?? 'User';
      final imageUrl = controller.profileImageUrl;
      final email = user?.primaryEmail ?? '';

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
        child: Row(
          children: [
            ClipOval(
              child: imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      width: ResponsiveHelper.w(52),
                      height: ResponsiveHelper.h(52),
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Shimmer.fromColors(
                        baseColor: Colors.grey.shade800,
                        highlightColor: Colors.grey.shade700,
                        child: CircleAvatar(radius: 26),
                      ),
                      errorWidget: (_, __, ___) => CircleAvatar(
                        radius: 26,
                        backgroundColor: Color(0xFF1A1A1A),
                        child: Icon(Icons.person, color: Colors.white38),
                      ),
                    )
                  : CircleAvatar(
                      radius: 26,
                      backgroundColor: Color(0xFF1A1A1A),
                      child: Icon(Icons.person, color: Colors.white38),
                    ),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: ResponsiveHelper.sp(16),
                          ),
                        ),
                      ),
                      SizedBox(width: 6),
                      EliteBadge('ELITE'),
                    ],
                  ),
                  SizedBox(height: 2),
                  Text(
                    email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      color: AppColors.muted,
                      fontSize: ResponsiveHelper.sp(12),
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => EditProfileScreen()),
                );
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                backgroundColor: AppColors.surface,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
                ),
              ),
              child: Text(
                'Edit',
                style: GoogleFonts.inter(
                  fontSize: ResponsiveHelper.sp(13),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
