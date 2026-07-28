import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/model/User_Models/More_Models/leaderboard_model.dart';

class LeaderboardUserStickyTile extends StatelessWidget {
  final LeaderboardPlayerModel userPlayer;

  const LeaderboardUserStickyTile({super.key, required this.userPlayer});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.w(16),
        vertical: ResponsiveHelper.h(12),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2820),
        borderRadius: BorderRadius.circular(16),
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
            width: 28,
            child: Text(
              '${userPlayer.rank}',
              style: GoogleFonts.inter(
                color: AppColors.accent,
                fontSize: ResponsiveHelper.sp(15),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: ResponsiveHelper.w(8)),

          // Avatar Image
          Container(
            padding: const EdgeInsets.all(1.5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.accent, width: 1.5),
            ),
            child: CircleAvatar(
              radius: ResponsiveHelper.w(18),
              backgroundColor: const Color(0xFF2B2B2B),
              backgroundImage: NetworkImage(userPlayer.avatarUrl),
            ),
          ),
          SizedBox(width: ResponsiveHelper.w(14)),

          // Name
          Expanded(
            child: Text(
              userPlayer.name,
              style: GoogleFonts.inter(
                color: AppColors.accent,
                fontSize: ResponsiveHelper.sp(15),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Points
          Text(
            '${userPlayer.points.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} pts',
            style: GoogleFonts.inter(
              color: AppColors.accent,
              fontSize: ResponsiveHelper.sp(15),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
