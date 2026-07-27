import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/model/User_Models/More_Models/cricket_stats_detail_model.dart';

class CricketBattingCard extends StatelessWidget {
  final CricketStatsDetailModel data;

  const CricketBattingCard({super.key, required this.data});

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
          // Section Title
          Row(
            children: [
              const Icon(Icons.arrow_drop_down, color: AppColors.accent, size: 18),
              SizedBox(width: ResponsiveHelper.w(4)),
              Text(
                'BATTING',
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
              Expanded(child: _GridCell(label: 'Runs', value: '${data.runs}', isGreen: true)),
              Expanded(child: _GridCell(label: 'Avg', value: '${data.avg}')),
              Expanded(child: _GridCell(label: 'SR', value: '${data.strikeRate}')),
            ],
          ),
          SizedBox(height: ResponsiveHelper.h(14)),

          // Row 2
          Row(
            children: [
              Expanded(child: _GridCell(label: 'Balls Faced', value: '${data.ballsFaced}')),
              Expanded(child: _GridCell(label: 'Boundary %', value: '${data.boundaryPct.toStringAsFixed(0)}%')),
              Expanded(child: _GridCell(label: 'Avg Runs/M', value: '${data.avgRunsPerMatch}')),
            ],
          ),
          SizedBox(height: ResponsiveHelper.h(14)),

          // Row 3
          Row(
            children: [
              Expanded(child: _GridCell(label: 'HS', value: data.highestScore)),
              Expanded(child: _GridCell(label: 'Innings', value: '${data.innings}')),
              Expanded(child: _GridCell(label: 'NO / Ducks', value: '${data.notOuts} / ${data.ducks}')),
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
