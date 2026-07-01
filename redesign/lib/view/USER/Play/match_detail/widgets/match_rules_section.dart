import 'package:flutter/material.dart';
import '../match_detail_constants.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MatchRulesSection extends StatelessWidget {
  MatchRulesSection({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "RULES",
          style: TextStyle(
            fontSize: ResponsiveHelper.sp(12),
            letterSpacing: 1,
            color: MatchDetailColors.textSecondary,
          ),
        ),
        SizedBox(height: 14),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _RuleChip("Best of 3"),
            _RuleChip("21 pts"),
            _RuleChip("Shuttles Provided"),
          ],
        ),
      ],
    );
  }
}

class _RuleChip extends StatelessWidget {
  final String label;

  _RuleChip(this.label);

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16), vertical: ResponsiveHelper.h(10)),
      decoration: BoxDecoration(
        color: MatchDetailColors.surfaceSoft,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(24)),
      ),
      child: Text(label),
    );
  }
}
