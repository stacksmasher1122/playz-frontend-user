import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/model/User_Models/More_Models/badminton_stats_detail_model.dart';

class BadmintonRecentMatchesCard extends StatelessWidget {
  final List<BadmintonRecentMatchModel> matches;

  const BadmintonRecentMatchesCard({super.key, required this.matches});

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
                // Win/Loss Circle Badge
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: m.isWin ? const Color(0xFF1B2B20) : const Color(0xFF2B1B1B),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      m.isWin ? 'W' : 'L',
                      style: GoogleFonts.inter(
                        color: m.isWin ? AppColors.accent : Colors.redAccent,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(12)),

                // Opponent & Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              m.opponent,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: ResponsiveHelper.sp(14),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: ResponsiveHelper.w(6)),
                          if (m.isWin)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1C2C20),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.emoji_events, color: AppColors.accent, size: 9),
                                  const SizedBox(width: 2),
                                  Text(
                                    m.formatTag,
                                    style: GoogleFonts.inter(color: AppColors.accent, fontSize: 8, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 2),
                      Text(
                        m.matchDetails,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(color: AppColors.muted, fontSize: 10),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(8)),

                // Score Text & XP
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      m.scoreText,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.sp(14),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      m.xpGained,
                      style: GoogleFonts.inter(
                        color: AppColors.accent,
                        fontSize: ResponsiveHelper.sp(10),
                        fontWeight: FontWeight.bold,
                      ),
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
