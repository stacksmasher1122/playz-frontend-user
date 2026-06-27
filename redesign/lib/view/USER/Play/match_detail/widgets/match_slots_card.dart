import 'package:flutter/material.dart';
import '../match_detail_constants.dart';

class MatchSlotsCard extends StatelessWidget {
  const MatchSlotsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: MatchDetailColors.surfaceSoft,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Slots Filling Fast",
                      style: TextStyle(
                        fontSize: 12,
                        color: MatchDetailColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "8",
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: MatchDetailColors.urgent,
                          ),
                        ),
                        SizedBox(width: 6),
                        Text(
                          "/ 10",
                          style: TextStyle(
                            fontSize: 18,
                            color: MatchDetailColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Match Quality",
                    style: TextStyle(
                      fontSize: 12,
                      color: MatchDetailColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "High Priority ⚡",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: MatchDetailColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 10,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFF59E0B), Color(0xFFFFB020)],
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          const Divider(color: Colors.white12),
          const SizedBox(height: 14),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatColumn("Average Rating", "4.2 ⭐"),
              _StatColumn("Skill Spread", "Balanced ⚖️"),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String title;
  final String value;

  const _StatColumn(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            color: MatchDetailColors.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
