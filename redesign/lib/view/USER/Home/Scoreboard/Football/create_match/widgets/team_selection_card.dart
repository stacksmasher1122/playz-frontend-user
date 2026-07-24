import 'package:redesign/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/responsive_helper.dart';
import '../../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Football/football_create_match_controller.dart';
import 'football_team_card.dart';

class TeamSelectionCard extends StatelessWidget {
  TeamSelectionCard({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<FootballCreateMatchController>();

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.w(16.0),
        vertical: ResponsiveHelper.h(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: ResponsiveHelper.w(4),
                height: ResponsiveHelper.h(16),
                color: AppColors.accent,
              ),
              SizedBox(width: 8),
              Text(
                'TEAM SELECTION',
                style: TextStyle(
                  color: AppColors.accent,
                  fontSize: ResponsiveHelper.sp(12),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Column(
            children: [
              FootballTeamCard(
                context: context,
                controller: controller,
                title: 'HOME TEAM',
                dotColor: AppColors.success,
                accentColor: AppColors.accent,
                isHome: true,
              ),
              SizedBox(height: 16),
              FootballTeamCard(
                context: context,
                controller: controller,
                title: 'AWAY TEAM',
                dotColor: AppColors.error,
                accentColor: AppColors.warning,
                isHome: false,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
