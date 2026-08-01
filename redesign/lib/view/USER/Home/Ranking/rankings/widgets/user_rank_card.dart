import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:redesign/model/User_Models/More_Models/leaderboard_model.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_dimensions.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class UserRankCard extends StatelessWidget {
  final LeaderboardPlayerModel userPlayer;
  final String scopeName;

  const UserRankCard({
    super.key,
    required this.userPlayer,
    this.scopeName = 'Global',
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final tierColor = userPlayer.tierColor;
    final avatarRadius = context.minDimensionPct(6.5).clamp(24.0, 30.0);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.widthPct(4),
        vertical: context.heightPct(1),
      ),
      child: Container(
        padding: EdgeInsets.all(context.widthPct(4)),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
          border: Border.all(color: AppColors.borderDark),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// USER INFO ROW
            Row(
              children: [
                // Avatar
                _buildAvatar(userPlayer.avatarUrl, avatarRadius),
                SizedBox(width: context.widthPct(3.5)),

                // Name & Tier Badge
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userPlayer.rawName.isNotEmpty ? userPlayer.rawName : userPlayer.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.headlineSm.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: context.responsiveFont(15),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: context.heightPct(0.5)),
                      _TierPill(
                        tierName: userPlayer.tierName,
                        color: tierColor,
                      ),
                    ],
                  ),
                ),

                SizedBox(width: context.widthPct(2)),

                // Dynamic Rank Number
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      userPlayer.formattedRank,
                      style: AppTypography.headlineLgMobile.copyWith(
                        color: AppColors.accent,
                        fontSize: context.responsiveFont(22),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      '$scopeName Rank',
                      style: AppTypography.bodyXs.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: context.responsiveFont(11),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: context.heightPct(2)),

            /// TIER PROGRESS BAR
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Target: ${userPlayer.targetTierName}',
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: context.responsiveFont(12),
                      ),
                    ),
                    Text(
                      '${userPlayer.totalOverallXp} / ${userPlayer.formattedTargetPoints} XP',
                      style: AppTypography.headlineSm.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: context.responsiveFont(12),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.heightPct(0.8)),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                  child: LinearProgressIndicator(
                    value: userPlayer.progressRatio,
                    minHeight: 8,
                    backgroundColor: AppColors.surface,
                    valueColor: AlwaysStoppedAnimation<Color>(tierColor),
                  ),
                ),
              ],
            ),
          ],
        ),
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

class _TierPill extends StatelessWidget {
  final String tierName;
  final Color color;

  const _TierPill({
    required this.tierName,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.widthPct(2.5),
        vertical: context.heightPct(0.3),
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        tierName,
        style: AppTypography.labelCaps10.copyWith(
          color: color,
          fontSize: context.responsiveFont(10),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
