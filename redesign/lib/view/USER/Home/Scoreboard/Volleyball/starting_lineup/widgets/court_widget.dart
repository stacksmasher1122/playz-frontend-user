import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Volleyball/volleyball_starting_lineup_controller.dart';
import 'court_position_widget.dart';
import 'select_player_bottom_sheet.dart';

class CourtWidget extends StatelessWidget {
  final VolleyballStartingLineupController controller;

  const CourtWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceContainerHighest),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(child: Divider(color: AppColors.surfaceContainerHighest, thickness: 2)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.surfaceContainerHighest),
                  borderRadius: BorderRadius.circular(16),
                  color: AppColors.surfaceContainerLowest,
                ),
                child: Text('NET AREA', style: AppTypography.labelCaps10.copyWith(color: AppColors.muted)),
              ),
              const Expanded(child: Divider(color: AppColors.surfaceContainerHighest, thickness: 2)),
            ],
          ),
          const SizedBox(height: 16),
          // Front Row: P4, P3, P2
          Obx(() => GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.65,
            children: [
              _buildPos(context, 4),
              _buildPos(context, 3),
              _buildPos(context, 2),
              // Back Row: P5, P6, P1
              _buildPos(context, 5),
              _buildPos(context, 6),
              _buildPos(context, 1),
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildPos(BuildContext context, int posIndex) {
    return CourtPositionWidget(
      position: posIndex,
      player: controller.currentState.courtPlayers[posIndex],
      onAccept: (player) => controller.assignPlayer(posIndex, player),
      onTap: () {
        if (controller.currentState.courtPlayers[posIndex] != null) {
          controller.removePlayer(posIndex);
        } else {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            builder: (_) => SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: SelectPlayerBottomSheet(position: posIndex, controller: controller),
            ),
          );
        }
      },
    );
  }
}
