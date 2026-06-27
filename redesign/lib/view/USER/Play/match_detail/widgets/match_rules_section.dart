import 'package:flutter/material.dart';
import '../match_detail_constants.dart';

class MatchRulesSection extends StatelessWidget {
  const MatchRulesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "RULES",
          style: TextStyle(
            fontSize: 12,
            letterSpacing: 1,
            color: MatchDetailColors.textSecondary,
          ),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: const [
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

  const _RuleChip(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: MatchDetailColors.surfaceSoft,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(label),
    );
  }
}
