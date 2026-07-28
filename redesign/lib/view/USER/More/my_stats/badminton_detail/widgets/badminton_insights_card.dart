import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class BadmintonInsightsCard extends StatelessWidget {
  final List<String> strengths;
  final List<String> weaknesses;

  const BadmintonInsightsCard({
    super.key,
    required this.strengths,
    required this.weaknesses,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.insights, color: AppColors.accent, size: 18),
            const SizedBox(width: 8),
            Text(
              'Technical Strengths & Insights',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: ResponsiveHelper.sp(14),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: ResponsiveHelper.h(10)),
        Container(
          padding: EdgeInsets.all(ResponsiveHelper.w(14)),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.divider),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Key Strengths',
                style: GoogleFonts.inter(
                  color: AppColors.accent,
                  fontSize: ResponsiveHelper.sp(13),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 6),
              ...strengths.map((s) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_circle_outline, color: AppColors.accent, size: 14),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            s,
                            style: GoogleFonts.inter(color: Colors.white70, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  )),
              const Divider(color: AppColors.divider, height: 20),
              Text(
                'Areas to Improve',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.sp(13),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 6),
              ...weaknesses.map((w) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.adjust_outlined, color: AppColors.muted, size: 14),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            w,
                            style: GoogleFonts.inter(color: Colors.white70, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }
}
