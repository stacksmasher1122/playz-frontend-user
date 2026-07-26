import 'package:flutter/material.dart';
import 'qr_card.dart';
import 'qr_info_row.dart';
import 'package:redesign/theme/responsive_helper.dart';

class BookingInfoCard extends StatelessWidget {
  final Map<String, dynamic>? bookingData;

  BookingInfoCard({super.key, this.bookingData});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    final venue = bookingData?['turfName'] ?? 'PlayZ Arena';
    final date = bookingData?['dateFormatted'] ?? bookingData?['date'] ?? 'N/A';
    final time = bookingData?['timeSlot'] ??
        (bookingData?['startTime'] != null ? '${bookingData!['startTime']} – ${bookingData!['endTime']}' : 'N/A');
    final sport = bookingData?['sport'] ?? 'Ground Sport';
    final court = bookingData?['groundName'] ?? 'Ground 1';
    final bookingId = bookingData?['bookingId'] ?? bookingData?['id'] ?? 'N/A';

    return QrCard(
      title: 'Booking Information',
      child: Column(
        children: [
          QrInfoRow('Venue', venue),
          QrInfoRow('Date', date),
          QrInfoRow('Time', time, highlight: true),
          QrInfoRow('Sport', sport),
          QrInfoRow('Court', court),
          QrInfoRow('Ref ID', '#$bookingId'),
        ],
      ),
    );
  }
}
