import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class EmptyRosterWidget extends StatelessWidget {
  final VoidCallback onAdd;

  EmptyRosterWidget({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return GestureDetector(
      onTap: onAdd,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(24)),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
        ),
        child: CustomPaint(
          painter: DashedBorderPainter(color: AppColors.outlineVariant, borderRadius: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_add_alt_1, color: AppColors.muted),
              SizedBox(width: 12),
              Text('Add more players', style: AppTypography.bodyMd.copyWith(color: AppColors.muted, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double borderRadius;

  DashedBorderPainter({required this.color, required this.borderRadius});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const double dashWidth = 8, dashSpace = 6;
    double startX = 0;

    final RRect rrect = RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, size.height), Radius.circular(borderRadius));
    Path path = Path()..addRRect(rrect);
    
    PathMetrics pathMetrics = path.computeMetrics();
    for (PathMetric pathMetric in pathMetrics) {
      while (startX < pathMetric.length) {
        canvas.drawPath(pathMetric.extractPath(startX, startX + dashWidth), paint);
        startX += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
