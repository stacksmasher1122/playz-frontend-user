import 'package:flutter/material.dart';
import '../qr_in_bookings_screen.dart';

class QrAmountRow extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const QrAmountRow(
    this.label,
    this.value, {
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: highlight ? Colors.white : QrBookingConstants.muted,
                fontSize: 13,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: highlight ? Colors.white : Colors.white70,
              fontSize: 14,
              fontWeight:
                  highlight ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
