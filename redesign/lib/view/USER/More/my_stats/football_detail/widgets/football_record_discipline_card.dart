import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/model/User_Models/More_Models/football_stats_detail_model.dart';

class FootballRecordDisciplineCard extends StatelessWidget {
  final FootballStatsDetailModel data;

  const FootballRecordDisciplineCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Column(
      children: [
        // 1. Record Card
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
              Text(
                'Record',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.sp(14),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: ResponsiveHelper.h(12)),

              // Tri-color Segmented Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: SizedBox(
                  height: 8,
                  child: Row(
                    children: [
                      Expanded(flex: data.wins, child: Container(color: AppColors.accent)),
                      const SizedBox(width: 2),
                      Expanded(flex: data.draws, child: Container(color: const Color(0xFF666666))),
                      const SizedBox(width: 2),
                      Expanded(flex: data.losses, child: Container(color: const Color(0xFFFF8A8A))),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${data.wins} W', style: GoogleFonts.inter(color: AppColors.accent, fontSize: 10, fontWeight: FontWeight.bold)),
                  Text('${data.draws} D', style: GoogleFonts.inter(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
                  Text('${data.losses} L', style: GoogleFonts.inter(color: const Color(0xFFFF8A8A), fontSize: 10, fontWeight: FontWeight.bold)),
                ],
              ),

              SizedBox(height: ResponsiveHelper.h(14)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Win %', style: GoogleFonts.inter(color: AppColors.muted, fontSize: 11)),
                      Text('${data.winRatePct}%', style: GoogleFonts.inter(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Goals in Wins', style: GoogleFonts.inter(color: AppColors.muted, fontSize: 11)),
                      Text('${data.goalsInWins}', style: GoogleFonts.inter(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),

        SizedBox(height: ResponsiveHelper.h(14)),

        // 2. Discipline Card
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
              Text(
                'Discipline',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.sp(14),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: ResponsiveHelper.h(12)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Yellow Card
                  Row(
                    children: [
                      Container(width: 14, height: 18, decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(2))),
                      const SizedBox(width: 6),
                      Text('${data.yellowCards}', style: GoogleFonts.inter(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),

                  // Red Card
                  Row(
                    children: [
                      Container(width: 14, height: 18, decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(2))),
                      const SizedBox(width: 6),
                      Text('${data.redCards}', style: GoogleFonts.inter(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),

                  // Fouls
                  Column(
                    children: [
                      Text('Fouls', style: GoogleFonts.inter(color: AppColors.muted, fontSize: 9)),
                      Text('${data.fouls}', style: GoogleFonts.inter(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),

                  // Offsides
                  Column(
                    children: [
                      Text('Offsides', style: GoogleFonts.inter(color: AppColors.muted, fontSize: 9)),
                      Text('${data.offsides}', style: GoogleFonts.inter(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
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
