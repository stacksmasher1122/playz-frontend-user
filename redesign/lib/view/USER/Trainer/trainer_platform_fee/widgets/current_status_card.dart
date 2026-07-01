import 'package:flutter/material.dart';
import 'fee_card_wrapper.dart';

const kMuted = Color(0xFFA7A7A7);
const kAmber = Color(0xFFF5C542);

class CurrentStatusCard extends StatelessWidget {
  const CurrentStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeeCardWrapper(
      title: 'CURRENT STATUS',
      children: [
        StatusRow('Membership Plan', 'None'),
        StatusRow(
          'Access Level',
          'Limited',
          badge: true,
        ),
        StatusRow('Visibility', 'Private'),
      ],
    );
  }
}

class StatusRow extends StatelessWidget {
  final String label;
  final String value;
  final bool badge;

  const StatusRow(
    this.label,
    this.value, {
    super.key,
    this.badge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(label,
                style:
                    const TextStyle(color: kMuted)),
          ),
          badge
              ? Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: kAmber.withValues(alpha: 0.15),
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Limited',
                    style: TextStyle(
                      color: kAmber,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              : Text(value,
                  style: const TextStyle(
                      color: Colors.white)),
        ],
      ),
    );
  }
}
