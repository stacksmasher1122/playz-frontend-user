import 'package:flutter/material.dart';
import '../qr_in_bookings_screen.dart';

class QrInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const QrInfoRow(
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
              style: const TextStyle(
                color: QrBookingConstants.muted,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: highlight ? QrBookingConstants.green : Colors.white,
                fontSize: 13,
                fontWeight:
                    highlight ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
