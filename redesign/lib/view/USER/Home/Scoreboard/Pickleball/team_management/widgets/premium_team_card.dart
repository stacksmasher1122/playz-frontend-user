import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Pickleball/pickleball_player_model.dart';
import 'premium_player_card.dart';
import 'empty_team_widget.dart';
import 'dart:ui';

class PremiumTeamCard extends StatelessWidget {
  final String teamName;
  final List<PickleballPlayerModel> players;
  final int maxPlayers;
  final Function(int index) onRemove;
  final Function(int slot) onEmptySlotTap;

  const PremiumTeamCard({
    super.key,
    required this.teamName,
    required this.players,
    required this.maxPlayers,
    required this.onRemove,
    required this.onEmptySlotTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isReady = players.length == maxPlayers;

    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16), vertical: ResponsiveHelper.w(12)),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.02),
              borderRadius: BorderRadius.vertical(top: Radius.circular(ResponsiveHelper.w(16))),
              border: Border(bottom: BorderSide(color: AppColors.outlineVariant)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      teamName,
                      style: AppTypography.headlineMd.copyWith(color: AppColors.onPrimary, fontWeight: FontWeight.bold),
                    ),
                    if (players.isNotEmpty) ...[
                      SizedBox(width: 8),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: AppColors.accent.withOpacity(0.5)),
                        ),
                        child: Text("CAPTAIN", style: AppTypography.bodySm.copyWith(color: AppColors.accent, fontSize: 8)),
                      ),
                    ]
                  ],
                ),
                Row(
                  children: [
                    if (isReady) Icon(Icons.check_circle, color: AppColors.accent, size: 16),
                    SizedBox(width: 4),
                    Text(
                      '${players.length}/$maxPlayers PLAYERS',
                      style: AppTypography.labelCaps.copyWith(color: isReady ? AppColors.accent : AppColors.muted),
                    ),
                  ],
                ),
              ],
            ),
          ),
          AnimatedSize(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: Padding(
              padding: EdgeInsets.all(ResponsiveHelper.w(16)),
              child: players.isEmpty
                  ? EmptyTeamWidget(onTap: () => onEmptySlotTap(0))
                  : Column(
                      children: List.generate(maxPlayers, (index) {
                        if (index < players.length) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: index == maxPlayers - 1 ? 0 : 8.0),
                            child: PremiumPlayerCard(
                              player: players[index],
                              onRemove: () => onRemove(index),
                              isReady: true,
                            ),
                          );
                        } else {
                          return Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: InkWell(
                              onTap: () => onEmptySlotTap(index),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.accent.withOpacity(0.5), style: BorderStyle.solid),
                                  color: AppColors.accent.withOpacity(0.05),
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.add_circle_outline, color: AppColors.accent, size: 20),
                                      SizedBox(width: 8),
                                      Text("SELECT PLAYER ${index + 1}", style: AppTypography.bodyLg.copyWith(color: AppColors.accent)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                      }),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
