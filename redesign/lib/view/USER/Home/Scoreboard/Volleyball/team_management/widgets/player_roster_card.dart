import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/volleyball_team_model.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Volleyball/volleyball_team_management_controller.dart';
import 'team_header_card.dart';
import 'player_tile.dart';
import 'empty_roster_widget.dart';
import 'add_player_dialog.dart';

class PlayerRosterCard extends StatelessWidget {
  final bool isTeamA;
  final VolleyballTeamModel team;
  final VolleyballTeamManagementController controller;

  const PlayerRosterCard({
    super.key,
    required this.isTeamA,
    required this.team,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.surfaceContainerHighest),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TeamHeaderCard(isTeamA: isTeamA, team: team, controller: controller),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Player Roster (${team.players.length} Active)',
                style: AppTypography.labelCaps10.copyWith(color: AppColors.primaryContainer, fontWeight: FontWeight.bold, letterSpacing: 1.2),
              ),
              Row(
                children: [
                  OutlinedButton(
                    onPressed: () => controller.bulkImportPlayers(isTeamA),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.surfaceContainerHighest),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      minimumSize: Size.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text('BULK\nADD', textAlign: TextAlign.center, style: AppTypography.labelCaps10.copyWith(fontSize: 10)),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => AddPlayerDialog(isTeamA: isTeamA, controller: controller),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryContainer,
                      foregroundColor: AppColors.onPrimaryContainer,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      minimumSize: Size.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text('+\nNEW', textAlign: TextAlign.center, style: AppTypography.labelCaps10.copyWith(fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: team.players.length,
            itemBuilder: (context, index) {
              return PlayerTile(
                player: team.players[index],
                isTeamA: isTeamA,
                controller: controller,
              );
            },
          ),
          EmptyRosterWidget(onAdd: () {
            showDialog(
              context: context,
              builder: (_) => AddPlayerDialog(isTeamA: isTeamA, controller: controller),
            );
          }),
        ],
      ),
    );
  }
}
