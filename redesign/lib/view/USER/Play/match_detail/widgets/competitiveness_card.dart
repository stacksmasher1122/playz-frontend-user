import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class CompetitivenessCard extends StatelessWidget {
  final int score;

  const CompetitivenessCard({
    super.key,
    this.score = 94,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(18)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(18)),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: ResponsiveHelper.w(64),
            height: ResponsiveHelper.h(64),
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: score / 100.0,
                  strokeWidth: 5,
                  backgroundColor: Colors.white12,
                  color: AppColors.accent,
                ),
                Text(
                  "$score%",
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: ResponsiveHelper.sp(15),
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Match Competitiveness",
                  style: GoogleFonts.inter(
                    fontSize: ResponsiveHelper.sp(15),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Fairly balanced skill matchmaking based on player XP history",
                  style: GoogleFonts.inter(
                    fontSize: ResponsiveHelper.sp(12),
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
