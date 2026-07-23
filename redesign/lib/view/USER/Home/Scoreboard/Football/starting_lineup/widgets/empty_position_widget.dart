import 'package:redesign/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class DashedCirclePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;

  DashedCirclePainter({
    required this.color,
    required this.strokeWidth,
    required this.dashWidth,
    required this.dashSpace,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    var circumference = size.width * 3.14159;
    var dashCount = (circumference / (dashWidth + dashSpace)).floor();
    var adjustedDashSpace = (circumference - (dashCount * dashWidth)) / dashCount;

    var angle = 0.0;
    for (int i = 0; i < dashCount; i++) {
      canvas.drawArc(
        Rect.fromLTWH(0, 0, size.width, size.height),
        angle,
        (dashWidth / circumference) * 2 * 3.14159,
        false,
        paint,
      );
      angle += ((dashWidth + adjustedDashSpace) / circumference) * 2 * 3.14159;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class EmptyPositionWidget extends StatelessWidget {
  final String label;
  final bool isCenterActive; // To make the visually distinct solid lime circle
  final VoidCallback onTap;

  EmptyPositionWidget({
    super.key,
    required this.label,
    this.isCenterActive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: ResponsiveHelper.w(50),
            height: ResponsiveHelper.h(50),
            child: isCenterActive
                ? Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.accent.withValues(alpha: 0.1),
                      border: Border.all(color: AppColors.accent, width: 2),
                    ),
                    child: Center(
                      child: Icon(Icons.person_add_alt_1, color: AppColors.accent, size: 24),
                    ),
                  )
                : CustomPaint(
                    painter: DashedCirclePainter(
                      color: Colors.grey,
                      strokeWidth: 2,
                      dashWidth: 6,
                      dashSpace: 4,
                    ),
                    child: Center(
                      child: Icon(Icons.add, color: Colors.grey, size: 24),
                    ),
                  ),
          ),
          SizedBox(height: 4),
          Container(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(6), vertical: ResponsiveHelper.h(2)),
            decoration: BoxDecoration(
              color: AppColors.background.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(4)),
            ),
            child: Text(
              label.toUpperCase(),
              style: TextStyle(
                color: isCenterActive ? AppColors.accent : Colors.grey,
                fontSize: ResponsiveHelper.sp(10),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
