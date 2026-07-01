import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Pickleball/match_result_model.dart';

class GameBreakdownWidget extends StatelessWidget {
  final List<GameResult> games;

  const GameBreakdownWidget({super.key, required this.games});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceContainerHighest, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.scoreboard_outlined, color: AppColors.muted, size: 20),
              const SizedBox(width: 8),
              Text('GAME BREAKDOWN', style: AppTypography.labelCaps10.copyWith(color: AppColors.muted, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: games.length,
            separatorBuilder: (_, __) => const Divider(color: AppColors.surfaceContainerHighest, height: 32),
            itemBuilder: (context, index) {
              final game = games[index];
              return _buildGameRow(game);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGameRow(GameResult game) {
    bool teamAWon = game.scoreA > game.scoreB;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(game.game, style: AppTypography.labelCaps.copyWith(color: AppColors.muted)),
        Row(
          children: [
            Text(
              game.scoreA.toString().padLeft(2, '0'),
              style: AppTypography.headlineLg.copyWith(
                color: teamAWon ? AppColors.primaryContainer : AppColors.muted,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              game.scoreB.toString().padLeft(2, '0'),
              style: AppTypography.headlineLg.copyWith(
                color: !teamAWon ? AppColors.primaryContainer : AppColors.muted,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
