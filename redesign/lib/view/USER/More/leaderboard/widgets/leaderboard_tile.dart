import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/model/User_Models/More_Models/leaderboard_model.dart';

class LeaderboardTile extends StatelessWidget {
  final LeaderboardPlayerModel player;

  const LeaderboardTile({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    final isUser = player.isCurrentUser;
    final avatarRadius = context.minDimensionPct(4.5).clamp(16.0, 22.0);

    return Container(
      margin: EdgeInsets.only(bottom: context.heightPct(1.2)),
      padding: EdgeInsets.symmetric(
        horizontal: context.widthPct(4),
        vertical: context.heightPct(1.5),
      ),
      decoration: BoxDecoration(
        color: isUser ? AppColors.accent.withValues(alpha: 0.15) : AppColors.card,
        borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
        border: isUser
            ? Border.all(color: AppColors.accent.withValues(alpha: 0.5), width: 1.5)
            : Border.all(color: AppColors.borderDark),
      ),
      child: Row(
        children: [
          // Rank Number
          SizedBox(
            width: context.widthPct(7).clamp(24.0, 32.0),
            child: Text(
              '${player.rank}',
              style: AppTypography.headlineSm.copyWith(
                color: isUser ? AppColors.accent : AppColors.textPrimary,
                fontSize: context.responsiveFont(14),
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
          SizedBox(width: context.widthPct(3.5)),

          // Name
          Expanded(
            child: Text(
              player.name,
              style: AppTypography.headlineSm.copyWith(
                color: isUser ? AppColors.accent : AppColors.textPrimary,
                fontSize: context.responsiveFont(14),
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Points
          Text(
            '${player.points.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} pts',
            style: AppTypography.headlineSm.copyWith(
              color: isUser ? AppColors.accent : AppColors.textPrimary,
              fontSize: context.responsiveFont(14),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
