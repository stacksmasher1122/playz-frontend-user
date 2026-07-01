import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ScoreButtonWidget extends StatefulWidget {
  final String playerName;
  final VoidCallback onTap;

  ScoreButtonWidget({
    super.key,
    required this.playerName,
    required this.onTap,
  });

  @override
  State<ScoreButtonWidget> createState() => _ScoreButtonWidgetState();
}

class _ScoreButtonWidgetState extends State<ScoreButtonWidget> {
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
      child: Container(
        color: Colors.transparent, // Expand tap area
        child: Column(
          children: [
            Text(
              '+1 POINT',
              style: TextStyle(
                color: Colors.grey,
                fontSize: ResponsiveHelper.sp(10),
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            SizedBox(height: 12),
            Text(
              widget.playerName.toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveHelper.sp(24),
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
              ),
            ),
            SizedBox(height: 16),
            AnimatedScale(
              scale: _isPressed ? 0.9 : 1.0,
              duration: Duration(milliseconds: 100),
              child: Container(
                width: ResponsiveHelper.w(70),
                height: ResponsiveHelper.h(70),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
                  border: Border.all(
                    color: Colors.grey.shade700,
                    width: ResponsiveHelper.w(2),
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.add,
                    color: Color(0xFFC6FF00), // Neon Yellow-Green
                    size: 32,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
