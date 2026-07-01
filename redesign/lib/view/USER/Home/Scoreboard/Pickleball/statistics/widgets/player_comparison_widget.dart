import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class PlayerComparisonWidget extends StatelessWidget {
  PlayerComparisonWidget({super.key});

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
          Text(
            'Player Comparison',
            style: AppTypography.headlineSm.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('J. Smith (A)', style: AppTypography.bodyMd.copyWith(color: AppColors.primaryContainer, fontWeight: FontWeight.bold)),
              Text('vs', style: AppTypography.labelCaps10.copyWith(color: AppColors.muted)),
              Text('K. Jones (B)', style: AppTypography.bodyMd.copyWith(color: AppColors.muted, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 16),
          Divider(color: AppColors.surfaceContainerHighest),
          _buildRow('82%', 'Serve %', '71%'),
          _buildRow('78%', 'Return %', '65%'),
          _buildRow('24', 'Dinks', '18'),
          _buildRow('12', 'Smashes', '7'),
          _buildRow('14', 'Errors', '19'),
          _buildRow('8', 'Net Winners', '3'),
          _buildRow('7.2', 'Rally Avg', '6.8'),
        ],
      ),
    );
  }

  Widget _buildRow(String valA, String label, String valB) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: ResponsiveHelper.w(40), child: Text(valA, style: AppTypography.bodyMd.copyWith(color: AppColors.primaryContainer, fontWeight: FontWeight.bold))),
          Text(label, style: AppTypography.labelCaps10.copyWith(color: AppColors.muted)),
          SizedBox(width: ResponsiveHelper.w(40), child: Text(valB, style: AppTypography.bodyMd.copyWith(color: AppColors.muted, fontWeight: FontWeight.bold), textAlign: TextAlign.right)),
        ],
      ),
    );
  }
}
