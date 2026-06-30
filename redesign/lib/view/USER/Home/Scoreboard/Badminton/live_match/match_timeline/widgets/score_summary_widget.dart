import 'package:flutter/material.dart';

class ScoreSummaryWidget extends StatelessWidget {
  final List<String> gameScores;

  const ScoreSummaryWidget({
    super.key,
    required this.gameScores,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: gameScores.map((score) {
        // Simple mock logic to determine if the game was won by player 1 (winner)
        // Format is "21-17", so if first number > second, it's a win.
        final parts = score.split('-');
        bool isWin = false;
        if (parts.length == 2) {
          final p1Score = int.tryParse(parts[0]) ?? 0;
          final p2Score = int.tryParse(parts[1]) ?? 0;
          isWin = p1Score > p2Score;
        }

        return Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 8.0),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(8),
              border: Border(
                left: BorderSide(
                  color: isWin ? const Color(0xFFC6FF00) : Colors.transparent, // Neon Yellow-Green
                  width: 4,
                ),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              score,
              style: TextStyle(
                color: isWin ? Colors.white : Colors.grey.shade600,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
