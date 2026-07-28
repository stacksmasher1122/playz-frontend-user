import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class FootballRadarProfileCard extends StatelessWidget {
  const FootballRadarProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Performance Profile',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: ResponsiveHelper.sp(16),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: ResponsiveHelper.h(12)),

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
                height: 200,
                child: CustomPaint(
                  size: Size.infinite,
                  painter: _RadarChartPainter(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RadarChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2.8;

    final outlinePaint = Paint()
      ..color = Colors.white12
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final fillPaint = Paint()
      ..color = AppColors.accent.withValues(alpha: 0.25)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = AppColors.accent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final labels = ['Shooting', 'Passing', 'Vision', 'Physical', 'Pace', 'Dribbling'];
    final values = [0.88, 0.76, 0.82, 0.80, 0.86, 0.84];
    final numSides = labels.length;

    // Draw concentric web rings
    for (int step = 1; step <= 3; step++) {
      final r = radius * (step / 3);
      final webPath = Path();
      for (int i = 0; i < numSides; i++) {
        final angle = (i * 2 * pi / numSides) - (pi / 2);
        final x = center.dx + r * cos(angle);
        final y = center.dy + r * sin(angle);
        if (i == 0) {
          webPath.moveTo(x, y);
        } else {
          webPath.lineTo(x, y);
        }
      }
      webPath.close();
      canvas.drawPath(webPath, outlinePaint);
    }

    // Draw axis lines and labels
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    for (int i = 0; i < numSides; i++) {
      final angle = (i * 2 * pi / numSides) - (pi / 2);
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      canvas.drawLine(center, Offset(x, y), outlinePaint);

      // Label positioning
      final lx = center.dx + (radius + 20) * cos(angle);
      final ly = center.dy + (radius + 20) * sin(angle);

      textPainter.text = TextSpan(
        text: labels[i],
        style: const TextStyle(color: Colors.white70, fontSize: 9),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(lx - textPainter.width / 2, ly - textPainter.height / 2));
    }

    // Draw user polygon
    final polyPath = Path();
    for (int i = 0; i < numSides; i++) {
      final angle = (i * 2 * pi / numSides) - (pi / 2);
      final r = radius * values[i];
      final x = center.dx + r * cos(angle);
      final y = center.dy + r * sin(angle);
      if (i == 0) {
        polyPath.moveTo(x, y);
      } else {
        polyPath.lineTo(x, y);
      }
    }
    polyPath.close();

    canvas.drawPath(polyPath, fillPaint);
    canvas.drawPath(polyPath, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
