import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MatchTimerWidget extends StatelessWidget {
  final String currentHalf;
  final int currentMinute;

  MatchTimerWidget({
    super.key,
    required this.currentHalf,
    required this.currentMinute,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          currentHalf,
          style: TextStyle(
            color: Colors.grey,
            fontSize: ResponsiveHelper.sp(12),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 8),
        Text(
          '•',
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
        SizedBox(width: 8),
        Text(
          "$currentMinute'",
          style: TextStyle(
            color: Color(0xFFC6FF00), // Lime Green
            fontSize: ResponsiveHelper.sp(14),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
