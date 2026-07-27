import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/model/User_Models/More_Models/my_stats_overview_model.dart';

class MyStatsSportCard extends StatelessWidget {
  final MyStatsOverviewItem item;
  final VoidCallback onTap;

  const MyStatsSportCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveHelper.h(16)),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.w(20),
              vertical: ResponsiveHelper.h(20),
            ),
            child: Row(
              children: [
                // Left Green Icon Badge
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: Color(0xFF1E2620),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    item.icon,
                    color: AppColors.accent,
                    size: 24,
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(16)),

                // Title & Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.sportName,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: ResponsiveHelper.sp(20),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: ResponsiveHelper.h(2)),
                      Text(
                        item.subtitle,
                        style: GoogleFonts.inter(
                          color: Colors.white70,
                          fontSize: ResponsiveHelper.sp(13),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: ResponsiveHelper.w(12)),

                // Right Column: MATCHES + Green Count Number
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'MATCHES',
                      style: GoogleFonts.inter(
                        color: AppColors.muted,
                        fontSize: ResponsiveHelper.sp(11),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.h(2)),
                    Text(
                      '${item.matchesCount}',
                      style: GoogleFonts.inter(
                        color: AppColors.accent,
                        fontSize: ResponsiveHelper.sp(26),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
