import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'performance_progress_widget.dart';

class AnalyticsCardWidget extends StatelessWidget {
  final Map<String, dynamic> analytics;

  const AnalyticsCardWidget({
    super.key,
    required this.analytics,
  });

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
            'MATCH ANALYTICS',
            style: AppTypography.labelCaps10.copyWith(color: AppColors.muted, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          PerformanceProgressWidget(
            label: 'SERVE ACCURACY',
            ratioA: analytics['serveAccuracy'] ?? 0.0,
            labelA: '${((analytics['serveAccuracy'] ?? 0.0) * 100).toInt()}%',
            labelB: '18%',
          ),
          PerformanceProgressWidget(
            label: 'RETURN ACCURACY',
            ratioA: analytics['returnAccuracy'] ?? 0.0,
            labelA: '${((analytics['returnAccuracy'] ?? 0.0) * 100).toInt()}%',
            labelB: '29%',
          ),
          PerformanceProgressWidget(
            label: 'WIN PERCENTAGE',
            ratioA: analytics['winPercent'] ?? 0.0,
            labelA: '${((analytics['winPercent'] ?? 0.0) * 100).toInt()}%',
            labelB: '${(100 - ((analytics['winPercent'] ?? 0.0) * 100).toInt())}%',
          ),
          const SizedBox(height: 16),
          _buildStatRow('FORCED ERRORS', '${analytics['forcedErrors']} - 3'),
          _buildStatRow('UNFORCED ERRORS', '${analytics['unforcedErrors']} - 7'),
          _buildStatRow('NET WINNERS', '${analytics['netWinners']} - 2'),
          _buildStatRow('BREAK POINT CONVERSION', '4/5 - 1/3'),
          _buildStatRow('AVG RALLY LENGTH', '${analytics['avgRally']} - 6 shots'),
          _buildStatRow('LONGEST RALLY', '${analytics['longestRally']} - 24 shots'),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String values) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.labelCaps10.copyWith(color: AppColors.muted)),
          Text(values, style: AppTypography.bodySm.copyWith(color: AppColors.primary)),
        ],
      ),
    );
  }
}
