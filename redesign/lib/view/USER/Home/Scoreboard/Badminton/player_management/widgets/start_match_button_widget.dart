import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class StartMatchButtonWidget extends StatefulWidget {
  final VoidCallback onTap;

  StartMatchButtonWidget({
    super.key,
    required this.onTap,
  });

  @override
  State<StartMatchButtonWidget> createState() => _StartMatchButtonWidgetState();
}

class _StartMatchButtonWidgetState extends State<StartMatchButtonWidget> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: Duration(milliseconds: 100),
        child: Container(
          margin: EdgeInsets.fromLTRB(24, 8, 24, 32),
          height: ResponsiveHelper.h(60),
          child: CustomPaint(
            painter: ParallelogramPainter(
              color: Color(0xFFC6FF00), // Neon Yellow-Green
            ),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'START MATCH',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: ResponsiveHelper.sp(16),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.play_arrow, color: Colors.black, size: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ParallelogramPainter extends CustomPainter {
  final Color color;

  ParallelogramPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // The angle/skew offset (e.g., 20 pixels inward on top right / bottom left)
    const double skew = 20.0;

    final path = Path()
      ..moveTo(skew, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width - skew, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant ParallelogramPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
