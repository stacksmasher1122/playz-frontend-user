import 'package:flutter/material.dart';
import '../qr_in_bookings_screen.dart';
import 'package:redesign/theme/responsive_helper.dart';

class QrInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  QrInfoRow(
    this.label,
    this.value, {super.key, 
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(6)),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: QrBookingConstants.muted,
                fontSize: ResponsiveHelper.sp(13),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: highlight ? QrBookingConstants.green : Colors.white,
                fontSize: ResponsiveHelper.sp(13),
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
