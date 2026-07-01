import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Pickleball/match_result_model.dart';

class MatchInfoCardWidget extends StatelessWidget {
  final MatchResultModel result;

  const MatchInfoCardWidget({super.key, required this.result});

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
          Text(
            'MATCH INFORMATION',
            style: AppTypography.labelCaps10.copyWith(color: AppColors.muted, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Tournament', result.tournament),
          _buildInfoRow('Court', result.court),
          _buildInfoRow('Referee', result.referee),
          _buildInfoRow('Duration', result.duration),
          _buildInfoRow('Date', result.matchDate),
          _buildInfoRow('Time', result.matchTime),
          _buildInfoRow('Winner', result.winner),
          _buildInfoRow('Runner Up', result.runnerUp),
          _buildInfoRow('Court Type', result.courtType),
          _buildInfoRow('Match ID', result.matchId),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodySm.copyWith(color: AppColors.muted)),
          Text(value, style: AppTypography.bodySm.copyWith(color: AppColors.primary)),
        ],
      ),
    );
  }
}
