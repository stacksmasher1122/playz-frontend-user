import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class FootballTrendsChart extends StatefulWidget {
  const FootballTrendsChart({super.key});

  @override
  State<FootballTrendsChart> createState() => _FootballTrendsChartState();
}

class _FootballTrendsChartState extends State<FootballTrendsChart> {
  String _selectedTime = 'Last 5';
  String _selectedMetric = 'Goals';

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title & Time Filters
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Performance Trends',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: ResponsiveHelper.sp(16),
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: ['Last 5', 'Season', 'Career'].map((t) {
                final isSel = t == _selectedTime;
                return Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTime = t),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isSel ? AppColors.accent : const Color(0xFF141414),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        t,
                        style: GoogleFonts.inter(
                          color: isSel ? Colors.black : AppColors.muted,
                          fontSize: 10,
                          fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),

        SizedBox(height: ResponsiveHelper.h(10)),

        // Metric Pills
        Row(
          children: ['Goals', 'Assists', 'G+A', 'Rating'].map((m) {
            final isSel = m == _selectedMetric;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedMetric = m),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: isSel ? AppColors.accent : const Color(0xFF141414),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      m,
                      style: GoogleFonts.inter(
                        color: isSel ? Colors.black : AppColors.muted,
                        fontSize: 10,
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

        // Bar Chart Box
        Container(
          padding: EdgeInsets.all(ResponsiveHelper.w(16)),
          decoration: BoxDecoration(
            color: const Color(0xFF141414),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _MonthCol(month: 'Jan', goalHt: 40, assistHt: 20),
                    _MonthCol(month: 'Feb', goalHt: 60, assistHt: 35),
                    _MonthCol(month: 'Mar', goalHt: 30, assistHt: 15),
                    _MonthCol(month: 'Apr', goalHt: 75, assistHt: 45),
                  ],
                ),
              ),
              SizedBox(height: ResponsiveHelper.h(12)),

              // Legend
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(width: 8, height: 8, color: AppColors.accent),
                  const SizedBox(width: 4),
                  Text('Goals', style: GoogleFonts.inter(color: AppColors.muted, fontSize: 10)),
                  const SizedBox(width: 16),
                  Container(width: 8, height: 8, color: const Color(0xFF555555)),
                  const SizedBox(width: 4),
                  Text('Assists', style: GoogleFonts.inter(color: AppColors.muted, fontSize: 10)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MonthCol extends StatelessWidget {
  final String month;
  final double goalHt;
  final double assistHt;

  const _MonthCol({
    required this.month,
    required this.goalHt,
    required this.assistHt,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(width: 10, height: goalHt, decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(2))),
            const SizedBox(width: 2),
            Container(width: 10, height: assistHt, decoration: BoxDecoration(color: const Color(0xFF555555), borderRadius: BorderRadius.circular(2))),
          ],
        ),
        const SizedBox(height: 6),
        Text(month, style: GoogleFonts.inter(color: AppColors.muted, fontSize: 10)),
      ],
    );
  }
}
