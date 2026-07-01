import 'package:flutter/material.dart';
import '../../../../../../../model/User_Models/Home_Models/Scoreboard_Model/Badminton/player_model.dart';
import 'package:redesign/theme/responsive_helper.dart';
// Note: using placeholder color for primary neon

class PlayerAvatarWidget extends StatelessWidget {
  final PlayerModel? player;
  final bool isHighlighted;

  PlayerAvatarWidget({
    super.key,
    required this.player,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    if (player == null) return SizedBox(width: ResponsiveHelper.w(64), height: 64);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: ResponsiveHelper.w(64),
          height: ResponsiveHelper.h(64),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
            border: Border.all(
              color: isHighlighted ? Color(0xFFC6FF00) : Colors.grey.shade800,
              width: ResponsiveHelper.w(2),
            ),
            boxShadow: isHighlighted
                ? [
                    BoxShadow(
                      color: Color(0xFFC6FF00).withValues(alpha: 0.3),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
            child: Image.network(
              player!.avatar,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Icon(Icons.person, color: Colors.grey, size: 32),
            ),
          ),
        ),
        SizedBox(height: 12),
        SizedBox(
          width: ResponsiveHelper.w(80),
          child: Text(
            player!.name.replaceAll(' ', '\n'), // wrap name if multiple words
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.sp(12),
              fontWeight: FontWeight.bold,
              height: ResponsiveHelper.h(1.2),
            ),
          ),
        ),
      ],
    );
  }
}
