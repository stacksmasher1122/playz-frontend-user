import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:redesign/model/User_Models/More_Models/leaderboard_model.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_dimensions.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class LeaderboardUserStickyTile extends StatelessWidget {
  final LeaderboardPlayerModel userPlayer;

  const LeaderboardUserStickyTile({super.key, required this.userPlayer});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final avatarRadius = context.minDimensionPct(4.5).clamp(16.0, 22.0);
    final tierColor = userPlayer.tierColor;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.widthPct(4),
        vertical: context.heightPct(1.4),
      ),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.9), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 14,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Rank Number
          SizedBox(
            width: context.widthPct(9).clamp(28.0, 38.0),
            child: Text(
              userPlayer.formattedRank,
              style: AppTypography.headlineSm.copyWith(
                color: AppColors.accent,
                fontSize: context.responsiveFont(14),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: context.widthPct(2)),

          // Avatar Image
          Container(
            padding: const EdgeInsets.all(1.5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.accent, width: 1.5),
            ),
            child: _buildAvatar(userPlayer.avatarUrl, avatarRadius),
          ),
          SizedBox(width: context.widthPct(3)),

          // Name & Tier Pill
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  userPlayer.name,
                  style: AppTypography.headlineSm.copyWith(
                    color: AppColors.accent,
                    fontSize: context.responsiveFont(14),
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: context.heightPct(0.3)),
                Text(
                  userPlayer.tierName,
                  style: AppTypography.labelCaps10.copyWith(
                    color: tierColor,
                    fontSize: context.responsiveFont(9),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Points
          Text(
            '${userPlayer.formattedPoints} pts',
            style: AppTypography.headlineSm.copyWith(
              color: AppColors.accent,
              fontSize: context.responsiveFont(14),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  bool _isValidHttpUrl(String? url) {
    if (url == null || url.trim().isEmpty) return false;
    final clean = url.trim();
    if (!clean.startsWith('http://') && !clean.startsWith('https://')) return false;
    try {
      final uri = Uri.parse(clean);
      return uri.host.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Widget _buildAvatar(String url, double radius) {
    if (!_isValidHttpUrl(url)) {
      return _buildGreyProfileAvatarImage(radius);
    }
    return CachedNetworkImage(
      imageUrl: url.trim(),
      imageBuilder: (context, imageProvider) => CircleAvatar(
        radius: radius,
        backgroundImage: imageProvider,
      ),
      placeholder: (_, __) => _buildGreyProfileAvatarImage(radius),
      errorWidget: (_, __, ___) => _buildGreyProfileAvatarImage(radius),
    );
  }

  Widget _buildGreyProfileAvatarImage(double radius) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: const BoxDecoration(
        color: Color(0xFF2C2C2E),
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: radius * 0.35,
              child: Container(
                width: radius * 0.72,
                height: radius * 0.72,
                decoration: const BoxDecoration(
                  color: Color(0xFF7C7C80),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -radius * 0.15,
              child: Container(
                width: radius * 1.35,
                height: radius * 0.9,
                decoration: const BoxDecoration(
                  color: Color(0xFF7C7C80),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(50),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
