import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:redesign/theme/responsive_helper.dart';

class LineChartWidget extends StatelessWidget {
  final List<double> points; // 0.0 to 1.0
  final Animation<double> animation;

  LineChartWidget({
    super.key,
    required this.points,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return CustomPaint(
          size: Size(double.infinity, 120),
          painter: _LineChartPainter(
            points: points,
            progress: animation.value,
          ),
        );
      },
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> points;
  final double progress;

  _LineChartPainter({
    required this.points,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final path = Path();
    final widthStep = size.width / (points.length - 1);
    
    // Build the full path first
    for (int i = 0; i < points.length; i++) {
      final x = i * widthStep;
      // Invert Y so higher value = higher on screen (lower Y coordinate)
      final y = size.height - (points[i] * size.height);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    // Extract subpath based on animation progress
    final pathMetrics = path.computeMetrics().first;
    final extractPath = pathMetrics.extractPath(0, pathMetrics.length * progress);

    // 1. Draw gradient fill below the line
    final fillPath = Path.from(extractPath);
    // Drop down to bottom right of current progress
    final currentPoint = extractPath.computeMetrics().last.getTangentForOffset(pathMetrics.length * progress)?.position ?? Offset.zero;
    fillPath.lineTo(currentPoint.dx, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    final gradientPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(0, size.height / 2),
        Offset(0, size.height),
        [
          Color(0xFFC6FF00).withValues(alpha: 0.3), // Neon Yellow-Green
          Colors.transparent,
        ],
      );
    
    canvas.drawPath(fillPath, gradientPaint);

    // 2. Draw the jagged green line
    final strokePaint = Paint()
      ..color = Color(0xFFC6FF00)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeJoin = StrokeJoin.round;
      
    canvas.drawPath(extractPath, strokePaint);

    // Optional: draw faint comparison dotted line (mock opponent)
    if (progress == 1.0) {
      _drawOpponentMockLine(canvas, size, widthStep);
    }
  }

  void _drawOpponentMockLine(Canvas canvas, Size size, double widthStep) {
    final opponentPoints = [0.0, 0.05, 0.1, 0.1, 0.15, 0.2, 0.2, 0.3, 0.4, 0.45, 0.5, 0.55, 0.6, 0.65];
    final path = Path();
    for (int i = 0; i < opponentPoints.length; i++) {
      final x = i * widthStep;
      final y = size.height - (opponentPoints[i] * size.height);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final paint = Paint()
      ..color = Colors.grey.shade600
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Simulate dotted line with PathMetric
    final metrics = path.computeMetrics().first;
    double distance = 0.0;
    while (distance < metrics.length) {
      final subPath = metrics.extractPath(distance, distance + 4);
      canvas.drawPath(subPath, paint);
      distance += 8;
    }
  }

  @override
  bool shouldRepaint(_LineChartPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.points != points;
  }
}
