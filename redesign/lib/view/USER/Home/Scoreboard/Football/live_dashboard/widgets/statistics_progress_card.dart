import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class StatisticsProgressCard extends StatelessWidget {
  final String title;
  final int valueA;
  final int valueB;
  final bool isPercentage;

  StatisticsProgressCard({
    super.key,
    required this.title,
    required this.valueA,
    required this.valueB,
    this.isPercentage = false,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final total = valueA + valueB;
    final flexA = total == 0 ? 1 : valueA;
    final flexB = total == 0 ? 1 : valueB;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16.0), vertical: ResponsiveHelper.h(6.0)),
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: Colors.grey.shade900.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title.toUpperCase(),
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: ResponsiveHelper.sp(12),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              Row(
                children: [
                  Text(
                    '$valueA${isPercentage ? '%' : ''}',
                    style: TextStyle(
                      color: Color(0xFFC6FF00), // Lime Green
                      fontSize: ResponsiveHelper.sp(14),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    '$valueB${isPercentage ? '%' : ''}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ResponsiveHelper.sp(14),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(4)),
            child: Row(
              children: [
                Expanded(
                  flex: flexA,
                  child: Container(
                    height: ResponsiveHelper.h(8),
                    color: Color(0xFFC6FF00),
                  ),
                ),
                Expanded(
                  flex: flexB,
                  child: Container(
                    height: ResponsiveHelper.h(8),
                    color: Colors.grey.shade800,
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
