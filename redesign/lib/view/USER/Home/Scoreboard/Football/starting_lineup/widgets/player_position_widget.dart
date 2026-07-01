import 'package:flutter/material.dart';
import '../../../../../../../model/User_Models/Home_Models/Scoreboard_Model/Football/player_model.dart';
import 'package:redesign/theme/responsive_helper.dart';

class PlayerPositionWidget extends StatelessWidget {
  final PlayerModel player;
  final String label;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  PlayerPositionWidget({
    super.key,
    required this.player,
    required this.label,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: ResponsiveHelper.w(50),
            height: ResponsiveHelper.h(50),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
              border: Border.all(color: Color(0xFFC6FF00), width: 2), // Lime border
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFC6FF00).withValues(alpha: 0.4),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: ClipOval(
              child: player.avatarImage != null
                  ? Image.network(player.avatarImage!, fit: BoxFit.cover)
                  : Icon(Icons.person, color: Colors.grey.shade600, size: 30),
            ),
          ),
          SizedBox(height: 4),
          Container(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(6), vertical: ResponsiveHelper.h(2)),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(4)),
            ),
            child: Text(
              player.name.toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveHelper.sp(10),
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
