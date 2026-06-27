import 'package:flutter/material.dart';
import '../match_detail_constants.dart';

class HostReliabilityCard extends StatelessWidget {
  const HostReliabilityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF111827), Color(0xFF052e1b)],
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "RELIABILITY",
            style: TextStyle(fontSize: 12, color: MatchDetailColors.textSecondary),
          ),
          SizedBox(height: 16),
          Text(
            "98%",
            style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 6),
          Text(
            "Trusted Host",
            style: TextStyle(
              color: MatchDetailColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
