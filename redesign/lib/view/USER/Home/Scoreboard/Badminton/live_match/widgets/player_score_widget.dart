import 'package:flutter/material.dart';

class PlayerScoreWidget extends StatelessWidget {
  final String label;
  final String playerName;
  final int score;
  final bool isServing;
  final bool isWinning;
  final CrossAxisAlignment alignment;

  const PlayerScoreWidget({
    super.key,
    required this.label,
    required this.playerName,
    required this.score,
    required this.isServing,
    required this.isWinning,
    this.alignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          textDirection: alignment == CrossAxisAlignment.end ? TextDirection.rtl : TextDirection.ltr,
          children: [
            if (isServing)
              Container(
                margin: EdgeInsets.only(
                  right: alignment == CrossAxisAlignment.start ? 8 : 0,
                  left: alignment == CrossAxisAlignment.end ? 8 : 0,
                ),
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFFC6FF00), // Neon Yellow-Green
                  shape: BoxShape.circle,
                ),
              ),
            Text(
              playerName,
              style: TextStyle(
                color: isServing ? Colors.white : Colors.grey.shade300,
                fontSize: 20,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Game Progress Bar Mock (2 of 3 games)
        Row(
          mainAxisSize: MainAxisSize.min,
          textDirection: alignment == CrossAxisAlignment.end ? TextDirection.rtl : TextDirection.ltr,
          children: [
            _buildProgressSegment(true),
            const SizedBox(width: 4),
            _buildProgressSegment(false),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressSegment(bool won) {
    return Container(
      width: 24,
      height: 4,
      decoration: BoxDecoration(
        color: won ? const Color(0xFFC6FF00) : Colors.grey.shade800,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
