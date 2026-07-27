import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/model/User_Models/More_Models/cricket_stats_detail_model.dart';

class CricketBowlingCard extends StatelessWidget {
  final CricketStatsDetailModel data;

  const CricketBowlingCard({super.key, required this.data});

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.sports_baseball_outlined, color: AppColors.accent, size: 16),
              SizedBox(width: ResponsiveHelper.w(6)),
              Text(
                'BOWLING',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.sp(12),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.h(14)),

          // Row 1
          Row(
            children: [
              Expanded(child: _GridCell(label: 'Wickets', value: '${data.wickets}', isGreen: true)),
              Expanded(child: _GridCell(label: 'Best', value: data.bestBowling)),
              Expanded(child: _GridCell(label: 'Econ', value: '${data.economy}')),
            ],
          ),
          SizedBox(height: ResponsiveHelper.h(14)),

          // Row 2
          Row(
            children: [
              Expanded(child: _GridCell(label: 'Avg', value: '${data.bowlingAvg}')),
              Expanded(child: _GridCell(label: 'SR', value: '${data.bowlingStrikeRate}')),
              Expanded(child: _GridCell(label: 'O/M', value: '${data.overs} / ${data.maidens}')),
            ],
          ),
          SizedBox(height: ResponsiveHelper.h(14)),

          // Row 3
          Row(
            children: [
              Expanded(child: _GridCell(label: 'Dot %', value: '${data.dotPct.toStringAsFixed(0)}%')),
              Expanded(child: _GridCell(label: 'Runs Given', value: data.runsGiven.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'))),
              const Expanded(child: SizedBox.shrink()),
            ],
          ),
        ],
      ),
    );
  }
}

class _GridCell extends StatelessWidget {
  final String label;
  final String value;
  final bool isGreen;

  const _GridCell({
    required this.label,
    required this.value,
    this.isGreen = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: AppColors.muted,
            fontSize: ResponsiveHelper.sp(11),
          ),
        ),
        SizedBox(height: 2),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: GoogleFonts.inter(
              color: isGreen ? AppColors.accent : Colors.white,
              fontSize: ResponsiveHelper.sp(18),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
