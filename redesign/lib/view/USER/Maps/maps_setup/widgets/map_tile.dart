import 'package:flutter/material.dart';
import 'package:redesign/view/USER/Maps/maps_constants.dart';
import 'package:redesign/theme/responsive_helper.dart';


class MapTile extends StatelessWidget {
  MapTile({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(14)),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [kCard, kSurface.withValues(alpha: 0.8)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(ResponsiveHelper.w(10)),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(10)),
            ),
            child: Icon(Icons.location_on_outlined, color: Colors.white),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Choose location on map",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Move pin to set precise location",
                  style: TextStyle(color: kMuted, fontSize: 12),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.white70),
        ],
      ),
    );
  }
}
