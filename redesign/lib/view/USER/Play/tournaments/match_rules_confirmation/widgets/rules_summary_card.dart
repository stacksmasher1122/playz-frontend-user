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
    ResponsiveHelper.init(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.widthPct(4)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Tournament Rules",
            style: AppTypography.headlineSm.copyWith(
              color: AppColors.textPrimary,
              fontSize: context.responsiveFont(16),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: context.heightPct(1)),
          Text(
            "These rules were locked at tournament creation and cannot be changed here.",
            style: AppTypography.bodySm.copyWith(
              color: AppColors.muted,
              fontSize: context.responsiveFont(12),
            ),
          ),
          SizedBox(height: context.heightPct(2)),
          if (sportRules.isEmpty)
            Text(
              "No specific rules configured.",
              style: AppTypography.bodyMd.copyWith(
                color: AppColors.textPrimary,
                fontSize: context.responsiveFont(14),
              ),
            )
          else
            ...sportRules.entries.map((e) => Padding(
              padding: EdgeInsets.only(bottom: context.heightPct(1)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _formatKey(e.key),
                      style: AppTypography.bodyMd.copyWith(
                        color: AppColors.muted,
                        fontSize: context.responsiveFont(13),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: context.widthPct(2)),
                  Text(
                    e.value.toString(),
                    style: AppTypography.bodyMd.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: context.responsiveFont(13.5),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            )),
        ],
      ),
    );
  }

  String _formatKey(String key) {
    if (key.isEmpty) return key;
    // Example: pointsPerGame -> Points Per Game
    String formatted = key.replaceAllMapped(RegExp(r'[A-Z]'), (match) => ' ${match.group(0)}');
    return formatted[0].toUpperCase() + formatted.substring(1);
  }
}
