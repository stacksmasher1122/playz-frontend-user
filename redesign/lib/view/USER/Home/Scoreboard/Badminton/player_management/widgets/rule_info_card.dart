import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class RuleInfoCard extends StatelessWidget {
  final String label;
  final String value;
  final String subtitle;

  RuleInfoCard({
    super.key,
    required this.label,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(20)),
      decoration: BoxDecoration(
        color: Colors.grey.shade900.withValues(alpha: 0.8), // dark card
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        border: Border.all(color: Colors.grey.shade800, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey,
              fontSize: ResponsiveHelper.sp(10),
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.sp(24),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey,
              fontSize: ResponsiveHelper.sp(10),
            ),
          ),
        ],
      ),
    );
  }
}
