import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/model/User_Models/More_Models/cricket_stats_detail_model.dart';

class CricketFieldingRatingCard extends StatelessWidget {
  final CricketStatsDetailModel data;

  const CricketFieldingRatingCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Column(
      children: [
        // Fielding Box
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
                children: [
                  const Icon(Icons.shield_outlined, color: AppColors.accent, size: 16),
                  SizedBox(width: ResponsiveHelper.w(6)),
                  Text(
                    'FIELDING',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: ResponsiveHelper.sp(12),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
              SizedBox(height: ResponsiveHelper.h(12)),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Catches',
                          style: GoogleFonts.inter(color: AppColors.muted, fontSize: 11),
                        ),
                        Text(
                          '${data.catches}',
                          style: GoogleFonts.inter(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Run Outs',
                          style: GoogleFonts.inter(color: AppColors.muted, fontSize: 11),
                        ),
                        Text(
                          '${data.runOuts}',
                          style: GoogleFonts.inter(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        SizedBox(height: ResponsiveHelper.h(14)),

        // Rating Footer Bar
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.w(16),
            vertical: ResponsiveHelper.h(14),
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF141414),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _RatingCol(label: 'Player of Match', value: '${data.playerOfMatchCount}', isGreen: true),
              Container(width: 1, height: 28, color: Colors.white12),
              _RatingCol(label: 'Win %', value: '${data.winPercentage.toStringAsFixed(0)}%'),
              Container(width: 1, height: 28, color: Colors.white12),
              _RatingCol(label: 'Rating', value: '${data.rating}'),
            ],
          ),
        ),
      ],
    );
  }
}

class _RatingCol extends StatelessWidget {
  final String label;
  final String value;
  final bool isGreen;

  const _RatingCol({
    required this.label,
    required this.value,
    this.isGreen = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(color: AppColors.muted, fontSize: 11),
        ),
        SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.inter(
            color: isGreen ? AppColors.accent : Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
