import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Pickleball/pickleball_team_management_controller.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Pickleball/pickleball_player_model.dart';
import 'player_slot_widget.dart';

class InteractiveMatchArena extends StatelessWidget {
  final PickleballTeamManagementController controller;
  final Function(int team, int slot) onSlotTap;

  const InteractiveMatchArena({
    super.key,
    required this.controller,
    required this.onSlotTap,
  });

  PickleballPlayerModel? _getPlayer(int team, int slot) {
    var list = team == 1 ? controller.teamAPlayers : controller.teamBPlayers;
    if (slot < list.length) return list[slot];
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isSingles = controller.isSingles.value;
      
      String court = controller.initController?.selectedSurface.value ?? "Court 1";
      String tournament = controller.initController?.selectedTournament.value ?? "Friendly Match";
      if (tournament.isEmpty) tournament = "Friendly Match";

      return Column(
        children: [
          // Arena Header
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on, color: AppColors.accent, size: 16),
              SizedBox(width: 4),
              Text(
                "$court  •  $tournament",
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          
          // The Court
          Center(
            child: Container(
              width: ResponsiveHelper.w(340),
              padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(40), horizontal: ResponsiveHelper.w(16)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(24)),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 2),
                gradient: LinearGradient(
                  colors: [
                    AppColors.accent.withValues(alpha: 0.05),
                    Colors.transparent,
                    AppColors.accent.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    // Center Net Line
                    Positioned(
                      top: -ResponsiveHelper.h(40),
                      bottom: -ResponsiveHelper.h(40),
                      child: Container(
                        width: 2,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              AppColors.accent.withValues(alpha: 0.3),
                              Colors.transparent,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),

                    // Main Content (Dictates Stack Height)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Team A (Left Side)
                        isSingles
                            ? PlayerSlotWidget(
                                player: _getPlayer(1, 0),
                                isLeftTeam: true,
                                onTap: () => onSlotTap(1, 0),
                                onRemove: _getPlayer(1, 0) != null ? () => controller.removePlayer(1, 0) : null,
                              )
                            : Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  PlayerSlotWidget(
                                    player: _getPlayer(1, 0),
                                    isLeftTeam: true,
                                    onTap: () => onSlotTap(1, 0),
                                    onRemove: _getPlayer(1, 0) != null ? () => controller.removePlayer(1, 0) : null,
                                  ),
                                  SizedBox(height: ResponsiveHelper.h(24)),
                                  PlayerSlotWidget(
                                    player: _getPlayer(1, 1),
                                    isLeftTeam: true,
                                    onTap: () => onSlotTap(1, 1),
                                    onRemove: _getPlayer(1, 1) != null ? () => controller.removePlayer(1, 1) : null,
                                  ),
                                ],
                              ),

                        // The VS Badge
                        Container(
                          padding: EdgeInsets.all(ResponsiveHelper.w(12)),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.background,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.accent.withValues(alpha: 0.3),
                                blurRadius: 20,
                                spreadRadius: 2,
                              )
                            ],
                            border: Border.all(color: AppColors.accent.withValues(alpha: 0.5)),
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

                        // Team B (Right Side)
                        isSingles
                            ? PlayerSlotWidget(
                                player: _getPlayer(2, 0),
                                isLeftTeam: false,
                                onTap: () => onSlotTap(2, 0),
                                onRemove: _getPlayer(2, 0) != null ? () => controller.removePlayer(2, 0) : null,
                              )
                            : Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  PlayerSlotWidget(
                                    player: _getPlayer(2, 0),
                                    isLeftTeam: false,
                                    onTap: () => onSlotTap(2, 0),
                                    onRemove: _getPlayer(2, 0) != null ? () => controller.removePlayer(2, 0) : null,
                                  ),
                                  SizedBox(height: ResponsiveHelper.h(24)),
                                  PlayerSlotWidget(
                                    player: _getPlayer(2, 1),
                                    isLeftTeam: false,
                                    onTap: () => onSlotTap(2, 1),
                                    onRemove: _getPlayer(2, 1) != null ? () => controller.removePlayer(2, 1) : null,
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ],
                ),
            ),
          ),
          
          SizedBox(height: 24),
          // Ready State Summaries
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTeamReadyStatus("TEAM A", controller.isTeamAReady, 1),
              _buildTeamReadyStatus("TEAM B", controller.isTeamBReady, 2),
            ],
          )
        ],
      );
    });
  }

  Widget _buildTeamReadyStatus(String teamName, bool isReady, int teamIndex) {
    return Column(
      children: [
        Text(
          teamName,
          style: AppTypography.headlineMd.copyWith(color: AppColors.onPrimary, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Row(
          children: [
            Icon(
              isReady ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isReady ? AppColors.accent : AppColors.textSecondary,
              size: 14,
            ),
            SizedBox(width: 4),
            Text(
              isReady ? "Ready" : "Waiting...",
              style: AppTypography.bodySm.copyWith(
                color: isReady ? AppColors.accent : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
