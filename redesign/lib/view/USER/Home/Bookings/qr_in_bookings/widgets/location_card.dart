import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../qr_in_bookings_screen.dart';
import 'qr_card.dart';
import 'package:redesign/theme/responsive_helper.dart';

class LocationCard extends StatelessWidget {
  final Map<String, dynamic>? bookingData;

  const LocationCard({super.key, this.bookingData});

  Future<void> _launchGoogleMaps() async {
    final turfName = bookingData?['turfName'] ?? '';
    final address = bookingData?['turfAddress'] ?? bookingData?['address'] ?? '';
    final query = Uri.encodeComponent('$turfName $address'.trim());
    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    final address = bookingData?['turfAddress'] ?? bookingData?['address'] ?? 'Local Turf Arena';
    final turfName = bookingData?['turfName'] ?? 'Venue';

    return QrCard(
      title: 'Location',
      trailing: Text(
        turfName,
        style: TextStyle(color: QrBookingConstants.green, fontWeight: FontWeight.w600),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            address,
            style: TextStyle(color: QrBookingConstants.muted),
          ),
          SizedBox(height: 12),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
              ),
            ),
            onPressed: _launchGoogleMaps,
            icon: Icon(Icons.near_me_outlined),
            label: Text('Get Directions'),
          )
        ],
      ),
    );
  }
}
