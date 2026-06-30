import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Badminton/live_match_controller.dart';
import 'score_button_widget.dart';

class QuickScorePanel extends StatelessWidget {
  const QuickScorePanel({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LiveMatchController>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Row(
        children: [
          Expanded(
            child: ScoreButtonWidget(
              playerName: 'AXELSEN',
              onTap: controller.addPointToPlayerOne,
            ),
          ),
          Container(
            width: 1,
            height: 100,
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
