import 'package:flutter/material.dart';

class KickoffBallWidget extends StatelessWidget {
  const KickoffBallWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFC6FF00), // Lime Green
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFC6FF00).withValues(alpha: 0.6),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }
}
