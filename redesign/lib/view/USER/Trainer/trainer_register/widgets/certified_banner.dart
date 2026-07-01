import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';

const kGreen = AppColors.accent;
const kSurface = Color(0xFF0E0E0E);
const kMuted = Color(0xFFA7A7A7);

class CertifiedBanner extends StatelessWidget {
  const CertifiedBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(colors: [kGreen.withValues(alpha: 0.25), kSurface]),
        border: Border.all(color: kGreen.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: kGreen.withValues(alpha: 0.25),
            ),
            child: const Icon(Icons.verified, color: kGreen),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Certified Trainer Program',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Join 500+ coaches. Manage sessions, track earnings, and grow your athlete base.',
                  style: TextStyle(color: kMuted, fontSize: 13, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
