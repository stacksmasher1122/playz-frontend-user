import 'package:flutter/material.dart';
import '../qr_in_bookings_screen.dart';
import 'package:redesign/theme/responsive_helper.dart';

class QrWeatherAlert extends StatelessWidget {
  QrWeatherAlert({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(14)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        gradient: LinearGradient(
          colors: [Color(0xFF3A2C00), Color(0xFF1E1400)],
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.cloud_outlined, color: QrBookingConstants.amber),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Light rain expected during your slot. Venue has covered roof available.',
              style: TextStyle(color: QrBookingConstants.amber),
            ),
          ),
        ],
      ),
    );
  }
}
