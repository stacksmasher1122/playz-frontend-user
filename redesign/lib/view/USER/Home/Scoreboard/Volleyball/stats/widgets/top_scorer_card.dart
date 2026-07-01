import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Volleyball/volleyball_stats_controller.dart';

class TopScorerCard extends StatelessWidget {
  final VolleyballStatsController controller;

  TopScorerCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('TOP SCORERS', style: AppTypography.headlineMd.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.surfaceContainerHighest),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(controller.teamAName.toUpperCase(), style: AppTypography.labelCaps10.copyWith(color: AppColors.primaryContainer)),
            ),
          ],
        ),
        SizedBox(height: 16),
        Obx(() {
          return Column(
            children: controller.topScorers.map((scorer) {
              return Container(
                margin: EdgeInsets.only(bottom: 12),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.surfaceContainerHighest),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.person, color: AppColors.muted),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(scorer.player.name.toUpperCase(), style: AppTypography.bodyLg.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text('${scorer.player.position.toUpperCase()} • #${scorer.player.jerseyNumber}', style: AppTypography.labelCaps10.copyWith(color: AppColors.muted, letterSpacing: 1.2)),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(scorer.totalPoints.toString(), style: AppTypography.headlineLg.copyWith(color: AppColors.primaryContainer, fontWeight: FontWeight.bold)),
                        Text('PTS', style: AppTypography.labelCaps10.copyWith(color: AppColors.muted, letterSpacing: 1.5)),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        }),
      ],
    );
  }
}
