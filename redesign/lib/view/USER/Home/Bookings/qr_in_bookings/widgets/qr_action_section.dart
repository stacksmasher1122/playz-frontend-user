import 'package:flutter/material.dart';
import '../qr_in_bookings_screen.dart';
import 'qr_danger_action.dart';
import 'qr_outlined_action.dart';
import 'qr_primary_action.dart';

class QrActionSection extends StatelessWidget {
  final BookingStatus status;
  const QrActionSection({required this.status});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        if (status == BookingStatus.confirmed)
          QrPrimaryAction('Chat with Venue', Icons.chat),
        QrOutlinedAction('Add to Calendar', Icons.event),
        if (status == BookingStatus.confirmed)
          QrOutlinedAction('Reschedule', Icons.schedule),
        QrDangerAction('Cancel Booking'),
      ],
    );
  }
}
