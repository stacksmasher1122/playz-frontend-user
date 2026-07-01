import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Volleyball/volleyball_stats_controller.dart';

class MatchScoreHeader extends StatelessWidget {
  final VolleyballStatsController controller;

  MatchScoreHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceContainerHighest),
      ),
      child: Column(
        children: [
          // Team A
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (controller.isTeamAServing) 
                      Text('SERVING', style: AppTypography.labelCaps10.copyWith(color: AppColors.primaryContainer, letterSpacing: 2)),
                    Text(
                      controller.teamAName.toUpperCase(),
                      style: AppTypography.headlineLg.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  _buildSetDot(true),
                  SizedBox(width: 4),
                  _buildSetDot(true),
                  SizedBox(width: 4),
                  _buildSetDot(false),
                ],
              ),
            ],
          ),
          SizedBox(height: 24),
          
          // Score
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(controller.teamAScore.toString(), style: TextStyle(fontSize: 80, fontWeight: FontWeight.w900, color: AppColors.primaryContainer, height: 1)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Text('SET ${controller.currentSet}', style: AppTypography.headlineSm.copyWith(color: AppColors.muted)),
                    SizedBox(height: 8),
                    if (controller.isMatchPoint)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: AppColors.error.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                        child: Text('MATCH POINT', style: AppTypography.labelCaps10.copyWith(color: AppColors.error, fontWeight: FontWeight.bold)),
                      ),
                  ],
                ),
              ),
              Text(controller.teamBScore.toString(), style: TextStyle(fontSize: 80, fontWeight: FontWeight.w900, color: AppColors.muted, height: 1)),
            ],
          ),
          SizedBox(height: 24),
          
          // Team B
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                controller.teamBName.toUpperCase(),
                style: AppTypography.headlineLg.copyWith(color: AppColors.muted, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  _buildSetDot(true),
                  SizedBox(width: 4),
                  _buildSetDot(false),
                  SizedBox(width: 4),
                  _buildSetDot(false),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSetDot(bool won) {
    return Container(
      width: 24,
      height: 12,
      decoration: BoxDecoration(
        color: won ? AppColors.primaryContainer : AppColors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
