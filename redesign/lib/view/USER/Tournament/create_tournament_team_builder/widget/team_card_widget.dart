import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

import '../../../../../controller/User_Controller/Tournament_Controller/team_builder_controller.dart';
import '../../../../../model/User_Models/Tournament_Model/team_model.dart';
import 'player_tile_widget.dart';
import 'search_player_widget.dart';

class TeamCardWidget extends StatelessWidget {
  final TeamModel team;
  final TeamBuilderController controller;

  const TeamCardWidget({
    super.key,
    required this.team,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isExpanded = controller.expandedTeamId.value == team.id;
      final Color cardColor = const Color(0xFF1C1C1E);
      
      return Container(
        margin: EdgeInsets.only(bottom: ResponsiveHelper.h(12)),
        padding: EdgeInsets.all(ResponsiveHelper.w(16)),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
        ),
        child: Column(
          children: [
            // Header Row
            InkWell(
              onTap: () => controller.toggleExpand(team.id),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: ResponsiveHelper.w(48),
                        height: ResponsiveHelper.w(48),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.card),
                        ),
                        child: team.logoUrl != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.network(team.logoUrl!, fit: BoxFit.cover),
                              )
                            : Icon(
                                Icons.add_photo_alternate,
                                color: AppColors.muted,
                                size: ResponsiveHelper.w(24),
                              ),
                      ),
                      SizedBox(width: ResponsiveHelper.w(16)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            team.name,
                            style: AppTypography.headlineSm.copyWith(color: AppColors.onPrimary),
                          ),
                          Text(
                            "${team.players.length} Players Added",
                            style: AppTypography.bodySm.copyWith(
                              color: team.players.isEmpty ? AppColors.error : AppColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Icon(
                    isExpanded ? Icons.expand_more : Icons.chevron_right,
                    color: AppColors.muted,
                  ),
                ],
              ),
            ),
            
            // Expanded Content
            if (isExpanded) ...[
              SizedBox(height: ResponsiveHelper.h(16)),
              Divider(color: AppColors.card, thickness: 1),
              SizedBox(height: ResponsiveHelper.h(16)),
              
              SearchPlayerWidget(controller: controller.searchController),
              
              // Team Players vs Search Results
              Obx(() {
                if (controller.searchQuery.value.isNotEmpty) {
                  final filtered = controller.getFilteredPlayers();
                  return Column(
                    children: filtered.map((player) {
                      return PlayerTileWidget(
                        player: player,
                        onTap: () => controller.addPlayerToTeam(team.id, player),
                      );
                    }).toList(),
                  );
                } else {
                  // Show current team players
                  return Column(
                    children: team.players.map((player) {
                      return PlayerTileWidget(
                        player: player,
                        onTap: () => controller.removePlayerFromTeam(team.id, player.id),
                      );
                    }).toList(),
                  );
                }
              }),
            ],
          ],
        ),
      );
    });
  }
}
