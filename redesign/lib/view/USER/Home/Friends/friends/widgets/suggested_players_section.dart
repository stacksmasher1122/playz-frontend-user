import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Friends_Controller/friends_controller.dart';

class SuggestedPlayersSection extends StatelessWidget {
  const SuggestedPlayersSection({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final ctrl = Get.find<FriendsController>();

    return Obx(() {
      if (ctrl.isLoadingSuggested.value && ctrl.suggestedPlayers.isEmpty) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: context.heightPct(2)),
          child: const Center(
            child: CircularProgressIndicator(color: AppColors.accent),
          ),
        );
      }

      if (ctrl.suggestedPlayers.isEmpty) {
        return const SizedBox.shrink();
      }

      final double cardWidth = context.widthPct(38).clamp(135.0, 165.0);
      final double cardHeight = context.heightPct(24).clamp(200.0, 230.0);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Padding(
            padding: EdgeInsets.fromLTRB(
              context.widthPct(4),
              context.heightPct(1.5),
              context.widthPct(4),
              context.heightPct(1),
            ),
            child: Text(
              'Suggested for You',
              style: AppTypography.headlineSm.copyWith(
                color: AppColors.textPrimary,
                fontSize: context.responsiveFont(15),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Horizontal Instagram-style Carousel
          SizedBox(
            height: cardHeight,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: context.widthPct(3)),
              itemCount: ctrl.suggestedPlayers.length,
              itemBuilder: (context, index) {
                final player = ctrl.suggestedPlayers[index];
                final name = (player['fullName'] ?? 'Player').toString();
                final level = (player['level'] ?? 'Bronze').toString();
                final meta = (player['meta'] ?? 'Matching Sports').toString();
                final pic = (player['profileImageUrl'] ?? '').toString();

                return InstagramStyleSuggestedCard(
                  name: name,
                  level: level,
                  meta: meta,
                  profilePicUrl: pic,
                  cardWidth: cardWidth,
                  onAddPressed: () {
                    ctrl.sendFriendRequest(player);
                    Get.snackbar(
                      'Request Sent',
                      'Friend request sent to $name',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: AppColors.card,
                      colorText: AppColors.accent,
                      duration: const Duration(seconds: 2),
                    );
                  },
                );
              },
            ),
          ),
          SizedBox(height: context.heightPct(1.5)),
        ],
      );
    });
  }
}

class InstagramStyleSuggestedCard extends StatelessWidget {
  final String name;
  final String level;
  final String meta;
  final String profilePicUrl;
  final double cardWidth;
  final VoidCallback onAddPressed;

  const InstagramStyleSuggestedCard({
    super.key,
    required this.name,
    required this.level,
    required this.meta,
    required this.profilePicUrl,
    required this.cardWidth,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final double avatarSize = context.minDimensionPct(14).clamp(48.0, 58.0);

    return Container(
      width: cardWidth,
      margin: EdgeInsets.symmetric(horizontal: context.widthPct(1.5)),
      padding: EdgeInsets.all(context.widthPct(3)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderDark),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 4),

          // Avatar
          ClipRRect(
            borderRadius: BorderRadius.circular(avatarSize / 2),
            child: profilePicUrl.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: profilePicUrl,
                    width: avatarSize,
                    height: avatarSize,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      width: avatarSize,
                      height: avatarSize,
                      color: AppColors.surfaceElevated,
                      child: const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          color: AppColors.accent,
                        ),
                      ),
                    ),
                    errorWidget: (_, __, ___) =>
                        _buildPlaceholderAvatar(avatarSize),
                  )
                : _buildPlaceholderAvatar(avatarSize),
          ),

          // Name & Level / Matching metadata
          Column(
            children: [
              Text(
                name,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.bodyLg.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: context.responsiveFont(13),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                meta,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.muted,
                  fontSize: context.responsiveFont(10.5),
                ),
              ),
            ],
          ),

          // Bottom Action Button (Add Friend / Follow)
          SizedBox(
            width: double.infinity,
            height: context.heightPct(4.2).clamp(32.0, 36.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.background,
                elevation: 0,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: onAddPressed,
              child: Text(
                'Add Friend',
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.background,
                  fontWeight: FontWeight.bold,
                  fontSize: context.responsiveFont(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderAvatar(double size) {
    return Container(
      width: size,
      height: size,
      color: AppColors.surfaceElevated,
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : 'P',
          style: AppTypography.headlineSm.copyWith(
            color: AppColors.accent,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
