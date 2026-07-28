import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class VenueAmenitiesGrid extends StatelessWidget {
  final List<String> amenities;

  const VenueAmenitiesGrid({
    super.key,
    required this.amenities,
  });

  IconData _getAmenityIcon(String amenity) {
    switch (amenity.toLowerCase()) {
      case 'parking':
        return Icons.local_parking;
      case 'drinking water':
        return Icons.water_drop;
      case 'change room':
        return Icons.meeting_room;
      case 'equipment':
      case 'fitness center':
        return Icons.fitness_center;
      case 'wifi':
      case 'free wifi':
        return Icons.wifi;
      case 'trainers':
        return Icons.people;
      case 'lighting':
        return Icons.lightbulb;
      case 'washroom':
      case 'shower':
        return Icons.shower;
      case 'ac':
      case 'air conditioning':
        return Icons.ac_unit;
      case 'first aid':
        return Icons.medical_services;
      case 'cctv':
      case 'security':
        return Icons.videocam;
      case 'seating':
      case 'gallery':
        return Icons.event_seat;
      case 'cafeteria':
      case 'food':
        return Icons.restaurant;
      case 'locker':
        return Icons.lock;
      default:
        return Icons.check_circle_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    if (amenities.isEmpty) {
      return SizedBox.shrink();
    }

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
            children: amenities.map((amenity) {
              return Container(
                width: MediaQuery.of(context).size.width / 2 - 22,
                padding: EdgeInsets.all(ResponsiveHelper.w(12)),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
                ),
                child: Column(
                  children: [
                    Icon(_getAmenityIcon(amenity), color: Colors.white),
                    SizedBox(height: 6),
                    Text(
                      amenity,
                      style: TextStyle(color: Color(0xFFA7A7A7)),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
