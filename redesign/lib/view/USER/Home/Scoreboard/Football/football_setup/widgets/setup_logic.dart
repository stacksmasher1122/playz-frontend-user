import 'setup_models.dart';

class ValidationEngine {
  static bool validateFriendly(List<Team> teams, int playersPerSide) {
    if (teams.length != 2) return false;
    return teams.every(
      (t) => t.players.length >= playersPerSide,
    ); // Strict check
  }

  static bool validateTournament(List<Team> teams, int expectedCount) {
    return teams.length == expectedCount && teams.isNotEmpty;
  }
}

class BracketEngine {
  static List<MatchFixture> generateKnockout(
    List<Team> teams,
    bool activeThirdPlace,
  ) {
    if (teams.isEmpty) return [];
    List<MatchFixture> fixtures = [];

    // Generate First Round (Quarter/Round of 16 etc)
    int matchCount = teams.length ~/ 2;
    for (int i = 0; i < matchCount; i++) {
      fixtures.add(
        MatchFixture(
          home: teams[i * 2],
          away: teams[(i * 2) + 1],
          date: DateTime.now().add(Duration(days: 1)),
          roundName: _getRoundName(matchCount, 0),
        ),
      );
    }

    // Simulate future rounds placeholders
    int nextRoundMatches = matchCount ~/ 2;
    int roundIndex = 1;
    while (nextRoundMatches >= 1) {
      for (int i = 0; i < nextRoundMatches; i++) {
        fixtures.add(
          MatchFixture(
            date: DateTime.now().add(Duration(days: (roundIndex + 1) * 2)),
            roundName: _getRoundName(nextRoundMatches, roundIndex),
          ),
        );
      }
      nextRoundMatches = nextRoundMatches ~/ 2;
      roundIndex++;
    }

    if (activeThirdPlace) {
      fixtures.add(
        MatchFixture(
          date: DateTime.now().add(Duration(days: roundIndex * 2 + 1)),
          roundName: "Third Place Playoff",
        ),
      );
    }

    return fixtures;
  }

  static String _getRoundName(int matchCount, int depth) {
    if (matchCount == 1) return "Final";
    if (matchCount == 2) return "Semi Final";
    if (matchCount == 4) return "Quarter Final";
    return "Round of ${matchCount * 2}";
  }
}

class LeagueEngine {
  static List<MatchFixture> generateRoundRobin(
    List<Team> teams,
    bool doubleRound,
  ) {
    if (teams.length < 2) return [];
    List<MatchFixture> fixtures = [];
    List<Team> roundTeams = List.from(teams);

    if (roundTeams.length % 2 != 0) {
      roundTeams.add(Team(name: "BYE")); // Dummy team
    }

    int numRounds = roundTeams.length - 1;
    int halfSize = roundTeams.length ~/ 2;

    for (int round = 0; round < numRounds; round++) {
      for (int i = 0; i < halfSize; i++) {
        Team home = roundTeams[i];
        Team away = roundTeams[roundTeams.length - 1 - i];
        if (home.name != "BYE" && away.name != "BYE") {
          fixtures.add(
            MatchFixture(
              home: home,
              away: away,
              date: DateTime.now().add(Duration(days: round * 3)),
              roundName: "Week ${round + 1}",
            ),
          );
        }
      }
      // Rotate teams
      roundTeams.insert(1, roundTeams.removeLast());
    }

    if (doubleRound) {
      // Add logic for return legs
      int currentCount = fixtures.length;
      for (int i = 0; i < currentCount; i++) {
        fixtures.add(
          MatchFixture(
            home: fixtures[i].away,
            away: fixtures[i].home,
            date: fixtures[i].date.add(Duration(days: 90)),
            roundName: "Week ${numRounds + (i ~/ halfSize) + 1}",
          ),
        );
      }
    }

    return fixtures;
  }
}
