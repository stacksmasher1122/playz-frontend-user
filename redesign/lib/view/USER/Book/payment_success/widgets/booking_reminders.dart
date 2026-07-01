import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class BookingReminders extends StatelessWidget {
  BookingReminders({super.key});

  static const _kGreen = AppColors.accent;
  static const _kMuted = Color(0xFFA7A7A7);

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final reminders = [
      'Arrive 15 minutes early',
      'Wear non-marking shoes',
      'Show QR code at reception',
      'Cancellations up to 2 hours prior',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Things to Remember',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        ...reminders.map(
          (e) => Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Icon(Icons.circle, size: 6, color: _kGreen),
                SizedBox(width: 10),
                Expanded(
                  child: Text(e, style: TextStyle(color: _kMuted)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
