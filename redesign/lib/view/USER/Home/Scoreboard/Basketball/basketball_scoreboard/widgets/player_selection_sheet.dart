import 'package:flutter/material.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/app_dimensions.dart';
import '../../../../../../../model/User_Models/Home_Models/Scoreboard_Model/Basketball/basketball_state_models.dart';

class PlayerSelectionSheet extends StatelessWidget {
  final BasketballTeamState team;
  final Function(String) onSelected;
  final bool excludeEjected;

  const PlayerSelectionSheet({
    super.key,
    required this.team,
    required this.onSelected,
    this.excludeEjected = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingLg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Select Player', style: AppTypography.headlineMd),
          const SizedBox(height: AppDimensions.paddingMd),
          Expanded(
            child: ListView.builder(
              itemCount: team.roster.length,
              itemBuilder: (context, index) {
                final player = team.roster[index];
                if (excludeEjected && player.isEjected) return const SizedBox.shrink();
                if (excludeEjected && player.isFouledOut) return const SizedBox.shrink();

                return ListTile(
                  title: Text(player.name, style: AppTypography.bodyLg),
                  trailing: Text('Pts: ${player.points}', style: AppTypography.bodySm.copyWith(color: Colors.grey)),
                  onTap: () => onSelected(player.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
