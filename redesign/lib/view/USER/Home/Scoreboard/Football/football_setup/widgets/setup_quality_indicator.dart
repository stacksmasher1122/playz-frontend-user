import 'package:flutter/material.dart';
import 'setup_constants.dart';

class SetupQualityIndicator extends StatelessWidget {
  final double progress;

  const SetupQualityIndicator({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Setup Quality",
                style: TextStyle(
                  color: kTextSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  if (progress >= 1.0)
                    const Icon(Icons.verified, color: kAccent, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    "${(progress * 100).toInt()}%",
                    style: TextStyle(
                      color: progress >= 1.0 ? kAccent : kWarning,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: kSurfaceHighlight,
              valueColor: AlwaysStoppedAnimation(
                progress >= 1.0 ? kAccent : kWarning,
              ),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }
}
