import 'package:flutter/material.dart';
import '../qr_in_bookings_screen.dart';
import 'package:redesign/theme/responsive_helper.dart';

class QrAmountRow extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  QrAmountRow(
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
                color: highlight ? Colors.white : QrBookingConstants.muted,
                fontSize: ResponsiveHelper.sp(13),
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: highlight ? Colors.white : Colors.white70,
              fontSize: ResponsiveHelper.sp(14),
              fontWeight:
                  highlight ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
