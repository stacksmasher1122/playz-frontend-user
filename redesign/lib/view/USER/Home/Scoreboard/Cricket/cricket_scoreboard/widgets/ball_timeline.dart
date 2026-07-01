import 'package:flutter/material.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/cricket_state_models.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class BallTimeline extends StatelessWidget {
  final List<BallEvent> ballHistory;

  BallTimeline({
    super.key,
    required this.ballHistory,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      margin: EdgeInsets.all(ResponsiveHelper.w(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'PREV OVER',
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: ResponsiveHelper.sp(11),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${ballHistory.length >= 6 ? ballHistory.sublist(ballHistory.length - 6).fold(0, (sum, b) => sum + b.totalRuns) : ballHistory.fold(0, (sum, b) => sum + b.totalRuns)} Runs',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
          SizedBox(height: 8),
          SizedBox(
            height: ResponsiveHelper.h(40),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: ballHistory.length,
              itemBuilder: (ctx, i) {
                final ball = ballHistory[i];
                return Container(
                  width: ResponsiveHelper.w(36),
                  height: ResponsiveHelper.h(36),
                  margin: EdgeInsets.only(right: 6),
                  decoration: BoxDecoration(
                    color: ball.displayColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
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
              },
            ),
          ),
        ],
      ),
    );
  }
}
