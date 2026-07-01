import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class QrVenueInfoCard extends StatelessWidget {
  QrVenueInfoCard({super.key});

  static const _kCard = Color(0xFF1A1A1A);
  static const _kGreen = AppColors.accent;
  static const _kMuted = Color(0xFFA7A7A7);

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: _kCard,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
      ),
      child: Row(
        children: [
          Icon(Icons.location_on, color: _kGreen),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
              Text(
                'Gate Access',
                style: TextStyle(color: _kMuted, fontSize: 12),
              ),
              SizedBox(height: 4),
              Text(
                'QR Scan Required',
                style: TextStyle(color: _kGreen),
              ),
              SizedBox(height: 6),
              OutlinedButton.icon(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: _kGreen),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
                  ),
                ),
                icon: Icon(Icons.navigation, size: 16, color: _kGreen),
                label: Text(
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
