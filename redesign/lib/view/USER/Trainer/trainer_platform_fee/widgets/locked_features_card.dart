import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'fee_card_wrapper.dart';

const kMuted = Color(0xFFA7A7A7);
const kGreen = AppColors.accent;

class LockedFeaturesCard extends StatelessWidget {
  const LockedFeaturesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return FeeCardWrapper(
      title: 'LOCKED FEATURES',
      trailing:
          const Icon(Icons.lock, color: kMuted),
      children: [
        const LockRow('Public trainer listing & search'),
        const LockRow('Receiving student leads'),
        const LockRow('In-app chat with students'),
        const LockRow('Accepting payments & bookings'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: kGreen.withOpacity(0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: const [
              Icon(Icons.auto_awesome,
                  color: kGreen, size: 18),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Unlock all features to start earning and growing your career immediately.',
                  style: TextStyle(
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class LockRow extends StatelessWidget {
  final String text;
  const LockRow(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Icon(Icons.lock_outline,
              color: kMuted, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text,
                style: const TextStyle(
                    color: kMuted)),
          ),
        ],
      ),
    );
  }
}
