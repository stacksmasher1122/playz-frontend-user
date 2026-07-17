import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/volleyball_player_model.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/responsive_helper.dart';

class CourtPositionWidget extends StatelessWidget {
  final int position;
  final VolleyballPlayerModel? player;
  final Function(VolleyballPlayerModel) onAccept;
  final VoidCallback onTap;

  CourtPositionWidget({
    super.key,
    required this.position,
    required this.player,
    required this.onAccept,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return DragTarget<VolleyballPlayerModel>(
      onAcceptWithDetails: (details) {
        onAccept(details.data);
      },
      builder: (context, candidateData, rejectedData) {
        bool isHovering = candidateData.isNotEmpty;
        
        return GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isHovering 
                  ? AppColors.accent.withOpacity(0.2)
                  : (player != null ? AppColors.card : AppColors.background),
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
              border: Border.all(
                color: isHovering 
                    ? AppColors.accent 
                    : (player != null ? AppColors.accent.withOpacity(0.5) : AppColors.outlineVariant),
                width: isHovering ? 2 : 1,
              ),
              boxShadow: isHovering ? [
                BoxShadow(
                  color: AppColors.accent.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                )
              ] : [],
            ),
            child: Stack(
              children: [
                Positioned(
                  top: ResponsiveHelper.h(8),
                  left: ResponsiveHelper.w(8),
                  child: Text(
                    'P$position',
                    style: AppTypography.labelCaps10.copyWith(color: AppColors.muted),
                  ),
                ),
                if (player == null)
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(ResponsiveHelper.w(8)),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.muted.withOpacity(0.5)),
                      ),
                      child: Icon(Icons.add, color: AppColors.muted, size: 24),
                    ),
                  )
                else
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16), vertical: ResponsiveHelper.h(12)),
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
                          ),
                          child: Text(
                            player!.jerseyNumber,
                            style: AppTypography.headlineSm.copyWith(color: AppColors.background, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          player!.name.toUpperCase(),
                          style: AppTypography.labelCaps10.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                if (player != null && player!.isCaptain)
                  Positioned(
                    bottom: ResponsiveHelper.h(8),
                    right: ResponsiveHelper.w(8),
                    child: Container(
                      padding: EdgeInsets.all(ResponsiveHelper.w(4)),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                      ),
                      child: Text('C', style: AppTypography.labelCaps10.copyWith(color: AppColors.background, fontWeight: FontWeight.bold)),
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
