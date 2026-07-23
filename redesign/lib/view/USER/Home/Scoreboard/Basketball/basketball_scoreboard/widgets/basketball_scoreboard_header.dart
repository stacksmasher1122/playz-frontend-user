import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/app_dimensions.dart';
import '../../../../../../../model/User_Models/Home_Models/Scoreboard_Model/Basketball/basketball_state_models.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Basketball/basketball_controller.dart';
import 'player_stats_drawer.dart';

class BasketballScoreboardHeader extends StatelessWidget {
  final BasketballMatchState state;
  final BasketballController controller;

  const BasketballScoreboardHeader({super.key, required this.state, required this.controller});

  @override
  Widget build(BuildContext context) {
    String quarterText = state.currentQuarter > 4 ? 'OT${state.currentQuarter - 4}' : 'Q${state.currentQuarter}';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMd, vertical: AppDimensions.paddingSm),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  state.homeTeam.teamName,
                  style: AppTypography.headlineMd.copyWith(fontFamily: 'Sora', color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Column(
                children: [
                  Text(quarterText, style: AppTypography.headlineSm.copyWith(color: AppColors.accent)),
                  const SizedBox(height: 2),
                  _buildPossessionArrow(),
                ],
              ),
              Expanded(
                child: Text(
                  state.awayTeam.teamName,
                  textAlign: TextAlign.right,
                  style: AppTypography.headlineMd.copyWith(fontFamily: 'Sora', color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingSm),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(Icons.bar_chart, color: Colors.grey),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: AppColors.surface,
                  isScrollControlled: true,
                  builder: (context) => SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: PlayerStatsDrawer(state: state),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPossessionArrow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.arrow_left,
          color: state.possessionArrowTeamId == 'home' ? Colors.white : Colors.grey.withOpacity(0.3),
          size: 20,
        ),
        Text('POSS', style: AppTypography.labelCaps.copyWith(color: Colors.grey)),
        Icon(
          Icons.arrow_right,
          color: state.possessionArrowTeamId == 'away' ? Colors.white : Colors.grey.withOpacity(0.3),
          size: 20,
        ),
      ],
    );
  }
}
