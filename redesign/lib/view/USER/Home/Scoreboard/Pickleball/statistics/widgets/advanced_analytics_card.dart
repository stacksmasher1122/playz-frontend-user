import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';

class AdvancedAnalyticsCard extends StatelessWidget {
  const AdvancedAnalyticsCard({super.key});

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
            'Advanced Analytics',
            style: AppTypography.headlineSm.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 2.5,
            children: [
              _buildMetricCard('Win Probability', '68%'),
              _buildMetricCard('Momentum Index', '+1.2'),
              _buildMetricCard('Pressure Perf.', 'High'),
              _buildMetricCard('Critical Pts', '4/5'),
              _buildMetricCard('Game Conv %', '66%'),
              _buildMetricCard('Serve Effic.', '1.4'),
              _buildMetricCard('Kitchen Ctrl %', '58%'),
              _buildMetricCard('Expected Win %', '72%'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: AppTypography.labelCaps10.copyWith(color: AppColors.muted), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Text(value, style: AppTypography.bodyMd.copyWith(color: AppColors.primaryContainer, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
