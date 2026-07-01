import 'package:flutter/material.dart';

class StatsTileWidget extends StatelessWidget {
  final String title;
  final String value;
  final bool isPrimary; // True if it should have lime border/color (e.g. XP Gained)

  const StatsTileWidget({
    super.key,
    required this.title,
    required this.value,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Row(
        children: [
          // Left accent border if primary
          if (isPrimary)
            Container(
              width: 4,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFC6FF00),
                borderRadius: BorderRadius.circular(2),
              ),
              margin: const EdgeInsets.only(right: 12),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  value,
                  style: TextStyle(
                    color: isPrimary ? const Color(0xFFC6FF00) : Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w300,
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
