import 'package:flutter/material.dart';
import 'cancelled_booking_card.dart';
import 'package:redesign/theme/responsive_helper.dart';

class CancelledBookingsWidget extends StatelessWidget {
  CancelledBookingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return ListView(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 32),
      children: [CancelledBookingCard()],
    );
  }
}
