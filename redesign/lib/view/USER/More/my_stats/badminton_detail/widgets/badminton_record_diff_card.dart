import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/model/User_Models/More_Models/badminton_stats_detail_model.dart';

class BadmintonRecordDiffCard extends StatelessWidget {
  final BadmintonStatsDetailModel data;

  const BadmintonRecordDiffCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Column(
      children: [
        // 1. MATCH RECORD Card
        Container(
          padding: EdgeInsets.all(ResponsiveHelper.w(16)),
          decoration: BoxDecoration(
            color: const Color(0xFF141414),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'MATCH RECORD',
                    style: GoogleFonts.inter(
                      color: AppColors.muted,
                      fontSize: ResponsiveHelper.sp(11),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const Icon(Icons.emoji_events_outlined, color: AppColors.accent, size: 16),
                ],
              ),
              SizedBox(height: ResponsiveHelper.h(10)),
              Text(
                '${data.winRatePct}% Win',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.sp(24),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 2),
              Text(
                '${data.wins} Wins - ${data.losses} Losses',
                style: GoogleFonts.inter(color: AppColors.muted, fontSize: 12),
              ),
              SizedBox(height: ResponsiveHelper.h(10)),
              Row(
                children: [
                  Text(
                    'Season Win %: ',
                    style: GoogleFonts.inter(color: AppColors.muted, fontSize: 11),
                  ),
                  Text(
                    '${data.seasonWinPct}%',
                    style: GoogleFonts.inter(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: ResponsiveHelper.w(14)),
                  Text(
                    'Best Streak: ',
                    style: GoogleFonts.inter(color: AppColors.muted, fontSize: 11),
                  ),
                  Text(
                    '${data.bestStreak}',
                    style: GoogleFonts.inter(color: AppColors.accent, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),

        SizedBox(height: ResponsiveHelper.h(14)),

        // 2. POINTS DIFF Card
        Container(
          padding: EdgeInsets.all(ResponsiveHelper.w(16)),
          decoration: BoxDecoration(
            color: const Color(0xFF141414),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'POINTS DIFF',
                    style: GoogleFonts.inter(
                      color: AppColors.muted,
                      fontSize: ResponsiveHelper.sp(11),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const Icon(Icons.trending_up, color: AppColors.accent, size: 16),
                ],
              ),
              SizedBox(height: ResponsiveHelper.h(10)),
              Text(
                '+${data.pointsDiff}',
                style: GoogleFonts.inter(
                  color: AppColors.accent,
                  fontSize: ResponsiveHelper.sp(26),
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 2),
              Text(
                '${data.pointsScored.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} Scored / ${data.pointsConceded.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} Conceded',
                style: GoogleFonts.inter(color: AppColors.muted, fontSize: 12),
              ),
              SizedBox(height: ResponsiveHelper.h(8)),
              Row(
                children: [
                  Text(
                    '+${data.avgDiffPerMatch} ',
                    style: GoogleFonts.inter(color: AppColors.accent, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Avg per match',
                    style: GoogleFonts.inter(color: AppColors.muted, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
