import 'package:flutter/material.dart';
import '../qr_in_bookings_screen.dart';
import 'qr_card.dart';

class LocationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return QrCard(
      title: 'Location',
      trailing: const Text('2.5 km away',
          style: TextStyle(color: QrBookingConstants.green, fontWeight: FontWeight.w600)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Plot No 45, behind FC Road, Shivajinagar, Pune, Maharashtra 411005',
            style: TextStyle(color: QrBookingConstants.muted),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () {},
            icon: const Icon(Icons.near_me_outlined),
            label: const Text('Get Directions'),
          )
        ],
      ),
    );
  }
}
