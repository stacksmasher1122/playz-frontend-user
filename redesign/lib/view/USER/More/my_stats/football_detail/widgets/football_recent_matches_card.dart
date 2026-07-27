import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/model/User_Models/More_Models/football_stats_detail_model.dart';

class FootballRecentMatchesCard extends StatelessWidget {
  final List<FootballRecentMatchModel> matches;

  const FootballRecentMatchesCard({super.key, required this.matches});

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
              'VIEW ALL MATCHES',
              style: GoogleFonts.inter(
                color: AppColors.accent,
                fontSize: ResponsiveHelper.sp(10),
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        SizedBox(height: ResponsiveHelper.h(12)),

        ...matches.map((m) {
          final isHigh = m.rating >= 8.0;
          return Container(
            margin: EdgeInsets.only(bottom: ResponsiveHelper.h(10)),
            decoration: BoxDecoration(
              color: const Color(0xFF141414),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: Row(
              children: [
                // Left Color Stripe (Green for high rating / win)
                Container(
                  width: 4,
                  height: 64,
                  decoration: BoxDecoration(
                    color: isHigh ? AppColors.accent : const Color(0xFF444444),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(14),
                      bottomLeft: Radius.circular(14),
                    ),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(12)),

                // Opponent & Rating
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              m.opponent,
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: ResponsiveHelper.sp(14),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                if (m.isMvp)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                    margin: const EdgeInsets.only(right: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF332B10),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      'MVP',
                                      style: GoogleFonts.inter(color: Colors.amber, fontSize: 8, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                const Icon(Icons.sports_soccer, color: Colors.white70, size: 13),
                                if (m.hasYellowCard) ...[
                                  const SizedBox(width: 2),
                                  Container(width: 8, height: 11, decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(1))),
                                ],
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 2),
                        Row(
                          children: [
                            Text(
                              m.dateAndMinutes,
                              style: GoogleFonts.inter(color: AppColors.muted, fontSize: 10),
                            ),
                            SizedBox(width: ResponsiveHelper.w(8)),
                            const Icon(Icons.star, color: Colors.amber, size: 10),
                            const SizedBox(width: 2),
                            Text(
                              '${m.rating}',
                              style: GoogleFonts.inter(color: Colors.amber, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(width: ResponsiveHelper.w(12)),

                // Goals & Assists
                Padding(
                  padding: EdgeInsets.only(right: ResponsiveHelper.w(14)),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Text('G', style: GoogleFonts.inter(color: AppColors.muted, fontSize: 9)),
                          Text('${m.goals}', style: GoogleFonts.inter(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      SizedBox(width: ResponsiveHelper.w(10)),
                      Column(
                        children: [
                          Text('A', style: GoogleFonts.inter(color: AppColors.muted, fontSize: 9)),
                          Text('${m.assists}', style: GoogleFonts.inter(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
