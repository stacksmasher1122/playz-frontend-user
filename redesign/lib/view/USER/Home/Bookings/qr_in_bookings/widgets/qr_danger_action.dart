import 'package:flutter/material.dart';
import '../qr_in_bookings_screen.dart';

class QrDangerAction extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const QrDangerAction(
    this.label, {
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: QrBookingConstants.red.withOpacity(0.4),
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: QrBookingConstants.red,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
