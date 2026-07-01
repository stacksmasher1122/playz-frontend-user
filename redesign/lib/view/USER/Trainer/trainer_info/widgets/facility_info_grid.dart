import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

Color kCard = Color(0xFF1A1A1A);
Color kMuted = Color(0xFFA7A7A7);
Color kGreen = AppColors.accent;

class FacilityInfoGrid extends StatelessWidget {
  FacilityInfoGrid({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Facility Info',
          style: TextStyle(
            color: Colors.white,
            fontSize: ResponsiveHelper.sp(18),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),

        GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2,
          ),
          itemCount: 4,
          itemBuilder: (_, index) {
            final items = [
              FacilityData('Surface', 'Astro Turf + Grass', Icons.grass),
              FacilityData(
                'Equipment',
                'Available for Rent',
                Icons.sports_cricket,
              ),
              FacilityData('Batch Size', 'Max 15 Students', Icons.group),
              FacilityData('Parking', 'Free Valet', Icons.local_parking),
            ];
            return FacilityTile(data: items[index]);
          },
        ),
      ],
    );
  }
}

class FacilityTile extends StatelessWidget {
  final FacilityData data;

  FacilityTile({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(12)),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(data.icon, color: kGreen, size: 18),
          SizedBox(height: 8),
          Text(
            data.title,
            style: TextStyle(color: kMuted, fontSize: ResponsiveHelper.sp(11), height: 1.1),
          ),
          SizedBox(height: 2),
          Text(
            data.value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.sp(14),
              fontWeight: FontWeight.w600,
              height: ResponsiveHelper.h(1.2),
            ),
          ),
        ],
      ),
    );
  }
}

class FacilityData {
  final String title;
  final String value;
  final IconData icon;

  FacilityData(this.title, this.value, this.icon);
}
