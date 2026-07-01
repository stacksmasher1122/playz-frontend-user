import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'comparison_progress_widget.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MatchStatisticsCard extends StatelessWidget {
  final Map<String, dynamic> statistics;
  final AnimationController barAnimController;

  MatchStatisticsCard({
    super.key,
    required this.statistics,
    required this.barAnimController,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(20)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        border: Border.all(color: AppColors.surfaceContainerHighest, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Match Stats',
                style: AppTypography.headlineSm.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
              ),
              Icon(Icons.trending_up, color: AppColors.muted, size: 24),
            ],
          ),
          SizedBox(height: 24),
          ...statistics.entries.map((entry) {
            String label = entry.key;
            Map<String, dynamic> data = entry.value;
            
            double valA = (data['A'] is double) ? data['A'] : data['A'].toDouble();
            double valB = (data['B'] is double) ? data['B'] : data['B'].toDouble();
            double total = valA + valB;
            double ratioA = total == 0 ? 0.5 : (valA / total);

            String summaryLabel = data.containsKey('Total') 
              ? '${data['Total']} Total' 
              : '${data['Avg']} Avg';

            return Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: ComparisonProgressWidget(
                label: label,
                summary: summaryLabel,
                ratioA: ratioA,
                valueA: '${data['A']} (Team Alpha)',
                valueB: '${data['B']} (Team Omega)',
                animController: barAnimController,
              ),
            );
          }),
        ],
      ),
    );
  }
}
