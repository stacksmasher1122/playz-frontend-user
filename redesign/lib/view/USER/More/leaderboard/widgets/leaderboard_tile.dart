import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:redesign/model/User_Models/More_Models/leaderboard_model.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_dimensions.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class LeaderboardTile extends StatelessWidget {
  final LeaderboardPlayerModel player;

  const LeaderboardTile({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    final isUser = player.isCurrentUser;
    final avatarRadius = context.minDimensionPct(4.5).clamp(16.0, 22.0);
    final tierColor = player.tierColor;

    return Container(
      margin: EdgeInsets.only(bottom: context.heightPct(1.2)),
      padding: EdgeInsets.symmetric(
        horizontal: context.widthPct(3.5),
        vertical: context.heightPct(1.3),
      ),
      decoration: BoxDecoration(
        color: isUser ? AppColors.accent.withValues(alpha: 0.15) : AppColors.card,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: isUser
            ? Border.all(color: AppColors.accent.withValues(alpha: 0.6), width: 1.5)
            : Border.all(color: AppColors.borderDark),
      ),
      child: Row(
        children: [
          // Rank Number
          SizedBox(
            width: context.widthPct(9).clamp(28.0, 38.0),
            child: Text(
              player.formattedRank,
              style: AppTypography.headlineSm.copyWith(
                color: isUser ? AppColors.accent : AppColors.textPrimary,
                fontSize: context.responsiveFont(13),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: context.widthPct(2)),

          // Avatar Image
          Container(
            padding: EdgeInsets.all(isUser ? 1.5 : 0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: isUser ? Border.all(color: AppColors.accent, width: 1.5) : null,
            ),
            child: _buildAvatar(player.avatarUrl, avatarRadius),
          ),
          SizedBox(width: context.widthPct(3)),

          // Name & Tier Pill
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  player.name,
                  style: AppTypography.headlineSm.copyWith(
                    color: isUser ? AppColors.accent : AppColors.textPrimary,
                    fontSize: context.responsiveFont(13),
                    fontWeight: isUser ? FontWeight.bold : FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: context.heightPct(0.3)),
                Text(
                  player.tierName,
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
            '${player.formattedPoints} pts',
            style: AppTypography.headlineSm.copyWith(
              color: isUser ? AppColors.accent : AppColors.textPrimary,
              fontSize: context.responsiveFont(13),
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
            // Head silhouette
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
            // Shoulders/Body silhouette
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
