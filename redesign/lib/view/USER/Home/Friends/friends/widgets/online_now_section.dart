import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Friends_Controller/friends_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';

class OnlineNowSection extends StatelessWidget {
  const OnlineNowSection({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final ctrl = Get.find<FriendsController>();

    return Obx(() {
      final onlineFriends = ctrl.friends.take(4).toList();

      if (onlineFriends.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              context.widthPct(4),
              0,
              context.widthPct(4),
              context.heightPct(1.5),
            ),
            child: Text(
              'Online Now',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.displayLg.copyWith(
                color: AppColors.textPrimary,
                fontSize: context.responsiveFont(20),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          SizedBox(
            height: context.heightPct(14),
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
              scrollDirection: Axis.horizontal,
              itemCount: onlineFriends.length,
              itemBuilder: (_, i) => OnlineAvatar(
                name: onlineFriends[i].fullName.split(' ').first,
                imageUrl: onlineFriends[i].profileImageUrl,
              ),
            ),
          ),
        ],
      );
    });
  }
}

class OnlineAvatar extends StatelessWidget {
  final String name;
  final String imageUrl;

  const OnlineAvatar({super.key, required this.name, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final avatarSize = context.minDimensionPct(14).clamp(48.0, 60.0);

    return Padding(
      padding: EdgeInsets.only(right: context.widthPct(4)),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.accent, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.3),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                padding: EdgeInsets.all(context.widthPct(0.8)),
                child: ClipOval(
                  child: imageUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: imageUrl,
                          width: avatarSize,
                          height: avatarSize,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => CircleAvatar(
                            radius: avatarSize / 2,
                            backgroundColor: AppColors.surface,
                          ),
                          errorWidget: (_, __, ___) => CircleAvatar(
                            radius: avatarSize / 2,
                            backgroundColor: AppColors.surface,
                            child: const Icon(Icons.person, color: AppColors.muted),
                          ),
                        )
                      : CircleAvatar(
                          radius: avatarSize / 2,
                          backgroundColor: AppColors.surface,
                          child: const Icon(Icons.person, color: AppColors.muted),
                        ),
                ),
              ),
              Positioned(
                bottom: context.heightPct(0.3),
                right: context.widthPct(0.5),
                child: Container(
                  height: 12,
                  width: 12,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.background, width: 2),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: context.heightPct(0.8)),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.bodySm.copyWith(
              color: AppColors.textPrimary,
              fontSize: context.responsiveFont(13),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
