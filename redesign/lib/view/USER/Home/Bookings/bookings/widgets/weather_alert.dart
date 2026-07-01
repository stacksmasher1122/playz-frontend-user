import 'package:flutter/material.dart';
import '../bookings_screen.dart';

class BookingsWeatherAlert extends StatelessWidget {
  const BookingsWeatherAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF4A1C1C), Color(0xFF2A0F0F)],
        ),
      ),
      child: const Row(
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
