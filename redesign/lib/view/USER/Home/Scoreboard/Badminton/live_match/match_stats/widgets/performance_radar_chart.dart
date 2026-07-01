import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../../../../../../model/User_Models/Home_Models/Scoreboard_Model/Badminton/performance_metric_model.dart';
import 'package:redesign/theme/responsive_helper.dart';

class PerformanceRadarChart extends StatelessWidget {
  final PerformanceMetricModel metrics;
  final Animation<double> animation;

  PerformanceRadarChart({
    super.key,
    required this.metrics,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * animation.value),
          child: CustomPaint(
            size: Size(200, 200),
            painter: _RadarChartPainter(
              metrics: metrics,
              progress: animation.value,
            ),
          ),
        );
      },
    );
  }
}

class _RadarChartPainter extends CustomPainter {
  final PerformanceMetricModel metrics;
  final double progress;

  _RadarChartPainter({
    required this.metrics,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 20;
    
    _drawGrid(canvas, center, radius);
    _drawDataPolygon(canvas, center, radius, true); // Outline (Lin Dan mock)
    _drawDataPolygon(canvas, center, radius, false); // Filled (Viktor mock)
    _drawLabels(canvas, center, radius);
  }

  void _drawGrid(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..color = Colors.grey.shade800
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw concentric circles
    for (int i = 1; i <= 4; i++) {
      canvas.drawCircle(center, radius * (i / 4), paint);
    }

    // Draw axes
    for (int i = 0; i < 5; i++) {
      final angle = (math.pi * 2 * i / 5) - math.pi / 2;
      final point = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      canvas.drawLine(center, point, paint);
    }
  }

  void _drawDataPolygon(Canvas canvas, Offset center, double radius, bool isOutline) {
    final values = isOutline 
        ? [0.7, 0.6, 0.8, 0.6, 0.5] // Mock Lin Dan
        : [metrics.speed, metrics.power, metrics.netPlay, metrics.tactics, metrics.defense];

    final path = Path();
    for (int i = 0; i < 5; i++) {
      final angle = (math.pi * 2 * i / 5) - math.pi / 2;
      final value = values[i] * progress;
      final point = Offset(
        center.dx + radius * value * math.cos(angle),
        center.dy + radius * value * math.sin(angle),
      );
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();

    if (isOutline) {
      final paint = Paint()
        ..color = Colors.grey.shade600
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      canvas.drawPath(path, paint);
    } else {
      final fillPaint = Paint()
        ..color = Color(0xFFC6FF00).withValues(alpha: 0.2) // Neon Yellow-Green
        ..style = PaintingStyle.fill;
      final strokePaint = Paint()
        ..color = Color(0xFFC6FF00)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      canvas.drawPath(path, fillPaint);
      canvas.drawPath(path, strokePaint);
    }
  }

  void _drawLabels(Canvas canvas, Offset center, double radius) {
    final labels = ['SPEED', 'POWER', 'NET', 'TACTIC', 'DEFENSE'];
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    
    for (int i = 0; i < 5; i++) {
      final angle = (math.pi * 2 * i / 5) - math.pi / 2;
      final point = Offset(
        center.dx + (radius + 20) * math.cos(angle),
        center.dy + (radius + 15) * math.sin(angle),
      );

      textPainter.text = TextSpan(
        text: labels[i],
        style: TextStyle(
          color: Colors.grey,
          fontSize: ResponsiveHelper.sp(10),
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout();
      
      final labelOffset = Offset(
        point.dx - textPainter.width / 2,
        point.dy - textPainter.height / 2,
      );
      textPainter.paint(canvas, labelOffset);
    }
  }

  @override
  bool shouldRepaint(_RadarChartPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.metrics != metrics;
  }
}
