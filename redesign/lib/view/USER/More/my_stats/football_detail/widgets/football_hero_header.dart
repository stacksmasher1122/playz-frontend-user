import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/model/User_Models/More_Models/football_stats_detail_model.dart';

class FootballHeroHeader extends StatelessWidget {
  final FootballStatsDetailModel data;

  const FootballHeroHeader({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Column(
      children: [
        // Circular Icon Badge
        Container(
          width: 64,
          height: 64,
          decoration: const BoxDecoration(
            color: Color(0xFF1E2620),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.sports_soccer,
            color: AppColors.accent,
            size: 32,
          ),
        ),
        SizedBox(height: ResponsiveHelper.h(12)),

        // Football Stats Title
        Text(
          'Football Stats',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: ResponsiveHelper.sp(24),
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(height: 2),

        // Role & Club
        Text(
          data.playerRole,
          style: GoogleFonts.inter(
            color: AppColors.muted,
            fontSize: ResponsiveHelper.sp(12),
          ),
        ),
        SizedBox(height: ResponsiveHelper.h(8)),

        // 18 Matches + Gold Tier Pill
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${data.totalMatches} Matches',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: ResponsiveHelper.sp(16),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: ResponsiveHelper.w(10)),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.w(10),
                vertical: ResponsiveHelper.h(4),
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF332B10),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.withValues(alpha: 0.6)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.emoji_events, color: Colors.amber, size: 13),
                  SizedBox(width: ResponsiveHelper.w(4)),
                  Text(
                    data.tierName,
                    style: GoogleFonts.inter(
                      color: Colors.amber,
                      fontSize: ResponsiveHelper.sp(11),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
