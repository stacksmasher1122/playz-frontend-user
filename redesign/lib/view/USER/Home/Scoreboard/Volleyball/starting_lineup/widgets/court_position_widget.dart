import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/volleyball_player_model.dart';
import 'package:get/get.dart';

class CourtPositionWidget extends StatelessWidget {
  final int position;
  final VolleyballPlayerModel? player;
  final Function(VolleyballPlayerModel) onAccept;
  final VoidCallback onTap;

  const CourtPositionWidget({
    super.key,
    required this.position,
    required this.player,
    required this.onAccept,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return DragTarget<VolleyballPlayerModel>(
      onAcceptWithDetails: (details) {
        onAccept(details.data);
      },
      builder: (context, candidateData, rejectedData) {
        bool isHovering = candidateData.isNotEmpty;
        
        return GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isHovering 
                  ? AppColors.primaryContainer.withOpacity(0.2)
                  : (player != null ? AppColors.surfaceContainerHigh : AppColors.surfaceContainerLowest),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isHovering 
                    ? AppColors.primaryContainer 
                    : (player != null ? AppColors.primaryContainer.withOpacity(0.5) : AppColors.surfaceContainerHighest),
                width: isHovering ? 2 : 1,
              ),
              boxShadow: isHovering ? [
                BoxShadow(
                  color: AppColors.primaryContainer.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                )
              ] : [],
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 8,
                  left: 8,
                  child: Text(
                    'P$position',
                    style: AppTypography.labelCaps10.copyWith(color: AppColors.muted),
                  ),
                ),
                if (player == null)
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.muted.withOpacity(0.5)),
                      ),
                      child: const Icon(Icons.add, color: AppColors.muted, size: 24),
                    ),
                  )
                else
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            player!.jerseyNumber,
                            style: AppTypography.headlineSm.copyWith(color: AppColors.onPrimaryContainer, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          player!.name.toUpperCase(),
                          style: AppTypography.labelCaps10.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                if (player != null && player!.isCaptain)
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Text('C', style: AppTypography.labelCaps10.copyWith(color: AppColors.onPrimaryContainer, fontWeight: FontWeight.bold)),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
