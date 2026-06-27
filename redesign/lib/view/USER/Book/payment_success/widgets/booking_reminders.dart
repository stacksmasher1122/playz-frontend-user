import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';

class BookingReminders extends StatelessWidget {
  const BookingReminders({super.key});

  static const _kGreen = AppColors.accent;
  static const _kMuted = Color(0xFFA7A7A7);

  @override
  Widget build(BuildContext context) {
    final reminders = [
      'Arrive 15 minutes early',
      'Wear non-marking shoes',
      'Show QR code at reception',
      'Cancellations up to 2 hours prior',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Things to Remember',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...reminders.map(
          (e) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                const Icon(Icons.circle, size: 6, color: _kGreen),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(e, style: const TextStyle(color: _kMuted)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
