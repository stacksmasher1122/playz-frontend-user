import 'package:flutter/material.dart';
import '../match_detail_constants.dart';
import 'package:redesign/theme/responsive_helper.dart';

class HostReliabilityCard extends StatelessWidget {
  HostReliabilityCard({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(22)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF111827), Color(0xFF052e1b)],
        ),
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "RELIABILITY",
            style: TextStyle(fontSize: ResponsiveHelper.sp(12), color: MatchDetailColors.textSecondary),
          ),
          SizedBox(height: 16),
          Text(
            "98%",
            style: TextStyle(fontSize: ResponsiveHelper.sp(48), fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 6),
          Text(
            "Trusted Host",
            style: TextStyle(
              color: MatchDetailColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
