import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/app_dimensions.dart';
import '../../../../../../../model/User_Models/Home_Models/Scoreboard_Model/Basketball/basketball_state_models.dart';

class FoulIndicatorStrip extends StatelessWidget {
  final BasketballMatchState state;

  const FoulIndicatorStrip({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMd, vertical: AppDimensions.paddingSm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTeamFouls(state.homeTeam),
          Text('TEAM FOULS', style: AppTypography.labelCaps.copyWith(color: Colors.grey)),
          _buildTeamFouls(state.awayTeam, isRightAlign: true),
        ],
      ),
    );
  }

  Widget _buildTeamFouls(BasketballTeamState team, {bool isRightAlign = false}) {
    List<Widget> children = [
      Text(
        '${team.teamFoulsInQuarter}',
        style: TextStyle(
          fontFamily: 'JetBrains Mono',
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: team.isInBonus ? AppColors.warning : Colors.white,
        ),
      ),
      if (team.isInBonus) ...[
        const SizedBox(width: AppDimensions.paddingSm),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.warning.withOpacity(0.2),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: AppColors.warning),
          ),
          child: Text('BONUS', style: AppTypography.labelCaps.copyWith(color: AppColors.warning)),
        ),
      ]
    ];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: isRightAlign ? children.reversed.toList() : children,
    );
  }
}
