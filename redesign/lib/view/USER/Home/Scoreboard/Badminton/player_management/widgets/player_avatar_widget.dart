import 'package:flutter/material.dart';
import '../../../../../../../model/User_Models/Home_Models/Scoreboard_Model/Badminton/player_model.dart';
// Note: using placeholder color for primary neon

class PlayerAvatarWidget extends StatelessWidget {
  final PlayerModel? player;
  final bool isHighlighted;

  const PlayerAvatarWidget({
    super.key,
    required this.player,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    if (player == null) return const SizedBox(width: 64, height: 64);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isHighlighted ? const Color(0xFFC6FF00) : Colors.grey.shade800,
              width: 2,
            ),
            boxShadow: isHighlighted
                ? [
                    BoxShadow(
                      color: const Color(0xFFC6FF00).withValues(alpha: 0.3),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(
              player!.avatar,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.person, color: Colors.grey, size: 32),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: 80,
          child: Text(
            player!.name.replaceAll(' ', '\n'), // wrap name if multiple words
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
        ),
      ],
    );
  }
}
