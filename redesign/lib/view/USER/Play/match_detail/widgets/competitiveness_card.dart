import 'package:flutter/material.dart';
import '../match_detail_constants.dart';

class CompetitivenessCard extends StatelessWidget {
  const CompetitivenessCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: MatchDetailColors.surfaceSoft,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 70,
            height: 70,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: 0.94,
                  strokeWidth: 6,
                  backgroundColor: Colors.white12,
                  color: MatchDetailColors.accentBlue,
                ),
                Text(
                  "94%",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Competitiveness",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Text(
                  "Fair & Balanced Match",
                  style: TextStyle(color: MatchDetailColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
