import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/court_player_model.dart';
import 'badges.dart';
import 'package:redesign/theme/responsive_helper.dart';

class CourtPlayerCard extends StatelessWidget {
  final CourtPlayerModel courtPlayer;
  final bool isCaptain;
  final bool isLibero;

  CourtPlayerCard({
    super.key,
    required this.courtPlayer,
    this.isCaptain = false,
    this.isLibero = false,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    bool isServing = courtPlayer.isServing;
    Color borderColor = isServing ? AppColors.accent : AppColors.outlineVariant;
    Color bgColor = isLibero ? AppColors.outlineVariant : AppColors.background;

    return Container(
      width: ResponsiveHelper.w(80),
      height: ResponsiveHelper.h(100),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        border: Border.all(color: borderColor, width: isServing ? 2 : 1),
        boxShadow: isServing ? [BoxShadow(color: AppColors.accent.withOpacity(0.3), blurRadius: 10)] : [],
      ),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  courtPlayer.player.jerseyNumber,
                  style: AppTypography.headlineLg.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'P${courtPlayer.courtPosition}: ${courtPlayer.player.position.split(' ').last.replaceAll('(', '').replaceAll(')', '')}',
                  style: AppTypography.labelCaps10.copyWith(color: AppColors.muted, fontSize: 8),
                ),
              ],
            ),
          ),
          if (isServing)
            Positioned(
              top: -6,
              right: -6,
              child: ServerBadge(),
            ),
          if (isLibero && !isServing)
            Positioned(
              top: -6,
              right: -6,
              child: LiberoBadge(),
            ),
          if (isCaptain)
            Positioned(
              bottom: ResponsiveHelper.h(4),
              right: ResponsiveHelper.w(4),
              child: CaptainBadge(),
            ),
        ],
      ),
    );
  }
}
