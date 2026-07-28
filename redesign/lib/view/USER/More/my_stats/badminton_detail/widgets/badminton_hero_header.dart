import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/model/User_Models/More_Models/badminton_stats_detail_model.dart';

class BadmintonHeroHeader extends StatelessWidget {
  final BadmintonStatsDetailModel data;

  const BadmintonHeroHeader({super.key, required this.data});

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
            Icons.sports,
            color: AppColors.accent,
            size: 32,
          ),
        ),
        SizedBox(height: ResponsiveHelper.h(12)),

        // Badminton Stats Title
        Text(
          'Badminton Stats',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: ResponsiveHelper.sp(24),
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(height: ResponsiveHelper.h(6)),

        // 32 Matches + Platinum Tier Pill
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
                color: const Color(0xFF1B2B20),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.accent.withValues(alpha: 0.5)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.emoji_events, color: AppColors.accent, size: 13),
                  SizedBox(width: ResponsiveHelper.w(4)),
                  Text(
                    data.tierName,
                    style: GoogleFonts.inter(
                      color: AppColors.accent,
                      fontSize: ResponsiveHelper.sp(11),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: ResponsiveHelper.h(4)),

        // Subtitle
        Text(
          data.playerRole,
          style: GoogleFonts.inter(
            color: AppColors.muted,
            fontSize: ResponsiveHelper.sp(12),
          ),
        ),
      ],
    );
  }
}
