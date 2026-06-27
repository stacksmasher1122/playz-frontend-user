import 'package:flutter/material.dart';

class VenueAmenitiesGrid extends StatelessWidget {
  const VenueAmenitiesGrid({super.key});

  @override
  Widget build(BuildContext context) {
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Amenities',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: List.generate(
              items.length,
              (index) => Container(
                width: MediaQuery.of(context).size.width / 2 - 22,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Icon(items[index], color: Colors.white),
                    const SizedBox(height: 6),
                    Text(
                      labels[index],
                      style: const TextStyle(color: Color(0xFFA7A7A7)),
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
