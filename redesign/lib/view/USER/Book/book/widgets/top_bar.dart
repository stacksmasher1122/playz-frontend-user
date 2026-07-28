import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/maps_controller.dart';
import 'package:redesign/controller/user_profile_controller.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/view/USER/Maps/maps_setup/maps_setup_screen.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  final _controller = Get.find<UserProfileController>();

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    final avatarSize = context.minDimensionPct(9).clamp(32.0, 40.0);
    final iconSize = context.minDimensionPct(6).clamp(20.0, 26.0);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.widthPct(5)),
      child: Row(
        children: [
          /// LOCATION TEXT + DROPDOWN ICON (Dynamic)
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
                    size: iconSize,
                  ),
                  SizedBox(width: context.widthPct(1.5)),
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
                        style: AppTypography.headlineSm.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: context.responsiveFont(15),
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    }),
                  ),
                  SizedBox(width: context.widthPct(1)),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.textSecondary,
                    size: iconSize,
                  ),
                ],
              ),
            ),
          ),

          SizedBox(width: context.widthPct(2)),

          /// NOTIFICATIONS BELL
          Icon(
            Icons.notifications_none_rounded,
            color: AppColors.textPrimary,
            size: iconSize,
          ),

          SizedBox(width: context.widthPct(3)),

          /// AVATAR
          Obx(() {
            final profileImageUrl = _controller.profileImageUrl;
            return ClipOval(
              child: profileImageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: profileImageUrl,
                      width: avatarSize,
                      height: avatarSize,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => CircleAvatar(
                        radius: avatarSize / 2,
                        backgroundColor: AppColors.card,
                      ),
                      errorWidget: (_, __, ___) => CircleAvatar(
                        radius: avatarSize / 2,
                        backgroundColor: AppColors.card,
                        child: const Icon(Icons.person, color: AppColors.muted),
                      ),
                    )
                  : CircleAvatar(
                      radius: avatarSize / 2,
                      backgroundColor: AppColors.card,
                      child: const Icon(Icons.person, color: AppColors.muted),
                    ),
            );
          }),
        ],
      ),
    );
  }
}
