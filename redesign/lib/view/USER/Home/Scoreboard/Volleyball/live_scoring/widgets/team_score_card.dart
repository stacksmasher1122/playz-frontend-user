import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';

class TeamScoreCard extends StatelessWidget {
  final String teamName;
  final int setsWon;
  final int score;
  final bool isServing;

  const TeamScoreCard({
    super.key,
    required this.teamName,
    required this.setsWon,
    required this.score,
    required this.isServing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceContainerHighest),
      ),
      child: Stack(
        children: [
          if (isServing)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 4,
                decoration: const BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
                  boxShadow: [
                    BoxShadow(color: AppColors.primaryContainer, blurRadius: 8, spreadRadius: 2),
                  ],
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        teamName.toUpperCase(),
                        style: AppTypography.headlineSm.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHighest,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        setsWon.toString(),
                        style: AppTypography.headlineMd.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    score.toString(),
                    style: const TextStyle(fontSize: 120, fontWeight: FontWeight.w900, color: AppColors.primary, height: 1),
                  ),
                ),
                const SizedBox(height: 24),
                // Mock Rally indicators (Win, Loss, Win)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildRallyIndicator(true),
                    const SizedBox(width: 8),
                    _buildRallyIndicator(false),
                    const SizedBox(width: 8),
                    _buildRallyIndicator(true),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRallyIndicator(bool won) {
    return Container(
      width: 32,
      height: 4,
      decoration: BoxDecoration(
        color: won ? AppColors.primaryContainer : AppColors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
