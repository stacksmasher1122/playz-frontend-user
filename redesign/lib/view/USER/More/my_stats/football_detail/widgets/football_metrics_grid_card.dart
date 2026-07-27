import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/model/User_Models/More_Models/football_stats_detail_model.dart';

class FootballMetricsGridCard extends StatelessWidget {
  final FootballStatsDetailModel data;

  const FootballMetricsGridCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                label: 'Min Played',
                value: data.minPlayed.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
              ),
            ),
            SizedBox(width: ResponsiveHelper.w(12)),
            Expanded(
              child: _MetricCard(
                label: 'Goals / 90',
                value: '${data.goalsPer90}',
              ),
            ),
          ],
        ),
        SizedBox(height: ResponsiveHelper.h(12)),
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                label: 'Assists / 90',
                value: '${data.assistsPer90}',
              ),
            ),
            SizedBox(width: ResponsiveHelper.w(12)),
            Expanded(
              child: _MetricCard(
                label: 'Shots on Target',
                value: '${data.shotsOnTarget}',
              ),
            ),
          ],
        ),
        SizedBox(height: ResponsiveHelper.h(12)),
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                label: 'Big Chances',
                value: '${data.bigChances}',
              ),
            ),
            SizedBox(width: ResponsiveHelper.w(12)),
            Expanded(
              child: _MetricCard(
                label: 'Key Passes',
                value: '${data.keyPasses}',
              ),
            ),
          ],
        ),
        SizedBox(height: ResponsiveHelper.h(12)),
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                label: 'Dribbles Won',
                value: '${data.dribblesWon}',
              ),
            ),
            SizedBox(width: ResponsiveHelper.w(12)),
            Expanded(
              child: _MetricCard(
                label: 'Succ Tackles',
                value: '${data.succTackles}',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;

  const _MetricCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(14)),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(color: AppColors.muted, fontSize: 11),
          ),
          SizedBox(height: ResponsiveHelper.h(6)),
          Text(
            value,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: ResponsiveHelper.sp(20),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
