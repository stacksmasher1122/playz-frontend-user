import 'package:flutter/material.dart';
import '../bookings_screen.dart';
import 'package:redesign/theme/responsive_helper.dart';

class BookingsWeatherAlert extends StatelessWidget {
  BookingsWeatherAlert({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      margin: EdgeInsets.fromLTRB(16, 12, 16, 6),
      padding: EdgeInsets.all(ResponsiveHelper.w(14)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        gradient: LinearGradient(
          colors: [Color(0xFF4A1C1C), Color(0xFF2A0F0F)],
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.umbrella, color: MyBookingsConstants.amber),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Heavy rain forecast. Venue will confirm status by 6:00 AM tomorrow.',
              style: TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
