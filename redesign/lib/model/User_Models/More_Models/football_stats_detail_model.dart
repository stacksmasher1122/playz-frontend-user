class FootballRecentMatchModel {
  final String opponent;
  final String dateAndMinutes;
  final double rating;
  final int goals;
  final int assists;
  final bool isMvp;
  final bool hasYellowCard;
  final bool hasRedCard;

  const FootballRecentMatchModel({
    required this.opponent,
    required this.dateAndMinutes,
    required this.rating,
    required this.goals,
    required this.assists,
    this.isMvp = false,
    this.hasYellowCard = false,
    this.hasRedCard = false,
  });
}

class FootballStatsDetailModel {
  final String playerRole;
  final int totalMatches;
  final String tierName;

  // Goals & Assists
  final int goals;
  final double goalsPerMatch;
  final int assists;
  final double assistsPerMatch;
  final int goalContributions; // G+A
  final double gaPerMatch;

  // Metrics Grid
  final int minPlayed;
  final double goalsPer90;
  final double assistsPer90;
  final int shotsOnTarget;
  final int bigChances;
  final int keyPasses;
  final int dribblesWon;
  final int succTackles;

  // Accuracy Bars
  final int shotAccuracyPct;
  final int passAccuracyPct;
  final int crossAccuracyPct;

  // Radar Profile Attributes (Shooting, Passing, Vision, Physical, Pace, Dribbling)
  final double shooting;
  final double passing;
  final double vision;
  final double physical;
  final double pace;
  final double dribbling;

  // Record & Discipline
  final int wins;
  final int draws;
  final int losses;
  final int winRatePct;
  final int goalsInWins;
  final int yellowCards;
  final int redCards;
  final int fouls;
  final int offsides;

  // Recent Matches
  final List<FootballRecentMatchModel> recentMatches;

  const FootballStatsDetailModel({
    required this.playerRole,
    required this.totalMatches,
    required this.tierName,
    required this.goals,
    required this.goalsPerMatch,
    required this.assists,
    required this.assistsPerMatch,
    required this.goalContributions,
    required this.gaPerMatch,
    required this.minPlayed,
    required this.goalsPer90,
    required this.assistsPer90,
    required this.shotsOnTarget,
    required this.bigChances,
    required this.keyPasses,
    required this.dribblesWon,
    required this.succTackles,
    required this.shotAccuracyPct,
    required this.passAccuracyPct,
    required this.crossAccuracyPct,
    required this.shooting,
    required this.passing,
    required this.vision,
    required this.physical,
    required this.pace,
    required this.dribbling,
    required this.wins,
    required this.draws,
    required this.losses,
    required this.winRatePct,
    required this.goalsInWins,
    required this.yellowCards,
    required this.redCards,
    required this.fouls,
    required this.offsides,
    required this.recentMatches,
  });

  static FootballStatsDetailModel getSampleData() {
    return const FootballStatsDetailModel(
      playerRole: 'Forward | Right Footed | Strikers FC',
      totalMatches: 18,
      tierName: 'GOLD TIER',
      goals: 24,
      goalsPerMatch: 1.33,
      assists: 12,
      assistsPerMatch: 0.66,
      goalContributions: 36,
      gaPerMatch: 2.00,
      minPlayed: 1420,
      goalsPer90: 1.52,
      assistsPer90: 0.76,
      shotsOnTarget: 38,
      bigChances: 14,
      keyPasses: 42,
      dribblesWon: 27,
      succTackles: 15,
      shotAccuracyPct: 62,
      passAccuracyPct: 78,
      crossAccuracyPct: 45,
      shooting: 88.0,
      passing: 76.0,
      vision: 82.0,
      physical: 80.0,
      pace: 86.0,
      dribbling: 84.0,
      wins: 10,
      draws: 5,
      losses: 3,
      winRatePct: 55,
      goalsInWins: 18,
      yellowCards: 2,
      redCards: 0,
      fouls: 14,
      offsides: 7,
      recentMatches: [
        FootballRecentMatchModel(
          opponent: 'vs Northside FC',
          dateAndMinutes: 'Apr 12 • 90\' Played',
          rating: 9.2,
          goals: 2,
          assists: 1,
          isMvp: true,
          hasYellowCard: true,
        ),
        FootballRecentMatchModel(
          opponent: 'vs East End Utd',
          dateAndMinutes: 'Apr 05 • 90\' Played',
          rating: 6.4,
          goals: 0,
          assists: 0,
        ),
        FootballRecentMatchModel(
          opponent: 'vs City Strikers',
          dateAndMinutes: 'Mar 28 • 85\' Played',
          rating: 8.6,
          goals: 1,
          assists: 2,
          isMvp: true,
        ),
      ],
    );
  }
}
