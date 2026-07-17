import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Volleyball/volleyball_stats_controller.dart';

class MomentumChart extends StatelessWidget {
  final VolleyballStatsController controller;

  MomentumChart({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('LIVE\nMOMENTUM', style: AppTypography.headlineMd.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold)),
            Row(
              children: [
                _buildLegend(AppColors.accent, 'GIANTS'),
                SizedBox(width: 16),
                _buildLegend(AppColors.outlineVariant, 'WOLVES'),
              ],
            ),
          ],
        ),
        SizedBox(height: 24),
        SizedBox(
          height: 150,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(20, (index) {
              double valA = controller.momentumTeamA[index];
              double valB = controller.momentumTeamB[index];
              bool aDominates = valA > valB;
              double height = (aDominates ? valA : valB) * 150;
              Color color = aDominates ? AppColors.accent : AppColors.outlineVariant;

              return Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.0),
                  child: Container(
                    height: height,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(2)),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('START SET 3', style: AppTypography.labelCaps10.copyWith(color: AppColors.muted)),
            Text('10m', style: AppTypography.labelCaps10.copyWith(color: AppColors.muted)),
            Text('20m', style: AppTypography.labelCaps10.copyWith(color: AppColors.muted)),
            Text('NOW', style: AppTypography.labelCaps10.copyWith(color: AppColors.muted)),
          ],
        ),
      ],
    );
  }

  Widget _buildLegend(Color color, String text) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        SizedBox(width: 6),
        Text(text, style: AppTypography.labelCaps10.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
