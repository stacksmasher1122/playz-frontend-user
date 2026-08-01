import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:redesign/model/User_Models/More_Models/leaderboard_model.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_dimensions.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class LeagueSections extends StatelessWidget {
  final List<LeaderboardPlayerModel> players;

  const LeagueSections({super.key, required this.players});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    if (players.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: context.heightPct(4)),
          child: Text(
            'No players found in this ranking scope.',
            style: AppTypography.bodyMd.copyWith(color: AppColors.muted),
          ),
        ),
      );
    }

    // Players are already sorted by rank from the controller
    // Cap the visible list to top 50
    const int maxVisible = 50;
    final top50 = players.length > maxVisible ? players.sublist(0, maxVisible) : players;

    // Find the current user — check if they are outside the top 50
    final me = players.firstWhere(
      (p) => p.isCurrentUser,
      orElse: () => players.first,
    );
    final myRankNumber = me.rank;
    final isCurrentUserOutsideList = me.isCurrentUser && myRankNumber > maxVisible;

    return Padding(
      padding: EdgeInsets.only(
        left: context.widthPct(4),
        right: context.widthPct(4),
        top: context.heightPct(2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Flat list of top 50 — no league headers
          ...top50.map((p) => _RankRowItem(player: p)),

          // If current user is outside top 50, show separator + their tile
          if (isCurrentUserOutsideList) ...[
            Padding(
              padding: EdgeInsets.symmetric(vertical: context.heightPct(1.2)),
              child: Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: AppColors.borderDark,
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: context.widthPct(3)),
                    child: Text(
                      '• • •',
                      style: AppTypography.bodyXs.copyWith(
                        color: AppColors.muted,
                        letterSpacing: 4,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: AppColors.borderDark,
                      thickness: 1,
                    ),
                  ),
                ],
              ),
            ),
            _RankRowItem(player: me),
          ],
        ],
      ),
    );
  }
}

class _RankRowItem extends StatelessWidget {
  final LeaderboardPlayerModel player;

  const _RankRowItem({required this.player});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final isMe = player.isCurrentUser;
    final avatarRadius = context.minDimensionPct(4.0).clamp(14.0, 18.0);

    return Container(
      margin: EdgeInsets.only(bottom: context.heightPct(0.8)),
      padding: EdgeInsets.symmetric(
        horizontal: context.widthPct(3.5),
        vertical: context.heightPct(1.2),
      ),
      decoration: BoxDecoration(
        color: isMe ? AppColors.accent.withValues(alpha: 0.15) : AppColors.card,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(
          color: isMe ? AppColors.accent.withValues(alpha: 0.6) : AppColors.borderDark,
          width: isMe ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          // Rank Number
          SizedBox(
            width: context.widthPct(9).clamp(28.0, 38.0),
            child: Text(
              player.formattedRank,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.headlineSm.copyWith(
                color: isMe ? AppColors.accent : AppColors.textPrimary,
                fontSize: context.responsiveFont(13),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: context.widthPct(2)),

          // Avatar
          _buildAvatar(player.avatarUrl, avatarRadius),
          SizedBox(width: context.widthPct(3)),

          // Name
          Expanded(
            child: Text(
              player.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.headlineSm.copyWith(
                color: isMe ? AppColors.accent : AppColors.textPrimary,
                fontSize: context.responsiveFont(13),
                fontWeight: isMe ? FontWeight.bold : FontWeight.w600,
              ),
            ),
          ),

          SizedBox(width: context.widthPct(2)),

          // Points
          Text(
            '${player.formattedPoints} pts',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.headlineSm.copyWith(
              color: isMe ? AppColors.accent : AppColors.textPrimary,
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
    if (!_isValidHttpUrl(url)) return _buildFallbackAvatar(radius);
    return CachedNetworkImage(
      imageUrl: url.trim(),
      imageBuilder: (context, imageProvider) => CircleAvatar(
        radius: radius,
        backgroundImage: imageProvider,
      ),
      placeholder: (_, __) => _buildFallbackAvatar(radius),
      errorWidget: (_, __, ___) => _buildFallbackAvatar(radius),
    );
  }

  Widget _buildFallbackAvatar(double radius) {
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
                  borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
