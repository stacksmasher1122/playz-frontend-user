import 'package:flutter/material.dart';

class StatisticsProgressCard extends StatelessWidget {
  final String title;
  final int valueA;
  final int valueB;
  final bool isPercentage;

  const StatisticsProgressCard({
    super.key,
    required this.title,
    required this.valueA,
    required this.valueB,
    this.isPercentage = false,
  });

  @override
  Widget build(BuildContext context) {
    final total = valueA + valueB;
    final flexA = total == 0 ? 1 : valueA;
    final flexB = total == 0 ? 1 : valueB;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title.toUpperCase(),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              Row(
                children: [
                  Text(
                    '$valueA${isPercentage ? '%' : ''}',
                    style: const TextStyle(
                      color: Color(0xFFC6FF00), // Lime Green
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '$valueB${isPercentage ? '%' : ''}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Row(
              children: [
                Expanded(
                  flex: flexA,
                  child: Container(
                    height: 8,
                    color: const Color(0xFFC6FF00),
                  ),
                ),
                Expanded(
                  flex: flexB,
                  child: Container(
                    height: 8,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
