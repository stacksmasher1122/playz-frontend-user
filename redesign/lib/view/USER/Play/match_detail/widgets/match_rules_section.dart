import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MatchRulesSection extends StatelessWidget {
  final List<String>? rules;

  const MatchRulesSection({
    super.key,
    this.rules,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final rulesList = (rules != null && rules!.isNotEmpty)
        ? rules!
        : [
            "Fair Play Required",
            "Report 15m Early",
            "Equipment Provided",
            "Full Refund if Cancelled",
          ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.widthPct(4.5)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(context.minDimensionPct(4.5)),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "MATCH RULES & GUIDELINES",
            style: AppTypography.labelCaps10.copyWith(
              fontSize: context.responsiveFont(12),
              letterSpacing: 0.8,
              fontWeight: FontWeight.bold,
              color: AppColors.muted,
            ),
          ),
          SizedBox(height: context.heightPct(1.5)),
          Wrap(
            spacing: context.widthPct(2.5),
            runSpacing: context.heightPct(1.2),
            children: rulesList.map((rule) => _RuleChip(rule)).toList(),
          ),
        ],
      ),
    );
  }
}

class _RuleChip extends StatelessWidget {
  final String label;

  const _RuleChip(this.label);

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.widthPct(3.5),
        vertical: context.heightPct(1),
      ),
      decoration: BoxDecoration(
        color: AppColors.textPrimary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Text(
        label,
        style: AppTypography.bodySm.copyWith(
          fontSize: context.responsiveFont(12),
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
