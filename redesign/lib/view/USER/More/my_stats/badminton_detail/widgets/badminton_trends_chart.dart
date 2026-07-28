import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class BadmintonTrendsChart extends StatefulWidget {
  const BadmintonTrendsChart({super.key});

  @override
  State<BadmintonTrendsChart> createState() => _BadmintonTrendsChartState();
}

class _BadmintonTrendsChartState extends State<BadmintonTrendsChart> {
  String _selectedScope = 'Last 10';
  String _selectedMetric = 'Win %';

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          'Performance Trends',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: ResponsiveHelper.sp(16),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: ResponsiveHelper.h(12)),

        // Row 1 Time Filters
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFF141414),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: ['Last 5', 'Last 10', 'Season', 'Career'].map((scope) {
              final isSel = scope == _selectedScope;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedScope = scope),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isSel ? AppColors.accent : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        scope,
                        style: GoogleFonts.inter(
                          color: isSel ? Colors.black : AppColors.muted,
                          fontSize: ResponsiveHelper.sp(11),
                          fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        SizedBox(height: ResponsiveHelper.h(10)),

        // Row 2 Sub Metric Filters
        Row(
          children: ['Win %', 'Points Diff', 'Smash Winners', 'Errors'].map((m) {
            final isSel = m == _selectedMetric;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedMetric = m),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: isSel ? const Color(0xFF1A2B20) : const Color(0xFF141414),
                    borderRadius: BorderRadius.circular(8),
                    border: isSel ? Border.all(color: AppColors.accent.withValues(alpha: 0.4)) : null,
                  ),
                  child: Center(
                    child: Text(
                      m,
                      style: GoogleFonts.inter(
                        color: isSel ? AppColors.accent : AppColors.muted,
                        fontSize: 9,
                        fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        SizedBox(height: ResponsiveHelper.h(14)),

        // Chart Placeholder Box
        Container(
          height: 140,
          padding: EdgeInsets.all(ResponsiveHelper.w(16)),
          decoration: BoxDecoration(
            color: const Color(0xFF141414),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.bar_chart, color: AppColors.accent, size: 36),
                SizedBox(height: ResponsiveHelper.h(8)),
                Text(
                  'Win % Trend & Points Visualization',
                  style: GoogleFonts.inter(
                    color: AppColors.accent,
                    fontSize: ResponsiveHelper.sp(12),
                    fontWeight: FontWeight.bold,
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
