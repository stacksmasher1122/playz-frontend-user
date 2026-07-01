import 'package:flutter/material.dart';
import 'completed_booking_card.dart';
import 'package:redesign/theme/responsive_helper.dart';

class PastBookingsWidget extends StatelessWidget {
  PastBookingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return ListView(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 32),
      children: [CompletedBookingCard()],
    );
  }
}
