import 'package:flutter/material.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/cricket_state_models.dart';
import 'package:redesign/theme/app_colors.dart';

class OverProgressRow extends StatelessWidget {
  final List<BallEvent> currentOverBalls;

  const OverProgressRow({
    super.key,
    required this.currentOverBalls,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 56,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        itemBuilder: (ctx, i) {
          if (i < currentOverBalls.length) {
            final ball = currentOverBalls[i];
            return _ballCircle(
              ball.displayText,
              ball.displayColor,
              filled: true,
            );
          }
          return _ballCircle('', AppColors.muted, filled: false);
        },
      ),
    );
  }

  Widget _ballCircle(String text, Color color, {required bool filled}) {
    return Container(
      width: 48,
      height: 48,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: filled ? color.withValues(alpha: 0.2) : Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
      ),
    );
  }
}
