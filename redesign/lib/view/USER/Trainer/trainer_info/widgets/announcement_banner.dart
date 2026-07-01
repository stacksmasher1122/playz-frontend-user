import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

Color kYellow = Color(0xFFFFC107);

class AnnouncementBanner extends StatelessWidget {
  AnnouncementBanner({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: kYellow.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
      ),
      child: Row(
        children: [
          Icon(Icons.campaign, color: kYellow),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Summer Camp Registration Open!\nBatch starts 10th Feb • Limited slots',
              style: TextStyle(color: kYellow),
            ),
          ),
        ],
      ),
    );
  }
}
