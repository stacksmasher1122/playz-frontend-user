import 'package:flutter/material.dart';
import '../qr_in_bookings_screen.dart';
import 'qr_card.dart';
import 'package:redesign/theme/responsive_helper.dart';

class LocationCard extends StatelessWidget {
  LocationCard({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return QrCard(
      title: 'Location',
      trailing: Text('2.5 km away',
          style: TextStyle(color: QrBookingConstants.green, fontWeight: FontWeight.w600)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Plot No 45, behind FC Road, Shivajinagar, Pune, Maharashtra 411005',
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
            onPressed: () {},
            icon: Icon(Icons.near_me_outlined),
            label: Text('Get Directions'),
          )
        ],
      ),
    );
  }
}
