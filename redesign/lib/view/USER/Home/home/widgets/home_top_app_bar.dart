import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/controller/maps_controller.dart';
import 'package:redesign/controller/user_profile_controller.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/view/USER/Maps/maps_setup/maps_setup_screen.dart';
import 'home_shimmer.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'notification_screen.dart'; // D3 Fix: Referee Notifications Import

/* ============================================================
   TOP APP BAR
   ============================================================ */
class HomeTopAppBar extends StatelessWidget {
  HomeTopAppBar({super.key});

  final _controller = Get.find<UserProfileController>();

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(20)),
      child: Row(
        children: [
          /// LOCATION TEXT + DROPDOWN ICON together
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => LocationSelectSliverScreen(),
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
                  SizedBox(width: 6),
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

          SizedBox(width: 8),

          /// NOTIFICATIONS BELL
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NotificationsScreen(),
                ),
              );
            },
            child: Icon(
              Icons.notifications_none_rounded,
              color: Colors.white,
              size: width < 360 ? 20 : 24,
            ),
          ),
          SizedBox(width: 16),

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
                      placeholder: (_, __) => HomeShimmer(
                        borderRadius: 20,
                        width: width < 360 ? 32 : 36,
                        height: width < 360 ? 32 : 36,
                      ),
                      errorWidget: (_, __, ___) => HomeShimmer(
                        width: width < 360 ? 32 : 36,
                        height: width < 360 ? 32 : 36,
                        borderRadius: 20,
                        child: Icon(Icons.person, color: Colors.white38),
                      ),
                    )
                  : HomeShimmer(
                      width: width < 360 ? 32 : 36,
                      height: width < 360 ? 32 : 36,
                      borderRadius: 20,
                      child: Icon(Icons.person, color: Colors.white38),
                    ),
            );
          }),
        ],
      ),
    );
  }
}
