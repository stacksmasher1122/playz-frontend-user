import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Badminton/live_match_controller.dart';
import 'score_button_widget.dart';
import 'package:redesign/theme/responsive_helper.dart';

class QuickScorePanel extends StatelessWidget {
  QuickScorePanel({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<LiveMatchController>();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(24.0)),
      child: Row(
        children: [
          Expanded(
            child: ScoreButtonWidget(
              playerName: 'AXELSEN',
              onTap: controller.addPointToPlayerOne,
            ),
          ),
          Container(
            width: ResponsiveHelper.w(1),
            height: ResponsiveHelper.h(100),
            color: Colors.grey.shade900,
          ),
          Expanded(
            child: ScoreButtonWidget(
              playerName: 'GINTING',
              onTap: controller.addPointToPlayerTwo,
            ),
          ),
        ],
      ),
    );
  }
}
