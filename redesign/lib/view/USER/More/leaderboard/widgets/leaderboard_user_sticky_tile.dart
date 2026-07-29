import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/model/User_Models/More_Models/leaderboard_model.dart';

class LeaderboardUserStickyTile extends StatelessWidget {
  final LeaderboardPlayerModel userPlayer;

  const LeaderboardUserStickyTile({super.key, required this.userPlayer});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final avatarRadius = context.minDimensionPct(4.5).clamp(16.0, 22.0);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.widthPct(4),
        vertical: context.heightPct(1.5),
      ),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.8), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Rank Number
          SizedBox(
            width: context.widthPct(7).clamp(24.0, 32.0),
            child: Text(
              '${userPlayer.rank}',
              style: AppTypography.headlineSm.copyWith(
                color: AppColors.accent,
                fontSize: context.responsiveFont(15),
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
            child: CircleAvatar(
              radius: avatarRadius,
              backgroundColor: AppColors.surface,
              backgroundImage: NetworkImage(userPlayer.avatarUrl),
            ),
          ),
          SizedBox(width: context.widthPct(3.5)),

          // Name
          Expanded(
            child: Text(
              userPlayer.name,
              style: AppTypography.headlineSm.copyWith(
                color: AppColors.accent,
                fontSize: context.responsiveFont(15),
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Points
          Text(
            '${userPlayer.points.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} pts',
            style: AppTypography.headlineSm.copyWith(
              color: AppColors.accent,
              fontSize: context.responsiveFont(15),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
