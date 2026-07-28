import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/model/User_Models/More_Models/leaderboard_model.dart';

class LeaderboardTile extends StatelessWidget {
  final LeaderboardPlayerModel player;

  const LeaderboardTile({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    final isUser = player.isCurrentUser;

    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveHelper.h(10)),
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.w(16),
        vertical: ResponsiveHelper.h(12),
      ),
      decoration: BoxDecoration(
        color: isUser ? const Color(0xFF16251C) : const Color(0xFF181818),
        borderRadius: BorderRadius.circular(16),
        border: isUser
            ? Border.all(color: AppColors.accent.withValues(alpha: 0.5), width: 1.5)
            : null,
      ),
      child: Row(
        children: [
          // Rank Number
          SizedBox(
            width: 28,
            child: Text(
              '${player.rank}',
              style: GoogleFonts.inter(
                color: isUser ? AppColors.accent : Colors.white,
                fontSize: ResponsiveHelper.sp(14),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: ResponsiveHelper.w(8)),

          // Avatar Image
          Container(
            padding: EdgeInsets.all(isUser ? 1.5 : 0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: isUser ? Border.all(color: AppColors.accent, width: 1.5) : null,
            ),
            child: CircleAvatar(
              radius: ResponsiveHelper.w(18),
              backgroundColor: const Color(0xFF2B2B2B),
              backgroundImage: NetworkImage(player.avatarUrl),
            ),
          ),
          SizedBox(width: ResponsiveHelper.w(14)),

          // Name
          Expanded(
            child: Text(
              player.name,
              style: GoogleFonts.inter(
                color: isUser ? AppColors.accent : Colors.white,
                fontSize: ResponsiveHelper.sp(14),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Points
          Text(
            '${player.points.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} pts',
            style: GoogleFonts.inter(
              color: isUser ? AppColors.accent : Colors.white,
              fontSize: ResponsiveHelper.sp(14),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
