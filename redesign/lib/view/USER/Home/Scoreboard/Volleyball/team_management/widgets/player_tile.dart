import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/volleyball_player_model.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Volleyball/volleyball_team_management_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';

class PlayerTile extends StatelessWidget {
  final VolleyballPlayerModel player;
  final bool isTeamA;
  final VolleyballTeamManagementController controller;

  PlayerTile({super.key, required this.player, required this.isTeamA, required this.controller});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: ResponsiveHelper.w(4),
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(ResponsiveHelper.w(12)), bottomLeft: Radius.circular(ResponsiveHelper.w(12))),
              ),
            ),
            SizedBox(width: 16),
            Text(
              player.jerseyNumber.padLeft(2, '0'),
              style: AppTypography.headlineSm.copyWith(color: AppColors.muted, fontWeight: FontWeight.w300),
            ),
            SizedBox(width: 24),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(16.0)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          player.name,
                          style: AppTypography.bodyLg.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold),
                        ),
                        if (player.isCaptain) ...[
                          SizedBox(width: 8),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(6), vertical: ResponsiveHelper.h(2)),
                            decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(ResponsiveHelper.w(4))),
                            child: Text('C', style: AppTypography.labelCaps10.copyWith(color: AppColors.background, fontWeight: FontWeight.bold)),
                          )
                        ]
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      player.position,
                      style: AppTypography.labelCaps10.copyWith(color: AppColors.muted),
                    ),
                  ],
                ),
              ),
            ),
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: AppColors.muted),
              color: AppColors.card,
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
                  child: Text('Assign Captain', style: AppTypography.bodyMd.copyWith(color: AppColors.accent)),
                ),
                PopupMenuItem(
                  value: 'libero',
                  child: Text('Assign Libero', style: AppTypography.bodyMd.copyWith(color: AppColors.accent)),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Text('Remove Player', style: AppTypography.bodyMd.copyWith(color: AppColors.error)),
                ),
              ],
            ),
            SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
