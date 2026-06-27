import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'fee_card_wrapper.dart';

const kGreen = AppColors.accent;

class AllowedFeaturesCard extends StatelessWidget {
  const AllowedFeaturesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeeCardWrapper(
      title: 'WHAT YOU CAN DO',
      children: [
        CheckRow('Complete your trainer profile'),
        CheckRow('Upload certifications & details'),
        CheckRow('Set availability & pricing'),
        CheckRow('Access help & support'),
      ],
    );
  }
}

class CheckRow extends StatelessWidget {
  final String text;
  const CheckRow(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Icon(Icons.check_circle,
              color: kGreen, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text,
                style: const TextStyle(
                    color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
