import 'package:flutter/material.dart';

class ScoreBoardWidget extends StatelessWidget {
  final int scoreA;
  final int scoreB;

  const ScoreBoardWidget({
    super.key,
    required this.scoreA,
    required this.scoreB,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _AnimatedScore(score: scoreA),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            '-',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _AnimatedScore(score: scoreB),
      ],
    );
  }
}

class _AnimatedScore extends StatelessWidget {
  final int score;

  const _AnimatedScore({required this.score});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, -0.5),
            end: Offset.zero,
          ).animate(animation),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      child: Text(
        '$score',
        key: ValueKey<int>(score),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 48,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
