import 'package:flutter/material.dart';
import 'setup_constants.dart';
import 'setup_models.dart';

class TeamRow extends StatelessWidget {
  final Team team;
  final VoidCallback onAddPlayer;

  const TeamRow({
    super.key,
    required this.team,
    required this.onAddPlayer,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: kDivider),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: team.color,
              radius: 16,
              child: Text(team.name.isNotEmpty ? team.name[0] : "?"),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    team.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kTextPrimary,
                    ),
                  ),
                  Text(
                    team.hasMinPlayers ? "Ready" : "Need more players",
                    style: TextStyle(
                      color: team.hasMinPlayers ? kSuccess : kWarning,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.person_add, color: kTextMuted),
              onPressed: onAddPlayer,
            ),
          ],
        ),
      ),
    );
  }
}
