import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class LiveEfficiencyCard extends StatelessWidget {
  LiveEfficiencyCard({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      margin: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(24)),
      padding: EdgeInsets.all(ResponsiveHelper.w(20)),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('LIVE EFFICIENCY', style: AppTypography.labelCaps10.copyWith(color: AppColors.muted, letterSpacing: 2)),
          SizedBox(height: 24),
          _buildStatRow('ATTACK SUCCESS', '54%', 0.54, AppColors.accent),
          SizedBox(height: 16),
          _buildStatRow('RECEPTION QUALITY', '2.41', 0.8, Colors.blueAccent),
          SizedBox(height: 16),
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
        SizedBox(height: 8),
        LinearProgressIndicator(
          value: percent,
          backgroundColor: AppColors.outlineVariant,
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 4,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(2)),
        ),
      ],
    );
  }
}
