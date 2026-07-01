import 'package:flutter/material.dart';
import 'completed_booking_card.dart';

class PastBookingsWidget extends StatelessWidget {
  const PastBookingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      children: const [CompletedBookingCard()],
    );
  }
}
