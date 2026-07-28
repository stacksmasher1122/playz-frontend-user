import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Pickleball/live_pickleball_match_controller.dart';
import 'team_score_widget.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MatchHeaderWidget extends StatelessWidget {
  final LivePickleballMatchController controller;

  MatchHeaderWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      children: [
        Obx(() => Text(
          '${controller.matchTitle.value.toUpperCase()} • ${controller.courtInfo.value.toUpperCase()}',
          style: AppTypography.labelCaps10.copyWith(
            color: AppColors.muted,
            fontWeight: FontWeight.bold,
          ),
        )),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(
              () => TeamScoreWidget(
                teamName: controller.teamAName.value.toUpperCase(),
                setsWon: controller.teamASets.value,
                isHighlighted:
                    controller.teamASets.value >= controller.teamBSets.value,
                isLeftAligned: true,
              ),
            ),
            Text(
              'VS',
              style: AppTypography.labelCaps.copyWith(
                color: AppColors.muted,
                fontWeight: FontWeight.bold,
              ),
            ),
            Obx(
              () => TeamScoreWidget(
                teamName: controller.teamBName.value.toUpperCase(),
                setsWon: controller.teamBSets.value,
                isHighlighted:
                    controller.teamBSets.value > controller.teamASets.value,
                isLeftAligned: false,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
