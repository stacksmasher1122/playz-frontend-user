import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class VenueAmenitiesGrid extends StatelessWidget {
  final List<String> amenities;

  const VenueAmenitiesGrid({
    super.key,
    required this.amenities,
  });

  IconData _getAmenityIcon(String amenity) {
    switch (amenity.toLowerCase().trim()) {
      case 'parking':
        return Icons.local_parking_rounded;
      case 'drinking water':
      case 'water':
        return Icons.water_drop_rounded;
      case 'change room':
      case 'changing room':
        return Icons.meeting_room_rounded;
      case 'equipment':
      case 'fitness center':
      case 'gym':
        return Icons.fitness_center_rounded;
      case 'wifi':
      case 'free wifi':
        return Icons.wifi_rounded;
      case 'trainers':
        return Icons.people_rounded;
      case 'lighting':
      case 'floodlights':
        return Icons.lightbulb_rounded;
      case 'washroom':
      case 'shower':
        return Icons.shower_rounded;
      case 'ac':
      case 'air conditioning':
        return Icons.ac_unit_rounded;
      case 'first aid':
        return Icons.medical_services_rounded;
      case 'cctv':
      case 'security':
        return Icons.videocam_rounded;
      case 'seating':
      case 'gallery':
        return Icons.event_seat_rounded;
      case 'cafeteria':
      case 'food':
        return Icons.restaurant_rounded;
      case 'locker':
        return Icons.lock_rounded;
      default:
        return Icons.star_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    final effectiveAmenities = amenities.isNotEmpty
        ? amenities
        : ['Parking', 'Drinking Water', 'Washroom', 'Floodlights', 'Seating Area', 'First Aid'];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Amenities',
            style: AppTypography.headlineSm.copyWith(
              color: AppColors.textPrimary,
              fontSize: context.responsiveFont(18),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: context.heightPct(1.2)),

          /// SPOTIFY STYLE FILLED GREEN PILLS WITH COMPACT PADDING & PERFECT ALIGNMENT
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: effectiveAmenities.map((amenity) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      _getAmenityIcon(amenity),
                      size: 16,
                      color: AppColors.background,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      amenity,
                      style: AppTypography.headlineSm.copyWith(
                        color: AppColors.background,
                        fontSize: context.responsiveFont(12.5),
                        fontWeight: FontWeight.bold,
                      ),
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
