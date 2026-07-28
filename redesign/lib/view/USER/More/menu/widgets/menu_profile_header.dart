import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/controller/user_profile_controller.dart';
import 'package:redesign/view/USER/More/profile/profile_screen.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MenuProfileHeader extends StatelessWidget {
  const MenuProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.isRegistered<UserProfileController>()
        ? Get.find<UserProfileController>()
        : Get.put(UserProfileController());

    return Obx(() {
      final user = controller.rxUser.value;
      final name = user?.fullName.isNotEmpty == true ? user!.fullName : 'User';
      final imageUrl = controller.profileImageUrl;
      final tier = user?.tier ?? TierHelper.getTierFromXp(user?.xpPoints ?? 100);
      final tierGradient = TierHelper.getTierGradient(tier);

      return Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
          border: Border(
            left: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
            right: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
            bottom: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
          ),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
          child: InkWell(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                ResponsiveHelper.w(20),
                ResponsiveHelper.h(8),
                ResponsiveHelper.w(20),
                ResponsiveHelper.h(18),
              ),
              child: Row(
                children: [
                  /// PROFILE AVATAR WITH TIER GRADIENT RING
                  Container(
                    padding: const EdgeInsets.all(2.5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: tierGradient,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00E676).withValues(alpha: 0.2),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: imageUrl.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: imageUrl,
                              width: ResponsiveHelper.w(54),
                              height: ResponsiveHelper.h(54),
                              fit: BoxFit.cover,
                              placeholder: (_, __) => Shimmer.fromColors(
                                baseColor: Colors.grey.shade800,
                                highlightColor: Colors.grey.shade700,
                                child: const CircleAvatar(radius: 27),
                              ),
                              errorWidget: (_, __, ___) => const CircleAvatar(
                                radius: 27,
                                backgroundColor: Color(0xFF1A1A1A),
                                child: Icon(Icons.person, color: Colors.white38),
                              ),
                            )
                          : const CircleAvatar(
                              radius: 27,
                              backgroundColor: Color(0xFF1A1A1A),
                              child: Icon(Icons.person, color: Colors.white38),
                            ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  /// USER NAME + TIER PILL BADGE
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: ResponsiveHelper.sp(16),
                          ),
                        ),
                        const SizedBox(height: 6),

                        /// TIER GRADIENT PILL BADGE & GREEN FIRE STREAK PILL
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                gradient: tierGradient,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                tier.toUpperCase(),
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),

                            /// GREEN FIRE ACTIVE STREAK PILL
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFF00E676).withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFF00E676).withValues(alpha: 0.4),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF00E676).withValues(alpha: 0.15),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.local_fire_department_rounded,
                                    color: Color(0xFF00E676),
                                    size: 13,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    '5 Days',
                                    style: GoogleFonts.inter(
                                      color: const Color(0xFF00E676),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
