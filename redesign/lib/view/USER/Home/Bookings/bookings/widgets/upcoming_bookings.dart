import 'package:flutter/material.dart';
import 'booking_card_upcoming.dart';
import 'weather_alert.dart';

class UpcomingBookingsWidget extends StatelessWidget {
  const UpcomingBookingsWidget();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(bottom: 32),
      children: const [BookingsWeatherAlert(), BookingCardUpcoming()],
    );
  }
}
