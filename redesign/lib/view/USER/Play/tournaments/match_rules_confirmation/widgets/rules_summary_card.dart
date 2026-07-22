import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class RulesSummaryCard extends StatelessWidget {
  final Map<String, dynamic> sportRules;

  const RulesSummaryCard({
    super.key,
    required this.sportRules,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Tournament Rules", style: AppTypography.headlineSm.copyWith(color: AppColors.onPrimary)),
          SizedBox(height: ResponsiveHelper.h(8)),
          Text("These rules were locked at tournament creation and cannot be changed here.", style: AppTypography.bodySm.copyWith(color: AppColors.muted)),
          SizedBox(height: ResponsiveHelper.h(16)),
          if (sportRules.isEmpty)
            Text("No specific rules configured.", style: AppTypography.bodyMd.copyWith(color: AppColors.onPrimary))
          else
            ...sportRules.entries.map((e) => Padding(
              padding: EdgeInsets.only(bottom: ResponsiveHelper.h(8)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatKey(e.key),
                    style: AppTypography.bodyMd.copyWith(color: AppColors.muted),
                  ),
                  Text(
                    e.value.toString(),
                    style: AppTypography.bodyMd.copyWith(color: AppColors.onPrimary, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )),
        ],
      ),
    );
  }

  String _formatKey(String key) {
    // Example: pointsPerGame -> Points Per Game
    String formatted = key.replaceAllMapped(RegExp(r'[A-Z]'), (match) => ' ${match.group(0)}');
    return formatted[0].toUpperCase() + formatted.substring(1);
  }
}
