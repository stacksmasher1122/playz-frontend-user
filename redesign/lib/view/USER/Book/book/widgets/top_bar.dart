import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:redesign/controller/maps_controller.dart';
import 'package:redesign/controller/user_profile_controller.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/view/USER/Maps/maps_setup/maps_setup_screen.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final _controller = Get.find<UserProfileController>();
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          /// LOCATION TEXT + DROPDOWN ICON (Dynamic)
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LocationSelectSliverScreen(),
                  ),
                );
              },
              child: Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: AppColors.accent,
                    size: width < 360 ? 18 : 22,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Obx(() {
                      final mapsCtrl = Get.find<MapsController>();
                      final city = mapsCtrl.displayCity.value;
                      final locality = mapsCtrl.displayLocality.value;
                      final displayText = locality.isNotEmpty
                          ? locality
                          : city.isNotEmpty
                          ? city
                          : 'Select Location';
                      return Text(
                        displayText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: width < 360 ? 14 : 16,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    }),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.white70,
                    size: width < 360 ? 20 : 24,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 8),

          /// NOTIFICATIONS BELL
          Icon(
            Icons.notifications_none_rounded,
            color: Colors.white,
            size: width < 360 ? 20 : 24,
          ),
          const SizedBox(width: 16),

          /// AVATAR
          Obx(() {
            final profileImageUrl = _controller.profileImageUrl;
            return ClipOval(
              child: profileImageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: profileImageUrl,
                      width: width < 360 ? 32 : 36,
                      height: width < 360 ? 32 : 36,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Shimmer.fromColors(
                        baseColor: Colors.grey.shade800,
                        highlightColor: Colors.grey.shade700,
                        child: CircleAvatar(radius: width < 360 ? 16 : 18),
                      ),
                      errorWidget: (_, __, ___) => CircleAvatar(
                        radius: width < 360 ? 16 : 18,
                        backgroundColor: const Color(0xFF1A1A1A),
                        child: const Icon(Icons.person, color: Colors.white38),
                      ),
                    )
                  : CircleAvatar(
                      radius: width < 360 ? 16 : 18,
                      backgroundColor: const Color(0xFF1A1A1A),
                      child: const Icon(Icons.person, color: Colors.white38),
                    ),
            );
          }),
        ],
      ),
    );
  }
}
