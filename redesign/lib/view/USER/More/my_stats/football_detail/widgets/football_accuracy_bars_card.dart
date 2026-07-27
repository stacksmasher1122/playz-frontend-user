import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/model/User_Models/More_Models/football_stats_detail_model.dart';

class FootballAccuracyBarsCard extends StatelessWidget {
  final FootballStatsDetailModel data;

  const FootballAccuracyBarsCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          _AccuracyItem(label: 'Shot Accuracy', pct: data.shotAccuracyPct),
          SizedBox(height: ResponsiveHelper.h(14)),
          _AccuracyItem(label: 'Pass Accuracy', pct: data.passAccuracyPct),
          SizedBox(height: ResponsiveHelper.h(14)),
          _AccuracyItem(label: 'Cross Accuracy', pct: data.crossAccuracyPct),
        ],
      ),
    );
  }
}

class _AccuracyItem extends StatelessWidget {
  final String label;
  final int pct;

  const _AccuracyItem({required this.label, required this.pct});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(color: AppColors.muted, fontSize: 12),
            ),
            Text(
              '$pct%',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: pct / 100,
            backgroundColor: const Color(0xFF242424),
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}
