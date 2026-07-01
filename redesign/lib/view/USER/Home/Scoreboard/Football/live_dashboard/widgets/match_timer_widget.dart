import 'package:flutter/material.dart';

class MatchTimerWidget extends StatelessWidget {
  final String currentHalf;
  final int currentMinute;

  const MatchTimerWidget({
    super.key,
    required this.currentHalf,
    required this.currentMinute,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          currentHalf,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          '•',
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
        const SizedBox(width: 8),
        Text(
          "$currentMinute'",
          style: const TextStyle(
            color: Color(0xFFC6FF00), // Lime Green
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
