import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
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

    final avatarSize = context.minDimensionPct(14).clamp(48.0, 60.0);

    return Obx(() {
      final user = controller.rxUser.value;
      final name = user?.fullName.isNotEmpty == true ? user!.fullName : 'User';
      final imageUrl = controller.profileImageUrl;
      final tier = user?.tier ?? TierHelper.getTierFromXp(user?.xpPoints ?? 100);
      final tierGradient = TierHelper.getTierGradient(tier);

      return Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(context.minDimensionPct(5)),
            bottomRight: Radius.circular(context.minDimensionPct(5)),
          ),
          border: Border(
            left: const BorderSide(color: AppColors.divider),
            right: const BorderSide(color: AppColors.divider),
            bottom: const BorderSide(color: AppColors.divider),
          ),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(context.minDimensionPct(5)),
            bottomRight: Radius.circular(context.minDimensionPct(5)),
          ),
          child: InkWell(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(context.minDimensionPct(5)),
              bottomRight: Radius.circular(context.minDimensionPct(5)),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                context.widthPct(5),
                context.heightPct(1),
                context.widthPct(5),
                context.heightPct(2),
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
                          color: AppColors.accent.withValues(alpha: 0.2),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: imageUrl.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: imageUrl,
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
                                child: const Icon(Icons.person, color: AppColors.muted),
                              ),
                            )
                          : CircleAvatar(
                              radius: avatarSize / 2,
                              backgroundColor: AppColors.card,
                              child: const Icon(Icons.person, color: AppColors.muted),
                            ),
                    ),
                  ),
                  SizedBox(width: context.widthPct(4)),

                  /// USER NAME + TIER PILL BADGE
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.headlineSm.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: context.responsiveFont(16),
                          ),
                        ),
                        SizedBox(height: context.heightPct(0.6)),

                        /// TIER GRADIENT PILL BADGE & GREEN FIRE STREAK PILL
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.widthPct(2.5),
                                vertical: context.heightPct(0.3),
                              ),
                              decoration: BoxDecoration(
                                gradient: tierGradient,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                tier.toUpperCase(),
                                style: AppTypography.labelCaps10.copyWith(
                                  color: AppColors.textPrimary,
                                  fontSize: context.responsiveFont(10),
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ),
                            SizedBox(width: context.widthPct(2)),

                            /// GREEN FIRE ACTIVE STREAK PILL
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.widthPct(2),
                                vertical: context.heightPct(0.3),
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.accent.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.accent.withValues(alpha: 0.4),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.accent.withValues(alpha: 0.15),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.local_fire_department_rounded,
                                    color: AppColors.accent,
                                    size: 13,
                                  ),
                                  SizedBox(width: context.widthPct(1)),
                                  Text(
                                    '5 Days',
                                    style: AppTypography.labelCaps10.copyWith(
                                      color: AppColors.accent,
                                      fontSize: context.responsiveFont(10),
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
