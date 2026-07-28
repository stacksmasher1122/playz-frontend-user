class BadmintonRecentMatchModel {
  final String opponent;
  final String formatTag;
  final String scoreText;
  final String matchDetails; // 'Kathrud Open - Semi Final | 42 min'
  final String xpGained;
  final bool isWin;

  const BadmintonRecentMatchModel({
    required this.opponent,
    required this.formatTag,
    required this.scoreText,
    required this.matchDetails,
    required this.xpGained,
    required this.isWin,
  });
}

class BadmintonStatsDetailModel {
  final String playerRole;
  final int totalMatches;
  final String tierName;

  // Record & Points
  final int winRatePct;
  final int wins;
  final int losses;
  final int seasonWinPct;
  final int bestStreak;
  final int pointsDiff;
  final int pointsScored;
  final int pointsConceded;
  final double avgDiffPerMatch;

  // Stats Grid
  final int smashWinners;
  final int smashSuccessPct;
  final int unforcedErrors;
  final int longestRally;
  final int rallyWinStreak;
  final int serveAces;
  final int serveFaults;

  // Playing Style & Format Split
  final String playStyle;
  final int attackPct;
  final int defensePct;
  final int netPlayPct;
  final int singlesPct;
  final int doublesPct;
  final int mixedPct;

  // Recent Matches
  final List<BadmintonRecentMatchModel> recentMatches;

  const BadmintonStatsDetailModel({
    required this.playerRole,
    required this.totalMatches,
    required this.tierName,
    required this.winRatePct,
    required this.wins,
    required this.losses,
    required this.seasonWinPct,
    required this.bestStreak,
    required this.pointsDiff,
    required this.pointsScored,
    required this.pointsConceded,
    required this.avgDiffPerMatch,
    required this.smashWinners,
    required this.smashSuccessPct,
    required this.unforcedErrors,
    required this.longestRally,
    required this.rallyWinStreak,
    required this.serveAces,
    required this.serveFaults,
    required this.playStyle,
    required this.attackPct,
    required this.defensePct,
    required this.netPlayPct,
    required this.singlesPct,
    required this.doublesPct,
    required this.mixedPct,
    required this.recentMatches,
  });

  static BadmintonStatsDetailModel getSampleData() {
    return const BadmintonStatsDetailModel(
      playerRole: 'Singles Specialist | Right Handed',
      totalMatches: 32,
      tierName: 'Platinum Tier',
      winRatePct: 75,
      wins: 24,
      losses: 8,
      seasonWinPct: 81,
      bestStreak: 12,
      pointsDiff: 240,
      pointsScored: 1420,
      pointsConceded: 1180,
      avgDiffPerMatch: 7.5,
      smashWinners: 85,
      smashSuccessPct: 68,
      unforcedErrors: 42,
      longestRally: 42,
      rallyWinStreak: 5,
      serveAces: 12,
      serveFaults: 3,
      playStyle: 'Aggressive',
      attackPct: 82,
      defensePct: 74,
      netPlayPct: 88,
      singlesPct: 58,
      doublesPct: 31,
      mixedPct: 11,
      recentMatches: [
        BadmintonRecentMatchModel(
          opponent: 'vs. Alex R.',
          formatTag: 'Straight Sets',
          scoreText: '21-18, 21-15',
          matchDetails: 'Kothrud Open - Semi Final | 42 min',
          xpGained: '+25 XP',
          isWin: true,
        ),
        BadmintonRecentMatchModel(
          opponent: 'vs. Jamie T.',
          formatTag: '3 Sets',
          scoreText: '19-21, 20-22',
          matchDetails: 'Club Ladder | 55 min',
          xpGained: '+10 XP',
          isWin: false,
        ),
        BadmintonRecentMatchModel(
          opponent: 'vs. Sam M.',
          formatTag: 'Straight Sets',
          scoreText: '21-12, 21-19',
          matchDetails: 'Practice Match | 35 min',
          xpGained: '+30 XP',
          isWin: true,
        ),
      ],
    );
  }
}
