import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';

class SeriesScoreWidget extends StatelessWidget {
  final int winnerGames;
  final int runnerGames;
  final String matchStatus;

  const SeriesScoreWidget({
    super.key,
    required this.winnerGames,
    required this.runnerGames,
    required this.matchStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder<int>(
              tween: IntTween(begin: 0, end: winnerGames),
              duration: const Duration(milliseconds: 800),
              builder: (context, value, child) {
                return Text(
                  '$value',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 72,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primaryContainer,
                    height: 1.0,
                  ),
                );
              },
            ),
            const SizedBox(width: 16),
            const Text(
              '—',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 48,
                fontWeight: FontWeight.w100,
                color: AppColors.muted,
                height: 1.0,
              ),
            ),
            const SizedBox(width: 16),
            TweenAnimationBuilder<int>(
              tween: IntTween(begin: 0, end: runnerGames),
              duration: const Duration(milliseconds: 800),
              builder: (context, value, child) {
                return Text(
                  '$value',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 72,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                    height: 1.0,
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          matchStatus,
          style: AppTypography.labelCaps.copyWith(color: AppColors.muted, letterSpacing: 2.0),
        ),
      ],
    );
  }
}
