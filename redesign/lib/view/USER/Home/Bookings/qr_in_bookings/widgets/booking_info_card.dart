import 'package:flutter/material.dart';
import 'qr_card.dart';
import 'qr_info_row.dart';

class BookingInfoCard extends StatelessWidget {
  const BookingInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return QrCard(
      title: 'Booking Information',
      child: Column(
        children: const [
          QrInfoRow('Venue', 'Neon Futsal Arena'),
          QrInfoRow('Date', 'Today, 24 Oct'),
          QrInfoRow('Time', '20:00 – 21:00', highlight: true),
          QrInfoRow('Sport', 'Football (5-a-side)'),
          QrInfoRow('Court', 'Court 4'),
          QrInfoRow('Duration', '60 mins'),
          QrInfoRow('Players', '10 max'),
        ],
      ),
    );
  }
}
