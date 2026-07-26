import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
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
      padding: EdgeInsets.all(ResponsiveHelper.w(18)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(18)),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "MATCH RULES & GUIDELINES",
            style: GoogleFonts.inter(
              fontSize: ResponsiveHelper.sp(12),
              letterSpacing: 0.8,
              fontWeight: FontWeight.bold,
              color: AppColors.muted,
            ),
          ),
          SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
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
        horizontal: ResponsiveHelper.w(14),
        vertical: ResponsiveHelper.h(8),
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
        border: Border.all(color: Colors.white12),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: ResponsiveHelper.sp(12),
          color: Colors.white70,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
