import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class StatsTileWidget extends StatelessWidget {
  final String title;
  final String value;
  final bool isPrimary; // True if it should have lime border/color (e.g. XP Gained)

  StatsTileWidget({
    super.key,
    required this.title,
    required this.value,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: Colors.grey.shade900.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Row(
        children: [
          // Left accent border if primary
          if (isPrimary)
            Container(
              width: ResponsiveHelper.w(4),
              height: ResponsiveHelper.h(40),
              decoration: BoxDecoration(
                color: Color(0xFFC6FF00),
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(2)),
              ),
              margin: EdgeInsets.only(right: 12),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: ResponsiveHelper.sp(12),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  value,
                  style: TextStyle(
                    color: isPrimary ? Color(0xFFC6FF00) : Colors.white,
                    fontSize: ResponsiveHelper.sp(28),
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
