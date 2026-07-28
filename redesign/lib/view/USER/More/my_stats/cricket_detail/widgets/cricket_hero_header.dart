import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/model/User_Models/More_Models/cricket_stats_detail_model.dart';

class CricketHeroHeader extends StatelessWidget {
  final CricketStatsDetailModel data;

  const CricketHeroHeader({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Column(
      children: [
        // Subtitle role
        Text(
          data.playerRole,
          style: GoogleFonts.inter(
            color: AppColors.muted,
            fontSize: ResponsiveHelper.sp(12),
          ),
        ),
        SizedBox(height: ResponsiveHelper.h(16)),

        // Circular Icon Badge
        Container(
          width: 64,
          height: 64,
          decoration: const BoxDecoration(
            color: Color(0xFF1E2620),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.sports_cricket,
            color: AppColors.accent,
            size: 32,
          ),
        ),
        SizedBox(height: ResponsiveHelper.h(12)),

        // 24 Matches Title
        Text(
          '${data.totalMatches} Matches',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: ResponsiveHelper.sp(26),
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(height: 2),
        Text(
          'Lifetime Cricket Statistics',
          style: GoogleFonts.inter(
            color: AppColors.muted,
            fontSize: ResponsiveHelper.sp(13),
          ),
        ),
        SizedBox(height: ResponsiveHelper.h(10)),

        // Tier Badge Pill
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.w(12),
            vertical: ResponsiveHelper.h(4),
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white24),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.shield_outlined, color: Colors.white70, size: 14),
              SizedBox(width: ResponsiveHelper.w(4)),
              Text(
                data.tierName,
                style: GoogleFonts.inter(
                  color: Colors.white70,
                  fontSize: ResponsiveHelper.sp(10),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
