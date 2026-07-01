import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/court_player_model.dart';
import 'badges.dart';

class CourtPlayerCard extends StatelessWidget {
  final CourtPlayerModel courtPlayer;
  final bool isCaptain;
  final bool isLibero;

  const CourtPlayerCard({
    super.key,
    required this.courtPlayer,
    this.isCaptain = false,
    this.isLibero = false,
  });

  @override
  Widget build(BuildContext context) {
    bool isServing = courtPlayer.isServing;
    Color borderColor = isServing ? AppColors.primaryContainer : AppColors.surfaceContainerHighest;
    Color bgColor = isLibero ? AppColors.surfaceContainerHighest : AppColors.surfaceContainerLowest;

    return Container(
      width: 80,
      height: 100,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: isServing ? 2 : 1),
        boxShadow: isServing ? [BoxShadow(color: AppColors.primaryContainer.withOpacity(0.3), blurRadius: 10)] : [],
      ),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  courtPlayer.player.jerseyNumber,
                  style: AppTypography.headlineLg.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'P${courtPlayer.courtPosition}: ${courtPlayer.player.position.split(' ').last.replaceAll('(', '').replaceAll(')', '')}',
                  style: AppTypography.labelCaps10.copyWith(color: AppColors.muted, fontSize: 8),
                ),
              ],
            ),
          ),
          if (isServing)
            const Positioned(
              top: -6,
              right: -6,
              child: ServerBadge(),
            ),
          if (isLibero && !isServing)
            const Positioned(
              top: -6,
              right: -6,
              child: LiberoBadge(),
            ),
          if (isCaptain)
            const Positioned(
              bottom: 4,
              right: 4,
              child: CaptainBadge(),
            ),
        ],
      ),
    );
  }
}
