import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Pickleball/live_pickleball_match_controller.dart';
import 'team_score_widget.dart';

class MatchHeaderWidget extends StatelessWidget {
  final LivePickleballMatchController controller;

  const MatchHeaderWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'CHAMPIONSHIP FINALS • COURT 1',
          style: AppTypography.labelCaps10.copyWith(color: AppColors.muted, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(() => TeamScoreWidget(
              teamName: 'TEAM A',
              setsWon: controller.teamASets.value,
              isHighlighted: controller.teamASets.value >= controller.teamBSets.value,
              isLeftAligned: true,
            )),
            Text(
              'VS',
              style: AppTypography.labelCaps.copyWith(color: AppColors.muted, fontWeight: FontWeight.bold),
            ),
            Obx(() => TeamScoreWidget(
              teamName: 'TEAM B',
              setsWon: controller.teamBSets.value,
              isHighlighted: controller.teamBSets.value > controller.teamASets.value,
              isLeftAligned: false,
            )),
          ],
        ),
      ],
    );
  }
}
