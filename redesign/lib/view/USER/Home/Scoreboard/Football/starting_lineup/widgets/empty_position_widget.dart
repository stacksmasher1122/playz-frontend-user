import 'package:flutter/material.dart';

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

  const EmptyPositionWidget({
    super.key,
    required this.label,
    this.isCenterActive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: isCenterActive
                ? Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFC6FF00).withValues(alpha: 0.1),
                      border: Border.all(color: const Color(0xFFC6FF00), width: 2),
                    ),
                    child: const Center(
                      child: Icon(Icons.person_add_alt_1, color: Color(0xFFC6FF00), size: 24),
                    ),
                  )
                : CustomPaint(
                    painter: DashedCirclePainter(
                      color: Colors.grey.shade600,
                      strokeWidth: 2,
                      dashWidth: 6,
                      dashSpace: 4,
                    ),
                    child: Center(
                      child: Icon(Icons.add, color: Colors.grey.shade500, size: 24),
                    ),
                  ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              label.toUpperCase(),
              style: TextStyle(
                color: isCenterActive ? const Color(0xFFC6FF00) : Colors.grey,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
