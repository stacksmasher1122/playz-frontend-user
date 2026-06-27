import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';

class QrVenueInfoCard extends StatelessWidget {
  const QrVenueInfoCard({super.key});

  static const _kCard = Color(0xFF1A1A1A);
  static const _kGreen = AppColors.accent;
  static const _kMuted = Color(0xFFA7A7A7);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _kCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on, color: _kGreen),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Venue',
                  style: TextStyle(color: _kMuted, fontSize: 12),
                ),
                SizedBox(height: 4),
                Text(
                  'Shivajinagar, Pune',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Gate Access',
                style: TextStyle(color: _kMuted, fontSize: 12),
              ),
              const SizedBox(height: 4),
              const Text(
                'QR Scan Required',
                style: TextStyle(color: _kGreen),
              ),
              const SizedBox(height: 6),
              OutlinedButton.icon(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: _kGreen),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                icon: const Icon(Icons.navigation, size: 16, color: _kGreen),
                label: const Text(
                  'Get Directions',
                  style: TextStyle(color: _kGreen),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
