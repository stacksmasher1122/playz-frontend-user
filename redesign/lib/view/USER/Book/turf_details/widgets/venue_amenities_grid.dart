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
      return const SizedBox.shrink();
    }

    final cardWidth = (MediaQuery.of(context).size.width - context.widthPct(11)) / 2;

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
          Wrap(
            spacing: context.widthPct(3),
            runSpacing: context.heightPct(1.2),
            children: amenities.map((amenity) {
              return Container(
                width: cardWidth,
                padding: EdgeInsets.all(context.widthPct(3)),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
                  border: Border.all(color: AppColors.borderDark),
                ),
                child: Column(
                  children: [
                    Icon(_getAmenityIcon(amenity), color: AppColors.textPrimary),
                    SizedBox(height: context.heightPct(0.6)),
                    Text(
                      amenity,
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.muted,
                        fontSize: context.responsiveFont(12),
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
