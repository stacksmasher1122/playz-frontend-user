import 'package:flutter/material.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Pickleball/pickleball_review_model.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'stat_card_widget.dart';

class MatchStatsGrid extends StatelessWidget {
  final PickleballReviewModel reviewData;

  const MatchStatsGrid({
    super.key,
    required this.reviewData,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 1.2,
        children: [
          StatCardWidget(
            icon: const Icon(Icons.swap_horiz, color: AppColors.primaryContainer, size: 28),
            label: 'GAMES',
            value: reviewData.gamesFormat,
          ),
          StatCardWidget(
            icon: const Icon(Icons.scoreboard_outlined, color: AppColors.primaryContainer, size: 28),
            label: 'TARGET',
            value: '${reviewData.targetPoints} Points',
          ),
          StatCardWidget(
            icon: Text('+2', style: AppTypography.headlineMd.copyWith(color: AppColors.primaryContainer, fontWeight: FontWeight.bold)),
            label: 'WIN BY 2',
            value: reviewData.winByTwo ? 'Active' : 'Inactive',
          ),
          StatCardWidget(
            icon: const Icon(Icons.bolt, color: AppColors.primaryContainer, size: 28),
            label: 'MODE',
            value: reviewData.scoringMode,
          ),
        ],
      ),
    );
  }
}
