import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/model/User_Models/More_Models/football_stats_detail_model.dart';

class FootballCoreStatsCard extends StatelessWidget {
  final FootballStatsDetailModel data;

  const FootballCoreStatsCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.w(16),
        vertical: ResponsiveHelper.h(16),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _CoreCol(
            label: 'Goals',
            value: '${data.goals}',
            sub: '${data.goalsPerMatch} / Match',
            isGreen: true,
          ),
          _CoreCol(
            label: 'Assists',
            value: '${data.assists}',
            sub: '${data.assistsPerMatch} / Match',
            isGreen: true,
          ),
          _CoreCol(
            label: 'G+A',
            value: '${data.goalContributions}',
            sub: '${data.gaPerMatch} / Match',
          ),
        ],
      ),
    );
  }
}

class _CoreCol extends StatelessWidget {
  final String label;
  final String value;
  final String sub;
  final bool isGreen;

  const _CoreCol({
    required this.label,
    required this.value,
    required this.sub,
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
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(height: 2),
        Text(
          sub,
          style: GoogleFonts.inter(color: AppColors.muted, fontSize: 10),
        ),
      ],
    );
  }
}
