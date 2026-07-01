import 'package:flutter/material.dart';
import '../../../../../../../model/User_Models/Home_Models/Scoreboard_Model/Football/player_model.dart';

class GoalkeeperWidget extends StatelessWidget {
  final PlayerModel? goalkeeper;
  final VoidCallback onTap;

  const GoalkeeperWidget({
    super.key,
    required this.goalkeeper,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (goalkeeper == null) {
      return GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFC6FF00), width: 2),
                color: Colors.green.shade900.withValues(alpha: 0.5),
              ),
              child: const Center(
                child: Icon(Icons.add, color: Color(0xFFC6FF00), size: 24),
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'GK',
                style: TextStyle(
                  color: Color(0xFFC6FF00),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green.shade900, // distinctive GK color
              border: Border.all(color: const Color(0xFFC6FF00), width: 2),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFC6FF00).withValues(alpha: 0.4),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: ClipOval(
              child: goalkeeper!.avatarImage != null
                  ? Image.network(goalkeeper!.avatarImage!, fit: BoxFit.cover)
                  : Icon(Icons.person, color: Colors.grey.shade400, size: 30),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              goalkeeper!.name.toUpperCase(),
              style: const TextStyle(
                color: Color(0xFFC6FF00),
                fontSize: 10,
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
