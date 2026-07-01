import 'package:flutter/material.dart';
import '../bookings_screen.dart';
import 'package:redesign/theme/responsive_helper.dart';

class BookingFilterChip extends StatelessWidget {
  final String label;
  final IconData? icon;

  BookingFilterChip(this.label, {super.key, this.icon});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: Chip(
        backgroundColor: MyBookingsConstants.surface,
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) Icon(icon, size: 14, color: MyBookingsConstants.green),
            if (icon != null) SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
        shape: StadiumBorder(side: BorderSide(color: MyBookingsConstants.green.withValues(alpha: 0.6))),
      ),
    );
  }
}
