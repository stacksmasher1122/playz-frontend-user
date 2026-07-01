import 'package:flutter/material.dart';
import 'setup_constants.dart';
import 'setup_models.dart';
import 'package:redesign/theme/responsive_helper.dart';

class TeamRow extends StatelessWidget {
  final Team team;
  final VoidCallback onAddPlayer;

  TeamRow({
    super.key,
    required this.team,
    required this.onAddPlayer,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Container(
        padding: EdgeInsets.all(ResponsiveHelper.w(12)),
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
          border: Border.all(color: kDivider),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: team.color,
              radius: 16,
              child: Text(team.name.isNotEmpty ? team.name[0] : "?"),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    team.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kTextPrimary,
                    ),
                  ),
                  Text(
                    team.hasMinPlayers ? "Ready" : "Need more players",
                    style: TextStyle(
                      color: team.hasMinPlayers ? kSuccess : kWarning,
                      fontSize: ResponsiveHelper.sp(12),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.person_add, color: kTextMuted),
              onPressed: onAddPlayer,
            ),
          ],
        ),
      ),
    );
  }
}
