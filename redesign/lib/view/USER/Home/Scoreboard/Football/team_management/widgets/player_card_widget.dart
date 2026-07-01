import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../model/User_Models/Home_Models/Scoreboard_Model/Football/team_management/player_model.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Football/football_team_management_controller.dart';

import 'player_statistics_widget.dart';

class PlayerCardWidget extends StatelessWidget {
  final PlayerModel player;

  const PlayerCardWidget({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FootballTeamManagementController>();
    
    // Check if injured to potentially change border color
    final isInjured = player.fitness.toUpperCase() == 'INJURED';
    final borderColor = isInjured ? Colors.redAccent : (player.captain ? const Color(0xFFC6FF00) : Colors.blueAccent);

    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Colors.grey.shade900.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border(
          top: BorderSide(color: Colors.grey.shade800),
          right: BorderSide(color: Colors.grey.shade800),
          bottom: BorderSide(color: Colors.grey.shade800),
          left: BorderSide(color: borderColor, width: 4),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: NetworkImage(player.playerImage),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -6,
                            right: -6,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Color(0xFFC6FF00),
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                player.playerNumber,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      // Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              player.playerName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              player.position.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Badges and menu
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              CaptainBadgeWidget(isCaptain: player.captain),
                              const SizedBox(width: 8),
                              InkWell(
                                onTap: () => controller.showPlayerMenu(player),
                                child: const Icon(Icons.more_vert, color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white10, height: 24, thickness: 1),
                  PlayerStatisticsWidget(player: player),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class CaptainBadgeWidget extends StatelessWidget {
  final bool? isCaptain;
  const CaptainBadgeWidget({super.key, this.isCaptain});
  @override
  Widget build(BuildContext context) => const SizedBox();
}
