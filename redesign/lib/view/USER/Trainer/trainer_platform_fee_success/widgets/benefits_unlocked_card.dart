import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'fee_success_simple_card.dart';

const kGreen = AppColors.accent;

class BenefitsUnlockedCard extends StatelessWidget {
  const BenefitsUnlockedCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeeSuccessSimpleCard(
      title: 'BENEFITS UNLOCKED',
      children: [
        BenefitRow('Verified Trainer Badge Activated'),
        BenefitRow('Public Profile is Now Live'),
        BenefitRow('Student Leads Enabled'),
        BenefitRow('Analytics Dashboard Access'),
      ],
    );
  }
}

class BenefitRow extends StatelessWidget {
  final String text;
  const BenefitRow(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            height: 28,
            width: 28,
            decoration: BoxDecoration(
              color: kGreen.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_rounded, size: 16, color: kGreen),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
