import 'package:redesign/theme/app_colors.dart';
import 'package:flutter/material.dart';
import '../../../../../../../model/User_Models/Home_Models/Scoreboard_Model/Football/player_model.dart';
import 'player_status_chip.dart';
import 'package:redesign/theme/responsive_helper.dart';

class PlayerCardWidget extends StatelessWidget {
  final PlayerModel player;

  PlayerCardWidget({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final bool isAvailable = !player.isLocked;

    Widget cardContent = Container(
      margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16), vertical: ResponsiveHelper.h(6)),
      padding: EdgeInsets.all(ResponsiveHelper.w(12)),
      decoration: BoxDecoration(
        color: Color(0xFF121212).withValues(alpha: isAvailable ? 1.0 : 0.5),
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
        border: Border.all(color: Color(0xFF1E1E1E)),
      ),
      child: Row(
        children: [
          // Avatar with Jersey overlay
          SizedBox(
            width: ResponsiveHelper.w(50),
            height: ResponsiveHelper.h(50),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: ResponsiveHelper.w(50),
                  height: ResponsiveHelper.h(50),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
                    color: AppColors.background,
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: player.avatarImage != null
                      ? Image.network(player.avatarImage!, fit: BoxFit.cover, color: isAvailable ? null : Colors.grey, colorBlendMode: isAvailable ? null : BlendMode.saturation)
                      : Icon(Icons.person, color: Colors.grey, size: 30),
                ),
                Positioned(
                  bottom: -4,
                  left: -4,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(6), vertical: ResponsiveHelper.h(2)),
                    decoration: BoxDecoration(
                      color: isAvailable ? AppColors.accent : Colors.grey,
                      borderRadius: BorderRadius.circular(ResponsiveHelper.w(4)),
                    ),
                    child: Text(
                      player.jerseyNumber,
                      style: TextStyle(
                        color: AppColors.background,
                        fontSize: ResponsiveHelper.sp(10),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 16),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  player.name,
                  style: TextStyle(
                    color: isAvailable ? Colors.white : Colors.grey,
                    fontSize: ResponsiveHelper.sp(16),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '${player.position} • ${player.fitness}',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: ResponsiveHelper.sp(12),
                  ),
                ),
              ],
            ),
          ),
          // Status and Actions
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              PlayerStatusChip(status: player.availability),
              SizedBox(height: 4),
              if (isAvailable)
                Text(
                  'Form: ${player.form}',
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: ResponsiveHelper.sp(10),
                  ),
                )
              else
                Text(
                  'Return: ${player.returnWeeks}',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: ResponsiveHelper.sp(10),
                  ),
                ),
            ],
          ),
          SizedBox(width: 12),
          Icon(
            isAvailable ? Icons.drag_indicator : Icons.lock_outline,
            color: Colors.grey,
            size: 20,
          ),
        ],
      ),
    );

    if (isAvailable) {
      return Draggable<String>(
        data: player.id,
        feedback: Material(
          color: Colors.transparent,
          child: Opacity(
            opacity: 0.8,
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 32,
              child: cardContent,
            ),
          ),
        ),
        childWhenDragging: Opacity(
          opacity: 0.3,
          child: cardContent,
        ),
        child: cardContent,
      );
    } else {
      return cardContent;
    }
  }
}
