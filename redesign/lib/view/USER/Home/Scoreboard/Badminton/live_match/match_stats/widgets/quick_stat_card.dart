import 'package:flutter/material.dart';

class QuickStatCard extends StatelessWidget {
  final String label;
  final String value;
  final String? suffix;
  final IconData? backgroundIcon;
  final Color valueColor;

  const QuickStatCard({
    super.key,
    required this.label,
    required this.value,
    this.suffix,
    this.backgroundIcon,
    this.valueColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (backgroundIcon != null)
            Positioned(
              right: -10,
              bottom: -10,
              child: Icon(
                backgroundIcon,
                size: 60,
                color: Colors.grey.shade800.withValues(alpha: 0.3),
              ),
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      color: valueColor,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      height: 1.0,
                    ),
                  ),
                  if (suffix != null) ...[
                    const SizedBox(width: 4),
                    Text(
                      suffix!,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
