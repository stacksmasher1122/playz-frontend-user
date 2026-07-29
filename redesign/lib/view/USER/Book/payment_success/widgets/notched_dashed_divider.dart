import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class NotchedDashedDivider extends StatelessWidget {
  const NotchedDashedDivider({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final notchHeight = context.heightPct(3.5).clamp(28.0, 36.0);
    final notchWidth = context.widthPct(4).clamp(14.0, 20.0);

    return SizedBox(
      height: notchHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          /// DASHED LINE
          Positioned.fill(child: CustomPaint(painter: _DashedLinePainter())),

          /// LEFT NOTCH
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: notchWidth,
              height: notchHeight,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.horizontal(
                  right: Radius.circular(notchWidth),
                ),
              ),
            ),
          ),

          /// RIGHT NOTCH
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: notchWidth,
              height: notchHeight,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(notchWidth),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.borderDark
      ..strokeWidth = 1;

    const dashWidth = 6.0;
    const dashSpace = 6.0;

    double startX = 20; // leave space for notch
    final endX = size.width - 20;

    while (startX < endX) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
