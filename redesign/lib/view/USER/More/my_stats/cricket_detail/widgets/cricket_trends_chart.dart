import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class CricketTrendsChart extends StatefulWidget {
  const CricketTrendsChart({super.key});

  @override
  State<CricketTrendsChart> createState() => _CricketTrendsChartState();
}

class _CricketTrendsChartState extends State<CricketTrendsChart> {
  String _selectedScope = 'Last 5';
  String _selectedBowlingMetric = 'Wickets';

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Row(
          children: [
            const Icon(Icons.show_chart, color: AppColors.accent, size: 18),
            SizedBox(width: ResponsiveHelper.w(6)),
            Text(
              'Performance Trends',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: ResponsiveHelper.sp(16),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: ResponsiveHelper.h(12)),

        // Filter Pills: Last 5, Last 10, Season, Career
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
                      color: isSel ? const Color(0xFF1E2B22) : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: isSel ? Border.all(color: AppColors.accent.withValues(alpha: 0.4)) : null,
                    ),
                    child: Center(
                      child: Text(
                        scope,
                        style: GoogleFonts.inter(
                          color: isSel ? AppColors.accent : AppColors.muted,
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

        SizedBox(height: ResponsiveHelper.h(14)),

        // 1. Runs Scored Line Chart Card
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
                'Runs Scored',
                style: GoogleFonts.inter(color: AppColors.muted, fontSize: 12),
              ),
              SizedBox(height: ResponsiveHelper.h(12)),
              SizedBox(
                height: 120,
                child: CustomPaint(
                  size: Size.infinite,
                  painter: _CricketLineChartPainter(),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: ResponsiveHelper.h(14)),

        // 2. Bowling Performance Bar Chart Card
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Bowling Performance',
                    style: GoogleFonts.inter(color: AppColors.muted, fontSize: 12),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: ['Wickets', 'Economy', 'Runs', 'Dot %'].map((m) {
                          final isSel = m == _selectedBowlingMetric;
                          return Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedBowlingMetric = m),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                decoration: BoxDecoration(
                                  color: isSel ? AppColors.accent : const Color(0xFF222222),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  m,
                                  style: GoogleFonts.inter(
                                    color: isSel ? Colors.black : Colors.white70,
                                    fontSize: 9,
                                    fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: ResponsiveHelper.h(16)),
              SizedBox(
                height: 90,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _BarItem(heightPct: 0.4),
                    _BarItem(heightPct: 0.9),
                    _BarItem(heightPct: 0.2),
                    _BarItem(heightPct: 0.7),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BarItem extends StatelessWidget {
  final double heightPct;

  const _BarItem({required this.heightPct});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 80 * heightPct,
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}

class _CricketLineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = AppColors.accent
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final dashPaint = Paint()
      ..color = Colors.white30
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final path = Path();
    final points = [
      Offset(0, size.height * 0.7),
      Offset(size.width * 0.25, size.height * 0.45),
      Offset(size.width * 0.5, size.height * 0.15),
      Offset(size.width * 0.75, size.height * 0.65),
      Offset(size.width, size.height * 0.3),
    ];

    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(path, linePaint);

    // Draw dashed avg line
    double dashWidth = 4, dashSpace = 4, startX = 0;
    final avgY = size.height * 0.5;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, avgY), Offset(startX + dashWidth, avgY), dashPaint);
      startX += dashWidth + dashSpace;
    }

    // Draw peak point 87*
    final dotPaint = Paint()
      ..color = AppColors.accent
      ..style = PaintingStyle.fill;
    canvas.drawCircle(points[2], 5, dotPaint);

    final textPainter = TextPainter(
      text: const TextSpan(
        text: '87*',
        style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(points[2].dx - 8, points[2].dy - 16));

    final avgPainter = TextPainter(
      text: const TextSpan(
        text: 'Avg: 42.5',
        style: TextStyle(color: Colors.white54, fontSize: 9),
      ),
      textDirection: TextDirection.ltr,
    );
    avgPainter.layout();
    avgPainter.paint(canvas, Offset(4, avgY - 14));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
