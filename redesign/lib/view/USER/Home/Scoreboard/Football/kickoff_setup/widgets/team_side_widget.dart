import 'package:flutter/material.dart';
import '../../../../../../../model/User_Models/Home_Models/Scoreboard_Model/Football/side_selection_model.dart';
import 'package:redesign/theme/responsive_helper.dart';

class TeamSideWidget extends StatelessWidget {
  final SideSelectionModel team;
  final Function(String teamId, String targetSide) onDrag;

  TeamSideWidget({
    super.key,
    required this.team,
    required this.onDrag,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    Color cardColor = team.teamColor == '0xFF4285F4' 
        ? Color(0xFF4285F4).withValues(alpha: 0.8) 
        : Colors.grey.shade800;

    Widget cardContent = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: ResponsiveHelper.w(70),
          height: ResponsiveHelper.h(80),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              team.teamName.substring(0, 1).toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveHelper.sp(24),
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        SizedBox(
          width: ResponsiveHelper.w(80),
          child: Text(
            team.teamName.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.sp(10),
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );

    return Draggable<String>(
      data: team.teamId,
      feedback: Material(
        color: Colors.transparent,
        child: Opacity(
          opacity: 0.8,
          child: cardContent,
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: cardContent,
      ),
      child: cardContent,
    );
  }
}
