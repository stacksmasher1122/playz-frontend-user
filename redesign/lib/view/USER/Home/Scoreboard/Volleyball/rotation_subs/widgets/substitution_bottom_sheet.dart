import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Volleyball/volleyball_rotation_subs_controller.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/volleyball_player_model.dart';
import 'bench_player_card.dart';

class SubstitutionBottomSheet extends StatefulWidget {
  final VolleyballRotationSubsController controller;

  const SubstitutionBottomSheet({super.key, required this.controller});

  @override
  State<SubstitutionBottomSheet> createState() => _SubstitutionBottomSheetState();
}

class _SubstitutionBottomSheetState extends State<SubstitutionBottomSheet> {
  int? selectedCourtPosition;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('SUBSTITUTION', style: AppTypography.headlineMd.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
              IconButton(icon: const Icon(Icons.close, color: AppColors.muted), onPressed: () => Navigator.pop(context)),
            ],
          ),
          const SizedBox(height: 16),
          Text('1. Select Court Player to replace', style: AppTypography.labelCaps10.copyWith(color: AppColors.muted, letterSpacing: 1.5)),
          const SizedBox(height: 12),
          SizedBox(
            height: 120,
            child: Obx(() {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 6,
                itemBuilder: (context, index) {
                  int pos = index + 1;
                  var cp = widget.controller.courtPositions[pos];
                  if (cp == null) return const SizedBox.shrink();
                  
                  bool isSelected = selectedCourtPosition == pos;
                  return GestureDetector(
                    onTap: () => setState(() => selectedCourtPosition = pos),
                    child: Container(
                      width: 80,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primaryContainer.withOpacity(0.2) : AppColors.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isSelected ? AppColors.primaryContainer : AppColors.surfaceContainerHighest),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(cp.player.jerseyNumber, style: AppTypography.headlineLg.copyWith(color: isSelected ? AppColors.primaryContainer : AppColors.primary)),
                          const SizedBox(height: 4),
                          Text('P$pos', style: AppTypography.labelCaps10.copyWith(color: AppColors.muted)),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          const SizedBox(height: 24),
          Text('2. Select Bench Player to bring in', style: AppTypography.labelCaps10.copyWith(color: AppColors.muted, letterSpacing: 1.5)),
          const SizedBox(height: 12),
          Expanded(
            child: Obx(() {
              if (widget.controller.benchPlayers.isEmpty) {
                return Center(child: Text("No bench players available", style: AppTypography.bodyMd.copyWith(color: AppColors.muted)));
              }
              return ListView.builder(
                itemCount: widget.controller.benchPlayers.length,
                itemBuilder: (context, index) {
                  var bp = widget.controller.benchPlayers[index];
                  return BenchPlayerCard(
                    player: bp,
                    onSwap: () {
                      if (selectedCourtPosition == null) {
                        Get.snackbar("Error", "Please select a court player first.", backgroundColor: AppColors.error, colorText: AppColors.primary);
                        return;
                      }
                      widget.controller.substitutePlayer(selectedCourtPosition!, bp);
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
