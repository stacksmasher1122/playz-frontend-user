import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Volleyball/volleyball_stats_controller.dart';

class TeamStatisticsCard extends StatelessWidget {
  final VolleyballStatsController controller;

  const TeamStatisticsCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    if (controller.teamAStats.value == null || controller.teamBStats.value == null) return const SizedBox.shrink();
    
    var statsA = controller.teamAStats.value!;
    var statsB = controller.teamBStats.value!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('TEAM STATS', style: AppTypography.headlineMd.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        _buildStatRow('ATTACK SUCCESS', '${statsA.attackSuccessPercent}%', '${statsB.attackSuccessPercent}%', statsA.attackSuccessPercent, statsB.attackSuccessPercent),
        _buildStatRow('BLOCKS', '${statsA.blocks}', '${statsB.blocks}', statsA.blocks, statsB.blocks),
        _buildStatRow('ACES', '${statsA.aces.toString().padLeft(2, '0')}', '${statsB.aces.toString().padLeft(2, '0')}', statsA.aces, statsB.aces),
        _buildStatRow('DIGS', '${statsA.digs}', '${statsB.digs}', statsA.digs, statsB.digs),
      ],
    );
  }

  Widget _buildStatRow(String label, String valA, String valB, num rawA, num rawB) {
    double total = (rawA + rawB).toDouble();
    if (total == 0) total = 1; // Prevent division by zero
    double ratioA = rawA / total;
    double ratioB = rawB / total;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(valA, style: AppTypography.bodyLg.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
              Text(label, style: AppTypography.labelCaps10.copyWith(color: AppColors.muted, letterSpacing: 1.5)),
              Text(valB, style: AppTypography.bodyLg.copyWith(color: AppColors.muted, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                flex: (ratioA * 100).toInt(),
                child: Container(height: 4, color: AppColors.primaryContainer),
              ),
              const SizedBox(width: 4),
              Expanded(
                flex: (ratioB * 100).toInt(),
                child: Container(height: 4, color: AppColors.surfaceContainerHighest),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
