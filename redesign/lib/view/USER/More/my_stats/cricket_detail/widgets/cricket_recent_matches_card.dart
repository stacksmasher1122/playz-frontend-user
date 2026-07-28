import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/model/User_Models/More_Models/cricket_stats_detail_model.dart';

class CricketRecentMatchesCard extends StatelessWidget {
  final List<CricketRecentMatchModel> matches;

  const CricketRecentMatchesCard({super.key, required this.matches});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Column(
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Matches',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: ResponsiveHelper.sp(16),
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'View All',
              style: GoogleFonts.inter(
                color: AppColors.accent,
                fontSize: ResponsiveHelper.sp(12),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: ResponsiveHelper.h(12)),

        ...matches.map((m) {
          return Container(
            margin: EdgeInsets.only(bottom: ResponsiveHelper.h(10)),
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.w(14),
              vertical: ResponsiveHelper.h(12),
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF141414),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        m.opponent,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: ResponsiveHelper.sp(14),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            m.formatAndDate,
                            style: GoogleFonts.inter(color: AppColors.muted, fontSize: 11),
                          ),
                          SizedBox(width: ResponsiveHelper.w(6)),
                          if (m.isCaptain)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                              decoration: BoxDecoration(
                                color: const Color(0xFF262626),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'CAPTAIN',
                                style: GoogleFonts.inter(color: Colors.white70, fontSize: 9, fontWeight: FontWeight.bold),
                              ),
                            ),
                          if (m.isMvp)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                              decoration: BoxDecoration(
                                color: const Color(0xFF332B10),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'MVP',
                                style: GoogleFonts.inter(color: Colors.amber, fontSize: 9, fontWeight: FontWeight.bold),
                              ),
                            ),
                          SizedBox(width: ResponsiveHelper.w(4)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                            decoration: BoxDecoration(
                              color: m.resultTag == 'WIN' ? const Color(0xFF1B2B20) : const Color(0xFF2B1B1B),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              m.resultTag,
                              style: GoogleFonts.inter(
                                color: m.resultTag == 'WIN' ? AppColors.accent : Colors.redAccent,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      m.runsAndBalls,
                      style: GoogleFonts.inter(
                        color: m.runsAndBalls.contains('*') || m.runsAndBalls.startsWith('6') || m.runsAndBalls.startsWith('8')
                            ? AppColors.accent
                            : Colors.white,
                        fontSize: ResponsiveHelper.sp(14),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      m.bowlingFigures,
                      style: GoogleFonts.inter(color: AppColors.muted, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
