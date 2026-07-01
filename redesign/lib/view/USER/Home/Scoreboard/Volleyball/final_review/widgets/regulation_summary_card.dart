import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/volleyball_review_model.dart';
import 'review_info_tile.dart';

class RegulationSummaryCard extends StatelessWidget {
  final VolleyballReviewModel reviewData;

  const RegulationSummaryCard({super.key, required this.reviewData});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceContainerHighest),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 180,
            decoration: const BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.gavel, color: AppColors.primaryContainer, size: 16),
                      const SizedBox(width: 8),
                      Text('REGULATION SETTINGS', style: AppTypography.labelCaps10.copyWith(color: AppColors.muted, letterSpacing: 1.5)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ReviewInfoTile(label: 'Best of', value: '${reviewData.config.format.split(" ").last} Sets'),
                  ReviewInfoTile(label: 'Set Points', value: '${reviewData.config.pointsPerSet}'),
                  ReviewInfoTile(label: 'Tie-break', value: '${reviewData.config.finalSetPoints}'),
                  ReviewInfoTile(label: 'Subs / Set', value: '${reviewData.config.substitutions}', isLast: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
