import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/volleyball_player_model.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Volleyball/volleyball_starting_lineup_controller.dart';

class SelectPlayerBottomSheet extends StatelessWidget {
  final int position;
  final VolleyballStartingLineupController controller;

  const SelectPlayerBottomSheet({super.key, required this.position, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Assign Player to P$position', style: AppTypography.headlineSm.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
              IconButton(icon: const Icon(Icons.close, color: AppColors.muted), onPressed: () => Navigator.pop(context)),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              // Filter out players already on the court
              List<VolleyballPlayerModel> available = controller.currentState.availablePlayers.where((p) => !controller.currentState.courtPlayers.containsValue(p)).toList();
              
              if (available.isEmpty) {
                return Center(child: Text('No available players left.', style: AppTypography.bodyMd.copyWith(color: AppColors.muted)));
              }

              return ListView.builder(
                itemCount: available.length,
                itemBuilder: (context, index) {
                  final player = available[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(player.jerseyNumber, style: AppTypography.headlineSm.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    title: Text(player.name, style: AppTypography.bodyLg.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                    subtitle: Text(player.position, style: AppTypography.labelCaps10.copyWith(color: AppColors.muted)),
                    trailing: const Icon(Icons.add_circle_outline, color: AppColors.primaryContainer),
                    onTap: () {
                      controller.assignPlayer(position, player);
                      Navigator.pop(context);
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
