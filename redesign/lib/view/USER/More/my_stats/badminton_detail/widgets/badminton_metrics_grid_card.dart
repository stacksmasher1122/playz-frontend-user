import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/model/User_Models/More_Models/badminton_stats_detail_model.dart';

class BadmintonMetricsGridCard extends StatelessWidget {
  final BadmintonStatsDetailModel data;

  const BadmintonMetricsGridCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _MetricItemCard(
                label: 'Smash Winners',
                value: '${data.smashWinners}',
                subText: 'Success: ${data.smashSuccessPct}%',
                subColor: AppColors.accent,
              ),
            ),
            SizedBox(width: ResponsiveHelper.w(12)),
            Expanded(
              child: _MetricItemCard(
                label: 'Unforced Errors',
                value: '${data.unforcedErrors}',
                valueColor: const Color(0xFFFF8A8A),
              ),
            ),
          ],
        ),
        SizedBox(height: ResponsiveHelper.h(12)),
        Row(
          children: [
            Expanded(
              child: _MetricItemCard(
                label: 'Longest Rally',
                value: '${data.longestRally}',
                subText: 'Win Streak: ${data.rallyWinStreak}',
              ),
            ),
            SizedBox(width: ResponsiveHelper.w(12)),
            Expanded(
              child: _MetricItemCard(
                label: 'Serve Aces',
                value: '${data.serveAces}',
                valueColor: AppColors.accent,
                subText: 'Faults: ${data.serveFaults}',
                subColor: Colors.redAccent,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MetricItemCard extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final String? subText;
  final Color? subColor;

  const _MetricItemCard({
    required this.label,
    required this.value,
    this.valueColor,
    this.subText,
    this.subColor,
  });

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
            style: GoogleFonts.inter(
              color: AppColors.muted,
              fontSize: ResponsiveHelper.sp(11),
            ),
          ),
          SizedBox(height: ResponsiveHelper.h(10)),
          Text(
            value,
            style: GoogleFonts.inter(
              color: valueColor ?? Colors.white,
              fontSize: ResponsiveHelper.sp(22),
              fontWeight: FontWeight.bold,
            ),
          ),
          if (subText != null) ...[
            SizedBox(height: 4),
            Text(
              subText!,
              style: GoogleFonts.inter(
                color: subColor ?? AppColors.muted,
                fontSize: ResponsiveHelper.sp(10),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
