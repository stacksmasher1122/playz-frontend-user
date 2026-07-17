import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Pickleball/match_result_model.dart';
import 'package:redesign/theme/responsive_helper.dart';

class TopPlayersWidget extends StatelessWidget {
  final List<PlayerPerformance> players;

  TopPlayersWidget({super.key, required this.players});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(20)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        border: Border.all(color: AppColors.outlineVariant, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TOP PERFORMERS',
            style: AppTypography.labelCaps10.copyWith(color: AppColors.muted, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: players.length,
            separatorBuilder: (_, __) => Divider(color: AppColors.outlineVariant, height: 24),
            itemBuilder: (context, index) {
              final player = players[index];
              return Row(
                children: [
                  Container(
                    width: ResponsiveHelper.w(48),
                    height: ResponsiveHelper.h(48),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.outlineVariant, width: 1),
                    ),
                    child: CircleAvatar(
                      radius: 23,
                      backgroundImage: NetworkImage('https://i.pravatar.cc/100'),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(player.name, style: AppTypography.bodyMd.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text(
                          '${player.pointsWon} Pts • ${player.aces} Aces • ${player.servePercent}% Serve • ${player.errors} Errors • ${player.winners} Winners',
                          style: AppTypography.labelCaps10.copyWith(color: AppColors.muted),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
