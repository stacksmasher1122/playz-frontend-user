import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/model/User_Models/More_Models/badminton_stats_detail_model.dart';

class BadmintonStyleFormatCard extends StatelessWidget {
  final BadmintonStatsDetailModel data;

  const BadmintonStyleFormatCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Column(
      children: [
        // 1. PLAYING STYLE Card
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
              Text(
                'PLAYING STYLE',
                style: GoogleFonts.inter(
                  color: AppColors.muted,
                  fontSize: ResponsiveHelper.sp(11),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: ResponsiveHelper.h(12)),
              Row(
                children: [
                  Text(
                    data.playStyle,
                    style: GoogleFonts.inter(
                      color: AppColors.accent,
                      fontSize: ResponsiveHelper.sp(15),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: ResponsiveHelper.w(12)),
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        children: [
                          Text('Attack ', style: GoogleFonts.inter(color: AppColors.muted, fontSize: 11)),
                          Text('${data.attackPct}% ', style: GoogleFonts.inter(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                          Text('Defense ', style: GoogleFonts.inter(color: AppColors.muted, fontSize: 11)),
                          Text('${data.defensePct}% ', style: GoogleFonts.inter(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                          Text('Net Play ', style: GoogleFonts.inter(color: AppColors.muted, fontSize: 11)),
                          Text('${data.netPlayPct}%', style: GoogleFonts.inter(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        SizedBox(height: ResponsiveHelper.h(14)),

        // 2. FORMAT SPLIT Card
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
              Text(
                'FORMAT SPLIT',
                style: GoogleFonts.inter(
                  color: AppColors.muted,
                  fontSize: ResponsiveHelper.sp(11),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: ResponsiveHelper.h(12)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _LegendDot(color: AppColors.accent, label: 'Singles (${data.singlesPct}%)'),
                  _LegendDot(color: const Color(0xFF555555), label: 'Doubles (${data.doublesPct}%)'),
                  _LegendDot(color: const Color(0xFFE0E0E0), label: 'Mixed (${data.mixedPct}%)'),
                ],
              ),
              SizedBox(height: ResponsiveHelper.h(12)),

              // Segmented Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: SizedBox(
                  height: 8,
                  child: Row(
                    children: [
                      Expanded(flex: data.singlesPct, child: Container(color: AppColors.accent)),
                      const SizedBox(width: 2),
                      Expanded(flex: data.doublesPct, child: Container(color: const Color(0xFF555555))),
                      const SizedBox(width: 2),
                      Expanded(flex: data.mixedPct, child: Container(color: const Color(0xFFE0E0E0))),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.inter(color: Colors.white70, fontSize: 11),
        ),
      ],
    );
  }
}
