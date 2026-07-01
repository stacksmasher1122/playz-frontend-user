import 'package:flutter/material.dart';
import '../../../../../../../../model/User_Models/Home_Models/Scoreboard_Model/Badminton/timeline_model.dart';
import 'momentum_graph_widget.dart';
import 'package:redesign/theme/responsive_helper.dart';

class GameTimelineCard extends StatelessWidget {
  final TimelineModel timeline;

  GameTimelineCard({
    super.key,
    required this.timeline,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      padding: EdgeInsets.all(ResponsiveHelper.w(20)),
      decoration: BoxDecoration(
        color: Colors.grey.shade900.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'GAME 0${timeline.gameNumber}',
            style: TextStyle(
              color: Color(0xFFC6FF00), // Neon Yellow-Green
              fontSize: ResponsiveHelper.sp(10),
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${timeline.playerOneScore} — ${timeline.playerTwoScore}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.sp(28),
                  fontWeight: FontWeight.w900,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
              SizedBox(width: 12),
              Text(
                timeline.duration,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: ResponsiveHelper.sp(10),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'MOMENTUM GRAPH',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: ResponsiveHelper.sp(10),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              Text(
                timeline.description,
                style: TextStyle(
                  color: Colors.white, // In screenshot, it is sometimes green or white
                  fontSize: ResponsiveHelper.sp(10),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          MomentumGraphWidget(
            momentumBars: timeline.momentumBars,
          ),
        ],
      ),
    );
  }
}
