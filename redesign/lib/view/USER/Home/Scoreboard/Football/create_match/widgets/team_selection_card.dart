import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Football/football_create_match_controller.dart';
import 'team_card_widget.dart';
import 'package:redesign/theme/responsive_helper.dart';

class TeamSelectionCard extends StatelessWidget {
  TeamSelectionCard({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<FootballCreateMatchController>();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16.0), vertical: ResponsiveHelper.h(8.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: ResponsiveHelper.w(4),
                height: ResponsiveHelper.h(16),
                color: Color(0xFFC6FF00), // Lime Green
              ),
              SizedBox(width: 8),
              Text(
                'TEAM SELECTION',
                style: TextStyle(
                  color: Color(0xFFC6FF00),
                  fontSize: ResponsiveHelper.sp(12),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Obx(() {
            return Column(
              children: [
                TeamCardWidget(
                  isHome: true,
                  team: controller.homeTeam.value,
                  onSelect: controller.selectHomeTeam,
                  onUploadLogo: () => controller.uploadTeamLogo(true),
                ),
                SizedBox(height: 16),
                TeamCardWidget(
                  isHome: false,
                  team: controller.awayTeam.value,
                  onSelect: controller.selectAwayTeam,
                  onUploadLogo: () => controller.uploadTeamLogo(false),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
