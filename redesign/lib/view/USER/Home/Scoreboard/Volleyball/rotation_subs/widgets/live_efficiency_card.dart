import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';

class LiveEfficiencyCard extends StatelessWidget {
  const LiveEfficiencyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceContainerHighest),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('LIVE EFFICIENCY', style: AppTypography.labelCaps10.copyWith(color: AppColors.muted, letterSpacing: 2)),
          const SizedBox(height: 24),
          _buildStatRow('ATTACK SUCCESS', '54%', 0.54, AppColors.primaryContainer),
          const SizedBox(height: 16),
          _buildStatRow('RECEPTION QUALITY', '2.41', 0.8, Colors.blueAccent),
          const SizedBox(height: 16),
          _buildStatRow('BLOCKING RATIO', '12.5%', 0.125, Colors.white),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, double percent, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTypography.labelCaps10.copyWith(color: AppColors.muted, letterSpacing: 1.5)),
            Text(value, style: AppTypography.labelCaps10.copyWith(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: percent,
          backgroundColor: AppColors.surfaceContainerHighest,
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 4,
          borderRadius: BorderRadius.circular(2),
        ),
      ],
    );
  }
}
