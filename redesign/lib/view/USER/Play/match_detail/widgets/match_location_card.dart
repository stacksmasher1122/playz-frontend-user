import 'package:flutter/material.dart';
import '../match_detail_constants.dart';

class MatchLocationCard extends StatelessWidget {
  const MatchLocationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MatchDetailColors.surfaceSoft,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          Container(
            height: 140,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              image: DecorationImage(
                image: NetworkImage(
                  "https://images.unsplash.com/photo-1508609349937-5ec4ae374ebf",
                ),
                fit: BoxFit.cover,
                opacity: 0.35,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Badminton Hub",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Text(
                  "Sector 4, HSR Layout",
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
