import 'package:flutter/material.dart';

class ComparisonProgressBar extends StatelessWidget {
  final double homePercentage;
  final double awayPercentage;

  const ComparisonProgressBar({
    super.key,
    required this.homePercentage,
    required this.awayPercentage,
  });

  @override
  Widget build(BuildContext context) {
    // Normalize to ensure total is exactly 1.0 for layout
    final total = homePercentage + awayPercentage;
    final homeFlex = total == 0 ? 50 : (homePercentage / total * 100).round();
    final awayFlex = total == 0 ? 50 : (awayPercentage / total * 100).round();

    return Container(
      height: 8,
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Expanded(
            flex: homeFlex,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFC6FF00), // Lime Green
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  bottomLeft: Radius.circular(4),
                ),
              ),
            ),
          ),
          Expanded(
            flex: awayFlex,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(4),
                  bottomRight: Radius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
