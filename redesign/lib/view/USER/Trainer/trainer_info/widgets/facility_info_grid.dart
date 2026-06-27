import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';

const Color kCard = Color(0xFF1A1A1A);
const Color kMuted = Color(0xFFA7A7A7);
const Color kGreen = AppColors.accent;

class FacilityInfoGrid extends StatelessWidget {
  const FacilityInfoGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Facility Info',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),

        GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2,
          ),
          itemCount: 4,
          itemBuilder: (_, index) {
            final items = const [
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

  const FacilityTile({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(data.icon, color: kGreen, size: 18),
          const SizedBox(height: 8),
          Text(
            data.title,
            style: const TextStyle(color: kMuted, fontSize: 11, height: 1.1),
          ),
          const SizedBox(height: 2),
          Text(
            data.value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              height: 1.2,
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

  const FacilityData(this.title, this.value, this.icon);
}
