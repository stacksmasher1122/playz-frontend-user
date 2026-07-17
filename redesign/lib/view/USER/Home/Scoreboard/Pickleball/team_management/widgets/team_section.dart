import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Pickleball/pickleball_player_model.dart';
import 'player_card.dart';
import 'empty_player_slot.dart';
import 'package:redesign/theme/responsive_helper.dart';

class TeamSection extends StatelessWidget {
  final bool isTeamA;
  final List<PickleballPlayerModel> players;
  final int maxPlayers;
  final Function(int index) onRemove;
  final Function(int slot) onEmptySlotTap;

  TeamSection({
    super.key,
    required this.isTeamA,
    required this.players,
    required this.maxPlayers,
    required this.onRemove,
    required this.onEmptySlotTap,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isTeamA ? 'TEAM A' : 'TEAM B',
              style: AppTypography.headlineMd.copyWith(
                color: isTeamA ? AppColors.accent : AppColors.accent,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              '${players.length}/$maxPlayers PLAYERS',
              style: AppTypography.labelCaps.copyWith(color: AppColors.muted),
            ),
          ],
        ),
        SizedBox(height: 16),
        AnimatedSize(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: Column(
            children: List.generate(maxPlayers, (index) {
              if (index < players.length) {
                return PlayerCard(
                  player: players[index],
                  onRemove: () => onRemove(index),
                );
              } else {
                return EmptyPlayerSlot(
                  slotNumber: index + 1,
                  onTap: () => onEmptySlotTap(index),
                );
              }
            }),
          ),
        ),
      ],
    );
  }
}
