import 'package:flutter/material.dart';
import '../match_detail_constants.dart';
import 'package:redesign/theme/responsive_helper.dart';

class CompetitivenessCard extends StatelessWidget {
  CompetitivenessCard({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(22)),
      decoration: BoxDecoration(
        color: MatchDetailColors.surfaceSoft,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(30)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: ResponsiveHelper.w(70),
            height: ResponsiveHelper.h(70),
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: 0.94,
                  strokeWidth: 6,
                  backgroundColor: Colors.white12,
                  color: MatchDetailColors.accentBlue,
                ),
                Text(
                  "94%",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Competitiveness",
                  style: TextStyle(fontSize: ResponsiveHelper.sp(16), fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Text(
                  "Fair & Balanced Match",
                  style: TextStyle(color: MatchDetailColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
