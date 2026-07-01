import 'package:flutter/material.dart';
import 'setup_constants.dart';
import 'setup_models.dart';
import 'package:redesign/theme/responsive_helper.dart';

class EnginePreview extends StatelessWidget {
  final TournamentType tournamentType;
  final List<MatchFixture> knockoutBracket;
  final List<MatchFixture> leagueFixtures;
  final Map<String, List<Team>> hybridGroups;

  EnginePreview({
    super.key,
    required this.tournamentType,
    required this.knockoutBracket,
    required this.leagueFixtures,
    required this.hybridGroups,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    if (tournamentType == TournamentType.knockout) {
      if (knockoutBracket.isEmpty) {
        return Text(
          "No matches generated",
          style: TextStyle(color: kTextMuted),
        );
      }
      return Column(
        children: knockoutBracket
            .map(
              (m) => ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text(
                  "${m.home?.name} vs ${m.away?.name}",
                  style: TextStyle(color: kTextPrimary, fontSize: 13),
                ),
                subtitle: Text(
                  m.roundName ?? "",
                  style: TextStyle(color: kAccent, fontSize: 10),
                ),
                trailing: Text(
                  "${m.date.day}/${m.date.month}",
                  style: TextStyle(color: kTextMuted, fontSize: 12),
                ),
              ),
            )
            .toList(),
      );
    } else if (tournamentType == TournamentType.league) {
      return Column(
        children: leagueFixtures
            .take(6)
            .map(
              (m) => ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text(
                  "${m.home?.name} vs ${m.away?.name}",
                  style: TextStyle(color: kTextPrimary),
                ),
                subtitle: Text(
                  m.roundName ?? "",
                  style: TextStyle(color: kTextMuted, fontSize: 10),
                ),
                leading: Icon(Icons.circle, size: 6, color: kAccent),
              ),
            )
            .toList(),
      );
    }
    return Column(
      children: hybridGroups.entries
          .map(
            (e) => ExpansionTile(
              title: Text(
                e.key,
                style: TextStyle(
                  color: kTextPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: ResponsiveHelper.sp(14),
                ),
              ),
              children: e.value
                  .map(
                    (t) => ListTile(
                      title: Text(
                        t.name,
                        style: TextStyle(
                          color: kTextSecondary,
                          fontSize: ResponsiveHelper.sp(13),
                        ),
                      ),
                      dense: true,
                      visualDensity: VisualDensity.compact,
                      leading: CircleAvatar(
                        backgroundColor: t.color,
                        radius: 4,
                      ),
                    ),
                  )
                  .toList(),
            ),
          )
          .toList(),
    );
  }
}
