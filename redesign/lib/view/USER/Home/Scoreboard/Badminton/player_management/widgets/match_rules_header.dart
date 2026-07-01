import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MatchRulesHeader extends StatelessWidget {
  MatchRulesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(24.0), vertical: ResponsiveHelper.h(8.0)),
      child: Row(
        children: [
          Container(
            width: ResponsiveHelper.w(8),
            height: ResponsiveHelper.h(8),
            decoration: BoxDecoration(
              color: Color(0xFFC6FF00), // Neon Yellow-Green
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 8),
          Text(
            'MATCH RULES',
            style: TextStyle(
              color: Colors.grey,
              fontSize: ResponsiveHelper.sp(12),
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
