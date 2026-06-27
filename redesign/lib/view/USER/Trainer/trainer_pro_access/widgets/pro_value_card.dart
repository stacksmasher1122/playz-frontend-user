import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';

const kGreen = AppColors.accent;
const kMuted = Color(0xFFA7A7A7);

class ProValueCard extends StatelessWidget {
  const ProValueCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [kGreen.withOpacity(0.25), Colors.black],
        ),
        border: Border.all(color: kGreen.withOpacity(0.25), width: 1),
        boxShadow: [
          BoxShadow(
            color: kGreen.withOpacity(0.15),
            blurRadius: 5,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ───── Header Row ─────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Icon badge
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: kGreen.withOpacity(0.18),
                ),
                child: const Icon(
                  Icons.trending_up_rounded,
                  color: kGreen,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),

              /// Title + description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Grow Your Business',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Get verified, manage students, and receive secure payouts directly to your bank account.',
                      style: TextStyle(
                        color: kMuted,
                        fontSize: 13.5,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          /// ───── Metrics ─────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              ProValueMetric(value: '5k+', label: 'TRAINERS'),
              ProValueMetric(value: '₹10Cr+', label: 'PAID OUT'),
              ProValueMetric(value: '100%', label: 'SECURE'),
            ],
          ),
        ],
      ),
    );
  }
}

class ProValueMetric extends StatelessWidget {
  final String value;
  final String label;

  const ProValueMetric({super.key, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15.5,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: kMuted,
            fontSize: 11,
            letterSpacing: 0.6,
          ),
        ),
      ],
    );
  }
}
