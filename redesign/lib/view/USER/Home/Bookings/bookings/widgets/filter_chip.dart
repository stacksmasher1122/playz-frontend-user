import 'package:flutter/material.dart';
import '../bookings_screen.dart';

class BookingFilterChip extends StatelessWidget {
  final String label;
  final IconData? icon;

  const BookingFilterChip(this.label, {this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Chip(
        backgroundColor: MyBookingsConstants.surface,
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) Icon(icon, size: 14, color: MyBookingsConstants.green),
            if (icon != null) const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
        shape: StadiumBorder(side: BorderSide(color: MyBookingsConstants.green.withOpacity(0.6))),
      ),
    );
  }
}
