import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/app_dimensions.dart';
import '../../../../../../../model/User_Models/Home_Models/Scoreboard_Model/Basketball/basketball_state_models.dart';

class PlayerStatsDrawer extends StatelessWidget {
  final BasketballMatchState state;

  const PlayerStatsDrawer({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              color: AppColors.surface,
              child: TabBar(
                indicatorColor: AppColors.accent,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(text: state.homeTeam.teamName),
                  Tab(text: state.awayTeam.teamName),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildTeamStats(state.homeTeam),
                  _buildTeamStats(state.awayTeam),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamStats(BasketballTeamState team) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      itemCount: team.roster.length,
      separatorBuilder: (context, index) => const Divider(color: AppColors.surface),
      itemBuilder: (context, index) {
        final player = team.roster[index];
        return ListTile(
          title: Row(
            children: [
              Text(player.name, style: AppTypography.bodyLg.copyWith(color: Colors.white)),
              if (player.isFouledOut) ...[
                const SizedBox(width: AppDimensions.paddingSm),
                Text('(FOULED OUT)', style: AppTypography.labelCaps.copyWith(color: AppColors.warning)),
              ],
              if (player.isEjected) ...[
                const SizedBox(width: AppDimensions.paddingSm),
                Text('(EJECTED)', style: AppTypography.labelCaps.copyWith(color: AppColors.error)),
              ],
            ],
          ),
          subtitle: Text(
            'Pts: ${player.points} | Fouls: ${player.fouls} | 3PT: ${player.threePointersMade}',
            style: AppTypography.bodySm.copyWith(color: Colors.grey),
          ),
        );
      },
    );
  }
}
