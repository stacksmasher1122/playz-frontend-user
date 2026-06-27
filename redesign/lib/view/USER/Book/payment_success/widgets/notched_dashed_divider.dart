import 'package:flutter/material.dart';

class NotchedDashedDivider extends StatelessWidget {
  const NotchedDashedDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: Stack(
        alignment: Alignment.center,
        children: [
          /// DASHED LINE
          Positioned.fill(child: CustomPaint(painter: _DashedLinePainter())),

          /// LEFT NOTCH
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 16,
              height: 32,
              decoration: const BoxDecoration(
                color: Colors.black, // matches background
                borderRadius: BorderRadius.horizontal(
                  right: Radius.circular(16),
                ),
              ),
            ),
          ),

          /// RIGHT NOTCH
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: 16,
              height: 32,
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(16),
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
      ..color = Colors.grey.shade700
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
