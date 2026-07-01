import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Football/starting_lineup_controller.dart';
import 'player_card_widget.dart';

class SquadListWidget extends StatelessWidget {
  const SquadListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StartingLineupController>();

    return Obx(() {
      if (controller.squadPlayers.isEmpty) {
        return const Padding(
          padding: EdgeInsets.all(32.0),
          child: Center(
            child: Text(
              'No players available.',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 16),
        itemCount: controller.squadPlayers.length,
        itemBuilder: (context, index) {
          final player = controller.squadPlayers[index];
          return PlayerCardWidget(player: player);
        },
      );
    });
  }
}
