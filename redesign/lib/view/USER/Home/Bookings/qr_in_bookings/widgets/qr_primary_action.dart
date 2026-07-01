import 'package:flutter/material.dart';
import '../qr_in_bookings_screen.dart';
import 'package:redesign/theme/responsive_helper.dart';

class QrPrimaryAction extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  QrPrimaryAction(
    this.label,
    this.icon, {super.key, 
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Material(
      color: QrBookingConstants.green,
      borderRadius: BorderRadius.circular(ResponsiveHelper.w(18)),
      child: InkWell(
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(18)),
        onTap: onTap,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(18), vertical: ResponsiveHelper.h(14)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: Colors.black),
              SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
