import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/volleyball_player_model.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Volleyball/volleyball_team_management_controller.dart';

class PlayerTile extends StatelessWidget {
  final VolleyballPlayerModel player;
  final bool isTeamA;
  final VolleyballTeamManagementController controller;

  const PlayerTile({super.key, required this.player, required this.isTeamA, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.surfaceContainerHighest),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              player.jerseyNumber.padLeft(2, '0'),
              style: AppTypography.headlineSm.copyWith(color: AppColors.muted, fontWeight: FontWeight.w300),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          player.name,
                          style: AppTypography.bodyLg.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                        ),
                        if (player.isCaptain) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: AppColors.primaryContainer, borderRadius: BorderRadius.circular(4)),
                            child: Text('C', style: AppTypography.labelCaps10.copyWith(color: AppColors.onPrimaryContainer, fontWeight: FontWeight.bold)),
                          )
                        ]
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      player.position,
                      style: AppTypography.labelCaps10.copyWith(color: AppColors.muted),
                    ),
                  ],
                ),
              ),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: AppColors.muted),
              color: AppColors.surfaceContainerHigh,
              onSelected: (value) {
                if (value == 'captain') {
                  controller.assignCaptain(isTeamA, player.id);
                } else if (value == 'libero') {
                  controller.assignLibero(isTeamA, player.id);
                } else if (value == 'delete') {
                  controller.removePlayer(isTeamA, player.id);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'captain',
                  child: Text('Assign Captain', style: AppTypography.bodyMd.copyWith(color: AppColors.primary)),
                ),
                PopupMenuItem(
                  value: 'libero',
                  child: Text('Assign Libero', style: AppTypography.bodyMd.copyWith(color: AppColors.primary)),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Text('Remove Player', style: AppTypography.bodyMd.copyWith(color: AppColors.error)),
                ),
              ],
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
