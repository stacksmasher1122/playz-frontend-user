import 'package:flutter/material.dart';
import '../../../../../../../../model/User_Models/Home_Models/Scoreboard_Model/Badminton/point_history_model.dart';
import 'package:redesign/theme/responsive_helper.dart';

class PointHistoryCard extends StatelessWidget {
  final PointHistoryModel point;

  PointHistoryCard({
    super.key,
    required this.point,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      width: ResponsiveHelper.w(90),
      margin: EdgeInsets.only(right: 12),
      padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(12), horizontal: ResponsiveHelper.w(8)),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'PT ${point.pointNumber}',
            style: TextStyle(
              color: Colors.grey,
              fontSize: ResponsiveHelper.sp(10),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            point.score,
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.sp(16),
              fontWeight: FontWeight.bold,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
          SizedBox(height: 8),
          Text(
            point.pointType,
            style: TextStyle(
              color: Color(0xFFC6FF00), // Neon Yellow-Green
              fontSize: ResponsiveHelper.sp(10),
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
