import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/volleyball_player_model.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Volleyball/volleyball_starting_lineup_controller.dart';

class PlayerCard extends StatelessWidget {
  final VolleyballPlayerModel player;
  final VolleyballStartingLineupController controller;

  const PlayerCard({super.key, required this.player, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isOnCourt = controller.currentState.courtPlayers.containsValue(player);

      return Draggable<VolleyballPlayerModel>(
        data: player,
        feedback: Material(
          color: Colors.transparent,
          child: _buildCardContent(isDragging: true, isOnCourt: isOnCourt),
        ),
        childWhenDragging: Opacity(
          opacity: 0.3,
          child: _buildCardContent(isDragging: false, isOnCourt: isOnCourt),
        ),
        child: _buildCardContent(isDragging: false, isOnCourt: isOnCourt),
      );
    });
  }

  Widget _buildCardContent({required bool isDragging, required bool isOnCourt}) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isOnCourt ? AppColors.primaryContainer : AppColors.surfaceContainerHighest),
        boxShadow: isDragging ? [
          BoxShadow(
            color: AppColors.primaryContainer.withOpacity(0.4),
            blurRadius: 15,
            spreadRadius: 2,
          )
        ] : [],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.surfaceContainerHighest),
                  ),
                  child: Center(
                    child: Text(
                      player.jerseyNumber,
                      style: AppTypography.headlineSm.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  player.name.toUpperCase(),
                  style: AppTypography.labelCaps10.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  player.position,
                  style: AppTypography.labelCaps10.copyWith(color: AppColors.muted, fontSize: 8),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ],
            ),
          ),
          if (isOnCourt)
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: AppColors.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: AppColors.onPrimaryContainer, size: 12),
              ),
            ),
        ],
      ),
    );
  }
}
