import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Badminton/live_match_controller.dart';
import 'player_score_widget.dart';
import 'game_status_widget.dart';

class ScoreboardWidget extends StatelessWidget {
  const ScoreboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LiveMatchController>();

    return RepaintBoundary(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
        child: Obx(() {
          final isPlayerOneServing = controller.serverPlayer.value == 'AXELSEN';
          
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                flex: 2,
                child: PlayerScoreWidget(
                  label: 'PLAYER ONE',
                  playerName: 'AXELSEN', // Mock static name
                  score: controller.playerOneScore.value,
                  isServing: isPlayerOneServing,
                  isWinning: controller.playerOneScore.value >= controller.playerTwoScore.value,
                  alignment: CrossAxisAlignment.start,
                ),
              ),
              Expanded(
                flex: 3,
                child: GameStatusWidget(
                  currentGame: controller.currentGame.value,
                  playerOneScore: controller.playerOneScore.value,
                  playerTwoScore: controller.playerTwoScore.value,
                ),
              ),
              Expanded(
                flex: 2,
                child: PlayerScoreWidget(
                  label: 'PLAYER TWO',
                  playerName: 'GINTING', // Mock static name
                  score: controller.playerTwoScore.value,
                  isServing: !isPlayerOneServing,
                  isWinning: controller.playerTwoScore.value > controller.playerOneScore.value,
                  alignment: CrossAxisAlignment.end,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
