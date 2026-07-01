import 'package:flutter/material.dart';
import '../qr_in_bookings_screen.dart';

class QrWeatherAlert extends StatelessWidget {
  const QrWeatherAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF3A2C00), Color(0xFF1E1400)],
        ),
      ),
      child: const Row(
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
