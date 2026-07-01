import 'package:flutter/material.dart';
import '../qr_in_bookings_screen.dart';
import 'package:redesign/theme/responsive_helper.dart';

class QrDangerAction extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  QrDangerAction(
    this.label, {super.key, 
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(18)),
        onTap: onTap,
        child: Container(
          padding:
              EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(18), vertical: ResponsiveHelper.h(14)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(18)),
            border: Border.all(
              color: QrBookingConstants.red.withValues(alpha: 0.4),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: QrBookingConstants.red,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
