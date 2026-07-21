import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class FormatSummary extends StatelessWidget {
  final Map<String, dynamic> data;

  const FormatSummary({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final format = data['format'] ?? {};
    final String matchType = format['matchType']?.toString().toUpperCase() ?? 'N/A';
    final String teamMode = format['teamMode'] ?? 'N/A';

    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Format & Rules", style: AppTypography.headlineSm.copyWith(color: AppColors.onPrimary)),
          SizedBox(height: ResponsiveHelper.h(12)),
          Row(
            children: [
              _buildPill(Icons.account_tree, matchType),
              SizedBox(width: ResponsiveHelper.w(12)),
              _buildPill(Icons.group, teamMode.toUpperCase()),
            ],
          ),
          // Additional custom rules can go here if needed.
        ],
      ),
    );
  }

  Widget _buildPill(IconData icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(12), vertical: ResponsiveHelper.h(6)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.accent, size: ResponsiveHelper.w(16)),
          SizedBox(width: ResponsiveHelper.w(6)),
          Text(text, style: AppTypography.labelCaps.copyWith(color: AppColors.onPrimary)),
        ],
      ),
    );
  }
}
