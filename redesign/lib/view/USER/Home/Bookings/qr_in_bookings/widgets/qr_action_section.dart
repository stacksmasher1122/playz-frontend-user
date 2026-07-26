import 'package:flutter/material.dart';
import '../qr_in_bookings_screen.dart';
import 'qr_danger_action.dart';
import 'package:redesign/theme/responsive_helper.dart';

class QrActionSection extends StatelessWidget {
  final BookingStatus status;
  final Map<String, dynamic>? bookingData;

  QrActionSection({super.key, required this.status, this.bookingData});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        if (status == BookingStatus.confirmed)
          QrDangerAction('Cancel Booking'),
      ],
    );
  }
}
