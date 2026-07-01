import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SeriesScoreWidget extends StatelessWidget {
  final int winnerGames;
  final int runnerGames;
  final String matchStatus;

  SeriesScoreWidget({
    super.key,
    required this.winnerGames,
    required this.runnerGames,
    required this.matchStatus,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder<int>(
              tween: IntTween(begin: 0, end: winnerGames),
              duration: Duration(milliseconds: 800),
              builder: (context, value, child) {
                return Text(
                  '$value',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: ResponsiveHelper.sp(72),
                    fontWeight: FontWeight.w900,
                    color: AppColors.primaryContainer,
                    height: ResponsiveHelper.h(1.0),
                  ),
                );
              },
            ),
            SizedBox(width: 16),
            Text(
              '—',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: ResponsiveHelper.sp(48),
                fontWeight: FontWeight.w100,
                color: AppColors.muted,
                height: ResponsiveHelper.h(1.0),
              ),
            ),
            SizedBox(width: 16),
            TweenAnimationBuilder<int>(
              tween: IntTween(begin: 0, end: runnerGames),
              duration: Duration(milliseconds: 800),
              builder: (context, value, child) {
                return Text(
                  '$value',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: ResponsiveHelper.sp(72),
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                    height: ResponsiveHelper.h(1.0),
                  ),
                );
              },
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          matchStatus,
          style: AppTypography.labelCaps.copyWith(color: AppColors.muted, letterSpacing: 2.0),
        ),
      ],
    );
  }
}
