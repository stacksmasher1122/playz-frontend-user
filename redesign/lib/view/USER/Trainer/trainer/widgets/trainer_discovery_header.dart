import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/user_profile_controller.dart';
import 'package:redesign/controller/maps_controller.dart';
import 'package:redesign/view/USER/Maps/maps_setup/maps_setup_screen.dart';
import 'package:redesign/view/USER/Trainer/trainer_register/trainer_register_screen.dart';

import 'trainer_join_card.dart';
import 'package:redesign/theme/responsive_helper.dart';

class TrainerDiscoveryHeader extends StatelessWidget {
  const TrainerDiscoveryHeader({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<UserProfileController>();

    final avatarSize = context.minDimensionPct(9).clamp(32.0, 40.0);
    final iconSize = context.minDimensionPct(6).clamp(20.0, 26.0);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.widthPct(5)),
      child: Column(
        children: [
          Row(
            children: [
              /// LOCATION TEXT + DROPDOWN ICON (Dynamic)
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            LocationSelectSliverScreen(),
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
                final profileImageUrl = controller.profileImageUrl;
                return ClipOval(
                  child: profileImageUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: profileImageUrl,
                          width: avatarSize,
                          height: avatarSize,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Shimmer.fromColors(
                            baseColor: AppColors.surfaceElevated.withValues(alpha: 0.6),
                            highlightColor: AppColors.borderDark.withValues(alpha: 0.8),
                            child: CircleAvatar(radius: avatarSize / 2),
                          ),
                          errorWidget: (_, __, ___) => CircleAvatar(
                            radius: avatarSize / 2,
                            backgroundColor: AppColors.card,
                            child: const Icon(
                              Icons.person,
                              color: AppColors.muted,
                            ),
                          ),
                        )
                      : CircleAvatar(
                          radius: avatarSize / 2,
                          backgroundColor: AppColors.card,
                          child: const Icon(
                            Icons.person,
                            color: AppColors.muted,
                          ),
                        ),
                );
              }),
            ],
          ),
          SizedBox(height: context.heightPct(1.8)),
          TextField(
            cursorColor: AppColors.accent,
            style: AppTypography.bodyMd.copyWith(
              color: AppColors.textPrimary,
              fontSize: context.responsiveFont(13),
            ),
            decoration: InputDecoration(
              hintText: 'Search trainers, sports...',
              hintStyle: AppTypography.bodyMd.copyWith(
                color: AppColors.muted,
                fontSize: context.responsiveFont(13),
              ),
              prefixIcon: const Icon(Icons.search, color: AppColors.muted),
              suffixIcon: const Icon(Icons.tune, color: AppColors.muted),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          SizedBox(height: context.heightPct(2.5)),
          TrainerJoinCard(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => TrainerJoinScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
