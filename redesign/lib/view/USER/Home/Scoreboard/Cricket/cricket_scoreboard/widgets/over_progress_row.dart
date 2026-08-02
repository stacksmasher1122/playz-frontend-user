import 'package:flutter/material.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/cricket_state_models.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class OverProgressRow extends StatelessWidget {
  final List<BallEvent> currentOverBalls;

  const OverProgressRow({
    super.key,
    required this.currentOverBalls,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    // Count legal deliveries bowled in current over
    int legalBallsCount = 0;
    for (final ball in currentOverBalls) {
      if (ball.isLegalDelivery) {
        legalBallsCount++;
      }
    }

    // Remaining legal deliveries to complete 6 legal balls
    final remainingLegal = (6 - legalBallsCount).clamp(0, 6);
    final totalSlots = currentOverBalls.length + remainingLegal;
    final displayCount = totalSlots < 6 ? 6 : totalSlots;

    final ScrollController scrollController = ScrollController();

    // Auto-scroll to end so latest ball or next slot is visible
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.w(16),
        vertical: ResponsiveHelper.h(6),
      ),
      height: ResponsiveHelper.h(48),
      child: ListView.builder(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: displayCount,
        itemBuilder: (ctx, i) {
          if (i < currentOverBalls.length) {
            final ball = currentOverBalls[i];
            return _ballCircle(
              ball.displayText,
              ball.displayColor,
              filled: true,
            );
          }
          return _ballCircle('', AppColors.muted.withValues(alpha: 0.3), filled: false);
        },
      ),
    );
  }

  Widget _ballCircle(String text, Color color, {required bool filled}) {
    return Container(
      width: ResponsiveHelper.w(44),
      height: ResponsiveHelper.h(44),
      margin: EdgeInsets.only(right: ResponsiveHelper.w(8)),
      decoration: BoxDecoration(
        color: filled ? color.withValues(alpha: 0.2) : Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          color: filled ? color : AppColors.muted.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          color: filled ? color : AppColors.muted,
          fontWeight: FontWeight.bold,
          fontSize: ResponsiveHelper.sp(13),
        ),
      ),
    );
  }
}
