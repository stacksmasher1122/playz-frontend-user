import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Football/football_match_statistics_controller.dart';
import '../../../../../../../theme/responsive_helper.dart';

class LiveMatchHeaderWidget extends StatelessWidget {
  LiveMatchHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<FootballMatchStatisticsController>();

    return Obx(() {
      final match = controller.match.value;

      return Container(
        margin: EdgeInsets.all(ResponsiveHelper.w(16)),
        padding: EdgeInsets.symmetric(
          vertical: ResponsiveHelper.h(24),
          horizontal: ResponsiveHelper.w(16),
        ),
        decoration: BoxDecoration(
          color: Colors.grey.shade900.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
          border: Border.all(color: Colors.grey.shade800),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: ResponsiveHelper.w(6),
                  height: ResponsiveHelper.h(6),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(6)),
                Text(
                  '${match.matchStatus} • ${match.currentMinute}',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: ResponsiveHelper.sp(12),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveHelper.h(24)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTeamCol(context, match.homeTeam, match.homeLogo),
                Column(
                  children: [
                    Text(
                      '${match.homeScore} - ${match.awayScore}',
                      style: TextStyle(
                        color: Color(0xFFC6FF00),
                        fontSize: ResponsiveHelper.sp(48),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.h(4)),
                    Text(
                      match.stadium.toUpperCase(),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: ResponsiveHelper.sp(10),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                _buildTeamCol(context, match.awayTeam, match.awayLogo),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTeamCol(BuildContext context, String name, String logoUrl) {
    return Column(
      children: [
        Container(
          width: ResponsiveHelper.w(70),
          height: ResponsiveHelper.h(70),
          padding: EdgeInsets.all(ResponsiveHelper.w(4)),
          decoration: BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade800),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shield,
              color: Colors.white,
              size: ResponsiveHelper.w(32),
            ),
          ),
        ),
        SizedBox(height: ResponsiveHelper.h(12)),
        Text(
          name.replaceAll(' ', '\n'),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: ResponsiveHelper.sp(14),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
