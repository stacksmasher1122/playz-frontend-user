import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class VenueAmenitiesGrid extends StatelessWidget {
  VenueAmenitiesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final items = [
      Icons.local_parking,
      Icons.water_drop,
      Icons.meeting_room,
      Icons.fitness_center,
      Icons.wifi,
      Icons.people,
    ];
    final labels = [
      'Parking',
      'Drinking Water',
      'Change Room',
      'Equipment',
      'Free WiFi',
      'Trainers',
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Amenities',
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.sp(18),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: List.generate(
              items.length,
              (index) => Container(
                width: MediaQuery.of(context).size.width / 2 - 22,
                padding: EdgeInsets.all(ResponsiveHelper.w(12)),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
                ),
                child: Column(
                  children: [
                    Icon(items[index], color: Colors.white),
                    SizedBox(height: 6),
                    Text(
                      labels[index],
                      style: TextStyle(color: Color(0xFFA7A7A7)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
