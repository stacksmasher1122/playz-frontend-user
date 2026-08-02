import 'package:flutter/material.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/cricket_state_models.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class BallTimeline extends StatelessWidget {
  final List<BallEvent> ballHistory;

  const BallTimeline({
    super.key,
    required this.ballHistory,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    // Build timeline items: ball boxes + over completion pills
    final List<Widget> timelineItems = [];

    int currentOverNum = -1;
    List<BallEvent> currentOverBalls = [];

    for (int i = 0; i < ballHistory.length; i++) {
      final ball = ballHistory[i];

      // If over number changed from previous ball, append over summary pill for previous over
      if (currentOverNum != -1 && ball.overNumber != currentOverNum) {
        final runsInOver = currentOverBalls.fold(0, (sum, b) => sum + b.totalRuns);
        final wicketsInOver = currentOverBalls.where((b) => b.isWicket).length;
        final wStr = wicketsInOver > 0 ? ' • $wicketsInOver W' : '';
        timelineItems.add(_overSummaryPill(currentOverNum + 1, runsInOver, wStr));
        currentOverBalls = [];
      }

      currentOverNum = ball.overNumber;
      currentOverBalls.add(ball);
      timelineItems.add(_ballItem(ball));

      // If this is the last ball in history and completes 6 legal balls
      if (i == ballHistory.length - 1) {
        final legalCount = currentOverBalls.where((b) => b.isLegalDelivery).length;
        if (legalCount >= 6) {
          final runsInOver = currentOverBalls.fold(0, (sum, b) => sum + b.totalRuns);
          final wicketsInOver = currentOverBalls.where((b) => b.isWicket).length;
          final wStr = wicketsInOver > 0 ? ' • $wicketsInOver W' : '';
          timelineItems.add(_overSummaryPill(currentOverNum + 1, runsInOver, wStr));
        }
      }
    }

    final ScrollController scrollController = ScrollController();

    // Auto scroll to latest ball/pill
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
      margin: EdgeInsets.all(ResponsiveHelper.w(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'RECENT TIMELINE',
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: ResponsiveHelper.sp(11),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              if (ballHistory.isNotEmpty)
                Text(
                  '${ballHistory.length} Deliveries',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: ResponsiveHelper.sp(11),
                  ),
                ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.h(8)),
          SizedBox(
            height: ResponsiveHelper.h(40),
            child: timelineItems.isEmpty
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'No deliveries yet',
                      style: TextStyle(
                        color: AppColors.muted,
                        fontSize: ResponsiveHelper.sp(12),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  )
                : ListView.builder(
                    controller: scrollController,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: timelineItems.length,
                    itemBuilder: (ctx, idx) => timelineItems[idx],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _overSummaryPill(int overNum, int runs, String wicketStr) {
    return Container(
      margin: EdgeInsets.only(right: ResponsiveHelper.w(8)),
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.w(10),
        vertical: ResponsiveHelper.h(6),
      ),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.5),
          width: 1.5,
        ),
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.flag_rounded,
            size: ResponsiveHelper.sp(12),
            color: AppColors.accent,
          ),
          SizedBox(width: ResponsiveHelper.w(4)),
          Text(
            'OV $overNum: $runs Runs$wicketStr',
            style: TextStyle(
              color: AppColors.accent,
              fontWeight: FontWeight.bold,
              fontSize: ResponsiveHelper.sp(11),
            ),
          ),
        ],
      ),
    );
  }

  Widget _ballItem(BallEvent ball) {
    return Container(
      width: ResponsiveHelper.w(36),
      height: ResponsiveHelper.h(36),
      margin: EdgeInsets.only(right: ResponsiveHelper.w(6)),
      decoration: BoxDecoration(
        color: ball.displayColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
        border: Border.all(
          color: ball.displayColor.withValues(alpha: 0.6),
          width: 1,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        ball.displayText,
        style: TextStyle(
          color: ball.displayColor,
          fontWeight: FontWeight.w700,
          fontSize: ResponsiveHelper.sp(12),
        ),
      ),
    );
  }
}
