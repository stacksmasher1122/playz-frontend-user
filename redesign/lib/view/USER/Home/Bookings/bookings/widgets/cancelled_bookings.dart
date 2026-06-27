import 'package:flutter/material.dart';
import 'cancelled_booking_card.dart';

class CancelledBookingsWidget extends StatelessWidget {
  const CancelledBookingsWidget();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      children: const [CancelledBookingCard()],
    );
  }
}
