import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';

class ConfirmationActions extends StatelessWidget {
  final VoidCallback onGoToBookings;
  final VoidCallback onInviteFriends;

  const ConfirmationActions({
    super.key,
    required this.onGoToBookings,
    required this.onInviteFriends,
  });

  static const _kGreen = AppColors.accent;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _kGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: onGoToBookings,
            child: const Text(
              'Go to My Bookings',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Colors.grey.shade800),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
          ),
          onPressed: onInviteFriends,
          child: const Text(
            'Invite Friends',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
