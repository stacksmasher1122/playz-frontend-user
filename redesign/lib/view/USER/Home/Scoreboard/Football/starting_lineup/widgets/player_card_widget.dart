import 'package:flutter/material.dart';
import '../../../../../../../model/User_Models/Home_Models/Scoreboard_Model/Football/player_model.dart';
import 'player_status_chip.dart';

class PlayerCardWidget extends StatelessWidget {
  final PlayerModel player;

  const PlayerCardWidget({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    final bool isAvailable = !player.isLocked;

    Widget cardContent = Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade900.withValues(alpha: isAvailable ? 1.0 : 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Row(
        children: [
          // Avatar with Jersey overlay
          SizedBox(
            width: 50,
            height: 50,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.black,
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: player.avatarImage != null
                      ? Image.network(player.avatarImage!, fit: BoxFit.cover, color: isAvailable ? null : Colors.grey, colorBlendMode: isAvailable ? null : BlendMode.saturation)
                      : Icon(Icons.person, color: Colors.grey.shade600, size: 30),
                ),
                Positioned(
                  bottom: -4,
                  left: -4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: isAvailable ? const Color(0xFFC6FF00) : Colors.grey.shade600,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      player.jerseyNumber,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  player.name,
                  style: TextStyle(
                    color: isAvailable ? Colors.white : Colors.grey.shade500,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${player.position} • ${player.fitness}',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
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
              const SizedBox(height: 4),
              if (isAvailable)
                Text(
                  'Form: ${player.form}',
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 10,
                  ),
                )
              else
                Text(
                  'Return: ${player.returnWeeks}',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 10,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Icon(
            isAvailable ? Icons.drag_indicator : Icons.lock_outline,
            color: Colors.grey.shade600,
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
