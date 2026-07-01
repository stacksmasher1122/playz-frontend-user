import 'package:flutter/material.dart';
import 'booking_card_upcoming.dart';
import 'weather_alert.dart';
import 'package:redesign/theme/responsive_helper.dart';

class UpcomingBookingsWidget extends StatelessWidget {
  UpcomingBookingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return ListView(
      padding: EdgeInsets.only(bottom: 32),
      children: [BookingsWeatherAlert(), BookingCardUpcoming()],
    );
  }
}
