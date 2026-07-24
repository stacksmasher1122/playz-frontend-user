import 'package:redesign/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class PitchLinesWidget extends StatelessWidget {
  PitchLinesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return CustomPaint(painter: _PitchPainter(), child: Container());
  }
}

class _PitchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.accent.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Outer border
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Center line
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      paint,
    );

    // Center circle
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width * 0.15,
      paint,
    );

    // Top penalty area
    final penWidth = size.width * 0.5;
    final penHeight = size.height * 0.15;
    canvas.drawRect(
      Rect.fromLTWH((size.width - penWidth) / 2, 0, penWidth, penHeight),
      paint,
    );

    // Bottom penalty area
    canvas.drawRect(
      Rect.fromLTWH(
        (size.width - penWidth) / 2,
        size.height - penHeight,
        penWidth,
        penHeight,
      ),
      paint,
    );

    // Top goal area
    final goalWidth = size.width * 0.25;
    final goalHeight = size.height * 0.06;
    canvas.drawRect(
      Rect.fromLTWH((size.width - goalWidth) / 2, 0, goalWidth, goalHeight),
      paint,
    );

    // Bottom goal area
    canvas.drawRect(
      Rect.fromLTWH(
        (size.width - goalWidth) / 2,
        size.height - goalHeight,
        goalWidth,
        goalHeight,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
