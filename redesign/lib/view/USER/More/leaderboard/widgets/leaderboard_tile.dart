import 'package:flutter/material.dart';
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
            child: CircleAvatar(
              radius: avatarRadius,
              backgroundColor: AppColors.surface,
              backgroundImage: NetworkImage(player.avatarUrl),
            ),
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
}
