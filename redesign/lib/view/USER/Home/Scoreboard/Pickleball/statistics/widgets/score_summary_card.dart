import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Pickleball/pickleball_stats_controller.dart';

class ScoreSummaryCard extends StatelessWidget {
  final PickleballStatsController controller;

  const ScoreSummaryCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceContainerHighest, width: 1),
      ),
      child: Column(
        children: [
          Text(
            'FINAL SCORE',
            style: AppTypography.labelCaps10.copyWith(color: AppColors.muted, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'MATCH COMPLETE',
            style: AppTypography.headlineLg.copyWith(
              color: AppColors.primaryContainer,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text('TEAM ALPHA', style: AppTypography.labelCaps10.copyWith(color: AppColors.muted)),
                  const SizedBox(height: 8),
                  Text(
                    '${controller.teamAScore.value}',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 64,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primaryContainer,
                      height: 1.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 24),
              Column(
                children: [
                  Text('vs', style: AppTypography.labelCaps10.copyWith(color: AppColors.muted)),
                  const SizedBox(height: 8),
                  const Text(
                    '—',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 48,
                      fontWeight: FontWeight.w100,
                      color: AppColors.muted,
                      height: 1.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 24),
              Column(
                children: [
                  Text('TEAM OMEGA', style: AppTypography.labelCaps10.copyWith(color: AppColors.muted)),
                  const SizedBox(height: 8),
                  Text(
                    '${controller.teamBScore.value}',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 64,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                      height: 1.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
