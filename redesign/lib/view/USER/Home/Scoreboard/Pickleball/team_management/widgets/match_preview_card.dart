import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Pickleball/pickleball_team_management_controller.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Pickleball/pickleball_player_model.dart';

class MatchPreviewCard extends StatelessWidget {
  final PickleballTeamManagementController controller;

  const MatchPreviewCard({super.key, required this.controller});

  Widget _buildPlayerColumn(PickleballPlayerModel? player, bool isLeft) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: ResponsiveHelper.w(70),
            height: ResponsiveHelper.w(70),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.accent, width: 2),
              image: player != null && player.image.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(player.image),
                      fit: BoxFit.cover,
                    )
                  : null,
              color: AppColors.outlineVariant,
            ),
            child: player == null || player.image.isEmpty
                ? Icon(Icons.person, color: AppColors.onPrimary, size: 40)
                : null,
          ),
          SizedBox(height: 12),
          Text(
            player?.name ?? (isLeft ? "Team A" : "Team B"),
            style: AppTypography.headlineMd.copyWith(color: AppColors.onPrimary, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4),
          if (player != null) ...[
            Text(player.rating, style: AppTypography.bodyMd.copyWith(color: AppColors.accent)),
            SizedBox(height: 2),
            Text(player.club, style: AppTypography.bodySm.copyWith(color: AppColors.textSecondary)),
          ] else ...[
            Text("Waiting...", style: AppTypography.bodyMd.copyWith(color: AppColors.textSecondary)),
          ]
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var teamA = controller.teamAPlayers.isNotEmpty ? controller.teamAPlayers.first : null;
      var teamB = controller.teamBPlayers.isNotEmpty ? controller.teamBPlayers.first : null;

      String matchType = controller.isSingles.value ? "Singles" : "Doubles";
      String court = controller.initController?.selectedSurface.value ?? "Court 1";
      String tournament = controller.initController?.selectedTournament.value ?? "Friendly Match";
      if (tournament.isEmpty) tournament = "Friendly Match";

      return ClipRRect(
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(24)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: EdgeInsets.all(ResponsiveHelper.w(20)),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(24)),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildPlayerColumn(teamA, true),
                    Container(
                      padding: EdgeInsets.all(ResponsiveHelper.w(12)),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.accent.withOpacity(0.1),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accent.withOpacity(0.3),
                            blurRadius: 15,
                            spreadRadius: 2,
                          )
                        ],
                        border: Border.all(color: AppColors.accent.withOpacity(0.5)),
                      ),
                      child: Text(
                        "VS",
                        style: AppTypography.headlineLg.copyWith(
                          color: AppColors.accent,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    _buildPlayerColumn(teamB, false),
                  ],
                ),
                SizedBox(height: 20),
                Divider(color: Colors.white.withOpacity(0.1)),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Icon(Icons.sports_tennis, color: AppColors.accent, size: 16),
                        SizedBox(height: 4),
                        Text(matchType, style: AppTypography.bodyMd.copyWith(color: AppColors.onPrimary)),
                      ],
                    ),
                    Column(
                      children: [
                        Icon(Icons.location_on, color: AppColors.accent, size: 16),
                        SizedBox(height: 4),
                        Text(court, style: AppTypography.bodyMd.copyWith(color: AppColors.onPrimary)),
                      ],
                    ),
                    Column(
                      children: [
                        Icon(Icons.timer, color: AppColors.accent, size: 16),
                        SizedBox(height: 4),
                        Text("~45m", style: AppTypography.bodyMd.copyWith(color: AppColors.onPrimary)),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  tournament,
                  style: AppTypography.bodyMd.copyWith(color: AppColors.textSecondary, fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
