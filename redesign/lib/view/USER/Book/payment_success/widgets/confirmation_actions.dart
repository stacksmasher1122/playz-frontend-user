import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ConfirmationActions extends StatelessWidget {
  final VoidCallback onGoToBookings;
  final VoidCallback onInviteFriends;

  ConfirmationActions({
    super.key,
    required this.onGoToBookings,
    required this.onInviteFriends,
  });

  static const _kGreen = AppColors.accent;

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _kGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(30)),
              ),
              padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(16)),
            ),
            onPressed: onGoToBookings,
            child: Text(
              'Go to My Bookings',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
        ),
        SizedBox(height: 12),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Colors.grey.shade800),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(30)),
            ),
            padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(14), horizontal: ResponsiveHelper.w(32)),
          ),
          onPressed: onInviteFriends,
          child: Text(
            'Invite Friends',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
