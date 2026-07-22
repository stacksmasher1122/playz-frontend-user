import 'package:redesign/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Football/live_football_dashboard_controller.dart';
import 'team_score_widget.dart';
import 'match_timer_widget.dart';
import 'score_board_widget.dart';
import 'package:redesign/theme/responsive_helper.dart';

class LiveScoreCard extends StatelessWidget {
  LiveScoreCard({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<LiveFootballDashboardController>();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16.0), vertical: ResponsiveHelper.h(8.0)),
      padding: EdgeInsets.all(ResponsiveHelper.w(20)),
      decoration: BoxDecoration(
        color: Color(0xFF121212).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        border: Border.all(color: Color(0xFF1E1E1E)),
      ),
      child: Obx(() {
        final match = controller.match.value;
        if (match == null) return SizedBox.shrink();

        return Column(
          children: [
            MatchTimerWidget(
              currentHalf: controller.currentHalf.value,
              currentMinute: controller.currentMinute.value,
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TeamScoreWidget(
                  teamName: match.teamAName,
                  logoUrl: match.teamALogo,
                ),
                ScoreBoardWidget(
                  scoreA: controller.scoreA.value,
                  scoreB: controller.scoreB.value,
                ),
                TeamScoreWidget(
                  teamName: match.teamBName,
                  logoUrl: match.teamBLogo,
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}
