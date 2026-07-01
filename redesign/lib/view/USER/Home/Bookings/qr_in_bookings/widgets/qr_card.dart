import 'package:flutter/material.dart';
import '../qr_in_bookings_screen.dart';
import 'package:redesign/theme/responsive_helper.dart';

class QrCard extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing;

  QrCard({super.key, 
    required this.title,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: QrBookingConstants.surface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(title,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700)),
              Spacer(),
              if (trailing != null) trailing!,
            ],
          ),
          SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
