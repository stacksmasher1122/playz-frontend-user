import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class HostReliabilityCard extends StatelessWidget {
  final int reliabilityScore;

  const HostReliabilityCard({
    super.key,
    this.reliabilityScore = 98,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveHelper.w(18)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(18)),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "HOST RELIABILITY & SCORE",
            style: GoogleFonts.inter(
              fontSize: ResponsiveHelper.sp(11),
              letterSpacing: 0.8,
              fontWeight: FontWeight.bold,
              color: AppColors.muted,
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Text(
                "$reliabilityScore%",
                style: GoogleFonts.inter(
                  fontSize: ResponsiveHelper.sp(36),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Verified Trusted Host 🛡️",
                      style: GoogleFonts.inter(
                        color: AppColors.accent,
                        fontSize: ResponsiveHelper.sp(14),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "98% match completion rate with zero no-shows",
                      style: GoogleFonts.inter(
                        color: AppColors.muted,
                        fontSize: ResponsiveHelper.sp(11.5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
