import 'package:flutter/material.dart';

const Color kCard = Color(0xFF1A1A1A);

class CertificationsBadges extends StatelessWidget {
  const CertificationsBadges({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Certifications',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          children: const [
            CertBadge(label: 'ACE Personal Trainer'),
            CertBadge(label: 'Sports Nutrition L1'),
          ],
        ),
      ],
    );
  }
}

class CertBadge extends StatelessWidget {
  final String label;
  const CertBadge({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
