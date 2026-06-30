import 'package:flutter/material.dart';

class ScoreButtonWidget extends StatefulWidget {
  final String playerName;
  final VoidCallback onTap;

  const ScoreButtonWidget({
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
            const Text(
              '+1 POINT',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.playerName.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 16),
            AnimatedScale(
              scale: _isPressed ? 0.9 : 1.0,
              duration: const Duration(milliseconds: 100),
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.grey.shade700,
                    width: 2,
                  ),
                ),
                child: const Center(
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
