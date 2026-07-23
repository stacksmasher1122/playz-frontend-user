import 'package:redesign/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ScoreBoardWidget extends StatelessWidget {
  final int scoreA;
  final int scoreB;

  ScoreBoardWidget({
    super.key,
    required this.scoreA,
    required this.scoreB,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _AnimatedScore(score: scoreA),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16.0)),
          child: Text(
            '-',
            style: TextStyle(
              color: Colors.grey,
              fontSize: ResponsiveHelper.sp(40),
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

  _AnimatedScore({required this.score});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(0.0, -0.5),
            end: Offset.zero,
          ).animate(animation),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      child: Text(
        '$score',
        key: ValueKey<int>(score),
        style: TextStyle(
          color: Colors.white,
          fontSize: ResponsiveHelper.sp(48),
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
