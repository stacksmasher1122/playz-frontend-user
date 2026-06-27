import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'fee_success_simple_card.dart';

const kGreen = AppColors.accent;
const kMuted = Color(0xFFA7A7A7);

class NextStepsCard extends StatelessWidget {
  const NextStepsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeeSuccessSimpleCard(
      title: 'NEXT STEPS',
      children: [
        StepRow(
          step: '1',
          title: 'Complete Your Profile',
          subtitle: 'Add photos and bio to attract students',
        ),
        StepRow(
          step: '2',
          title: 'Set Availability',
          subtitle: 'Define your training slots',
        ),
        StepRow(
          step: '3',
          title: 'Start Accepting Students',
          subtitle: 'Reply to incoming leads',
        ),
      ],
    );
  }
}

class StepRow extends StatelessWidget {
  final String step;
  final String title;
  final String subtitle;

  const StepRow({
    super.key,
    required this.step,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 28,
            width: 28,
            decoration: const BoxDecoration(
              color: kGreen,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              step,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: kMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
