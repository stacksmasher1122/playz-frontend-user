import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class FormatSummary extends StatelessWidget {
  final Map<String, dynamic> data;

  const FormatSummary({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    final format = data['format'] ?? {};
    final String matchType = format['matchType']?.toString().toUpperCase() ?? 'N/A';
    final String teamMode = format['teamMode'] ?? 'N/A';

    return Container(
      padding: EdgeInsets.all(context.widthPct(4)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Format & Rules",
            style: AppTypography.headlineSm.copyWith(
              color: AppColors.textPrimary,
              fontSize: context.responsiveFont(16),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: context.heightPct(1.5)),
          Wrap(
            spacing: context.widthPct(2.5),
            runSpacing: context.heightPct(1),
            children: [
              _buildPill(context, Icons.account_tree_rounded, matchType),
              _buildPill(context, Icons.group_rounded, teamMode.toUpperCase()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPill(BuildContext context, IconData icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.widthPct(3),
        vertical: context.heightPct(0.8),
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.accent, size: 16),
          SizedBox(width: context.widthPct(1.5)),
          Text(
            text,
            style: AppTypography.labelCaps10.copyWith(
              color: AppColors.textPrimary,
              fontSize: context.responsiveFont(11),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
