import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/model/User_Models/More_Models/cricket_stats_detail_model.dart';

class CricketMilestonesFormatCard extends StatelessWidget {
  final CricketStatsDetailModel data;

  const CricketMilestonesFormatCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column: Milestones Box
        Expanded(
          child: Container(
            padding: EdgeInsets.all(ResponsiveHelper.w(14)),
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
                    const Icon(Icons.workspace_premium_outlined, color: AppColors.accent, size: 14),
                    SizedBox(width: ResponsiveHelper.w(4)),
                    Text(
                      'MILESTONES',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.sp(10),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ResponsiveHelper.h(10)),

                // 2x3 Grid
                Row(
                  children: [
                    Expanded(child: _MilestoneTile(label: '100s', value: '${data.hundreds}', isGreen: true)),
                    SizedBox(width: ResponsiveHelper.w(6)),
                    Expanded(child: _MilestoneTile(label: '75+', value: '${data.seventyFivesPlus}')),
                  ],
                ),
                SizedBox(height: ResponsiveHelper.h(8)),
                Row(
                  children: [
                    Expanded(child: _MilestoneTile(label: '50s', value: '${data.fifties}')),
                    SizedBox(width: ResponsiveHelper.w(6)),
                    Expanded(child: _MilestoneTile(label: '30+', value: '${data.thirtiesPlus}')),
                  ],
                ),
                SizedBox(height: ResponsiveHelper.h(8)),
                Row(
                  children: [
                    Expanded(child: _MilestoneTile(label: '4s', value: '${data.fours}')),
                    SizedBox(width: ResponsiveHelper.w(6)),
                    Expanded(child: _MilestoneTile(label: '6s', value: '${data.sixes}')),
                  ],
                ),
              ],
            ),
          ),
        ),

        SizedBox(width: ResponsiveHelper.w(12)),

        // Right Column: Format Donut Box
        Expanded(
          child: Container(
            padding: EdgeInsets.all(ResponsiveHelper.w(14)),
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
                    const Icon(Icons.pie_chart_outline, color: AppColors.accent, size: 14),
                    SizedBox(width: ResponsiveHelper.w(4)),
                    Text(
                      'FORMAT',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.sp(10),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ResponsiveHelper.h(16)),

                // Donut Ring Chart Center
                Center(
                  child: SizedBox(
                    width: 90,
                    height: 90,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: CircularProgressIndicator(
                            value: data.t20MatchesPct / 100,
                            strokeWidth: 9,
                            backgroundColor: const Color(0xFF242424),
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${data.totalMatches}',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: ResponsiveHelper.sp(18),
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              'Matches',
                              style: GoogleFonts.inter(
                                color: AppColors.muted,
                                fontSize: ResponsiveHelper.sp(9),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: ResponsiveHelper.h(14)),
                Center(
                  child: Text(
                    'Most Played: T20 (${data.t20MatchesPct}%)',
                    style: GoogleFonts.inter(
                      color: AppColors.muted,
                      fontSize: ResponsiveHelper.sp(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MilestoneTile extends StatelessWidget {
  final String label;
  final String value;
  final bool isGreen;

  const _MilestoneTile({
    required this.label,
    required this.value,
    this.isGreen = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.inter(color: AppColors.muted, fontSize: 9),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.inter(
              color: isGreen ? AppColors.accent : Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
