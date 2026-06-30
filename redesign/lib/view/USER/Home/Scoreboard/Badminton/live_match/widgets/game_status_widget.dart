import 'package:flutter/material.dart';

class GameStatusWidget extends StatelessWidget {
  final int currentGame;
  final int playerOneScore;
  final int playerTwoScore;

  const GameStatusWidget({
    super.key,
    required this.currentGame,
    required this.playerOneScore,
    required this.playerTwoScore,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'GAME $currentGame',
          style: const TextStyle(
            color: Color(0xFFC6FF00), // Neon Yellow-Green
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _AnimatedScoreNumber(
              score: playerOneScore,
              isWinning: playerOneScore >= playerTwoScore,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                ':',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 24,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            _AnimatedScoreNumber(
              score: playerTwoScore,
              isWinning: playerTwoScore > playerOneScore,
            ),
          ],
        ),
      ],
    );
  }
}

class _AnimatedScoreNumber extends StatelessWidget {
  final int score;
  final bool isWinning;

  const _AnimatedScoreNumber({
    required this.score,
    required this.isWinning,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(
          scale: animation,
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      child: Text(
        score.toString(),
        key: ValueKey<int>(score),
        style: TextStyle(
          color: isWinning ? Colors.white : Colors.grey.shade400,
          fontSize: isWinning ? 48 : 42, // Emphasize winning score
          fontWeight: isWinning ? FontWeight.w900 : FontWeight.bold,
          height: 1.0,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
    );
  }
}
