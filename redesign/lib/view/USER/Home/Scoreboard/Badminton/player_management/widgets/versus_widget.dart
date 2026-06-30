import 'package:flutter/material.dart';

class VersusWidget extends StatelessWidget {
  final String gamesLabel;

  const VersusWidget({
    super.key,
    required this.gamesLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Subtle diagonal green accent decoration
            Transform.rotate(
              angle: -0.2,
              child: Container(
                width: 60,
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFC6FF00).withValues(alpha: 0.1),
                      const Color(0xFFC6FF00).withValues(alpha: 0.0),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const Text(
              'VS',
              style: TextStyle(
                color: Color(0xFFC6FF00), // Neon Yellow-Green
                fontSize: 32,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
                letterSpacing: 2.0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey.shade800,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            gamesLabel,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
        ),
      ],
    );
  }
}
