import 'package:flutter/material.dart';
import 'package:redesign/view/USER/Maps/maps_constants.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MapPickerBottomCard extends StatelessWidget {
  final Widget addressPreview;
  final Widget confirmButton;

  MapPickerBottomCard({
    super.key,
    required this.addressPreview,
    required this.confirmButton,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.fromLTRB(16, 10, 16, 20),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.vertical(top: Radius.circular(ResponsiveHelper.w(24))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: ResponsiveHelper.w(40),
            height: ResponsiveHelper.h(4),
            margin: EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(10)),
            ),
          ),

          // Location info with AnimatedSwitcher
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(ResponsiveHelper.w(12)),
                decoration: BoxDecoration(
                  color: kSpotifyGreen.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
                ),
                child: Icon(Icons.location_on, color: kSpotifyGreen),
              ),
              SizedBox(width: 12),
              Expanded(child: addressPreview),
            ],
          ),

          SizedBox(height: 20),

          // Confirm button with state logic
          confirmButton,
        ],
      ),
    );
  }
}
