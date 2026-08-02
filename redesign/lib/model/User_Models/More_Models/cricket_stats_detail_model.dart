class CricketRecentMatchModel {
  final String opponent;
  final String runsAndBalls;
  final String bowlingFigures;
  final String formatAndDate;
  final String resultTag; // 'WIN', 'LOSS', 'DRAW'
  final bool isMvp;
  final bool isCaptain;

  const CricketRecentMatchModel({
    required this.opponent,
    required this.runsAndBalls,
    required this.bowlingFigures,
    required this.formatAndDate,
    required this.resultTag,
    this.isMvp = false,
    this.isCaptain = false,
  });
}

class CricketStatsDetailModel {
  final String playerRole;
  final int totalMatches;
  final String tierName;

  // Batting
  final int runs;
  final double avg;
  final double strikeRate;
  final int ballsFaced;
  final double boundaryPct;
  final double avgRunsPerMatch;
  final String highestScore;
  final int innings;
  final int notOuts;
  final int ducks;

  // Milestones
  final int hundreds;
  final int seventyFivesPlus;
  final int fifties;
  final int thirtiesPlus;
  final int fours;
  final int sixes;

  // Format Split
  final int t20MatchesPct;

  // Bowling
  final int wickets;
  final String bestBowling;
  final double economy;
  final double bowlingAvg;
  final double bowlingStrikeRate;
  final int overs;
  final int maidens;
  final double dotPct;
  final int runsGiven;

  // Fielding & Overall Rating
  final int catches;
  final int runOuts;
  final int playerOfMatchCount;
  final double winPercentage;
  final double rating;

  // Recent Matches
  final List<CricketRecentMatchModel> recentMatches;

  const CricketStatsDetailModel({
    required this.playerRole,
    required this.totalMatches,
    required this.tierName,
    required this.runs,
    required this.avg,
    required this.strikeRate,
    required this.ballsFaced,
    required this.boundaryPct,
    required this.avgRunsPerMatch,
    required this.highestScore,
    required this.innings,
    required this.notOuts,
    required this.ducks,
    required this.hundreds,
    required this.seventyFivesPlus,
    required this.fifties,
    required this.thirtiesPlus,
    required this.fours,
    required this.sixes,
    required this.t20MatchesPct,
    required this.wickets,
    required this.bestBowling,
    required this.economy,
    required this.bowlingAvg,
    required this.bowlingStrikeRate,
    required this.overs,
    required this.maidens,
    required this.dotPct,
    required this.runsGiven,
    required this.catches,
    required this.runOuts,
    required this.playerOfMatchCount,
    required this.winPercentage,
    required this.rating,
    required this.recentMatches,
  });

  static CricketStatsDetailModel getSampleData() {
    return const CricketStatsDetailModel(
      playerRole: 'All-Rounder • RHB • Right-Arm Medium',
      totalMatches: 24,
      tierName: 'SILVER TIER',
      runs: 1240,
      avg: 42.50,
      strikeRate: 138.2,
      ballsFaced: 897,
      boundaryPct: 63.0,
      avgRunsPerMatch: 51.6,
      highestScore: '87*',
      innings: 22,
      notOuts: 4,
      ducks: 1,
      hundreds: 1,
      seventyFivesPlus: 2,
      fifties: 4,
      thirtiesPlus: 8,
      fours: 112,
      sixes: 45,
      t20MatchesPct: 79,
      wickets: 12,
      bestBowling: '3/18',
      economy: 6.8,
      bowlingAvg: 24.5,
      bowlingStrikeRate: 18.2,
      overs: 34,
      maidens: 2,
      dotPct: 42.0,
      runsGiven: 1128,
      catches: 14,
      runOuts: 3,
      playerOfMatchCount: 6,
      winPercentage: 74.0,
      rating: 8.7,
      recentMatches: [
        CricketRecentMatchModel(
          opponent: 'vs Spartans CC',
          runsAndBalls: '64(42)',
          bowlingFigures: '2/21',
          formatAndDate: 'T20 • Oct 14',
          resultTag: 'WIN',
          isCaptain: true,
        ),
        CricketRecentMatchModel(
          opponent: 'vs Royal Blues',
          runsAndBalls: '22(18)',
          bowlingFigures: '0/45',
          formatAndDate: 'ODI • Oct 03',
          resultTag: 'LOSS',
        ),
        CricketRecentMatchModel(
          opponent: 'vs Kings XI',
          runsAndBalls: '87*(55)',
          bowlingFigures: '3/18',
          formatAndDate: 'T20 • Sep 28',
          resultTag: 'WIN',
          isMvp: true,
        ),
      ],
    );
  }

  // C5: Factory to build model from real Firestore 'cricketStats' data
  // stored in the User document.
  factory CricketStatsDetailModel.fromFirestore(Map<String, dynamic> stats) {
    final int totalRuns = (stats['totalRuns'] ?? 0) as int;
    final int totalBallsFaced = (stats['totalBallsFaced'] ?? 0) as int;
    final int totalMatches = (stats['totalMatches'] ?? 0) as int;
    final int totalWickets = (stats['totalWickets'] ?? 0) as int;
    final int totalBallsBowled = (stats['totalBallsBowled'] ?? 0) as int;
    final int totalRunsConceded = (stats['totalRunsConceded'] ?? 0) as int;
    final int totalFours = (stats['totalFours'] ?? 0) as int;
    final int totalSixes = (stats['totalSixes'] ?? 0) as int;
    final int totalMaidens = (stats['totalMaidens'] ?? 0) as int;

    final double sr = totalBallsFaced > 0 ? (totalRuns / totalBallsFaced) * 100 : 0.0;
    final double avg = totalMatches > 0 ? totalRuns / totalMatches : 0.0;
    final double avgPerMatch = totalMatches > 0 ? totalRuns / totalMatches : 0.0;
    final double boundaryPct = totalRuns > 0
        ? ((totalFours * 4 + totalSixes * 6) / totalRuns * 100)
        : 0.0;
    final int totalOvers = totalBallsBowled ~/ 6;
    final double econ = totalOvers > 0 ? totalRunsConceded / totalOvers : 0.0;
    final double bowlAvg = totalWickets > 0 ? totalRunsConceded / totalWickets : 0.0;
    final double bowlSR = totalWickets > 0 ? totalBallsBowled / totalWickets : 0.0;

    return CricketStatsDetailModel(
      playerRole: stats['playerRole'] ?? 'All-Rounder',
      totalMatches: totalMatches,
      tierName: stats['tierName'] ?? 'UNRANKED',
      runs: totalRuns,
      avg: avg,
      strikeRate: sr,
      ballsFaced: totalBallsFaced,
      boundaryPct: boundaryPct,
      avgRunsPerMatch: avgPerMatch,
      highestScore: (stats['highestScore'] ?? '0').toString(),
      innings: stats['innings'] ?? totalMatches,
      notOuts: stats['notOuts'] ?? 0,
      ducks: stats['ducks'] ?? 0,
      hundreds: stats['hundreds'] ?? 0,
      seventyFivesPlus: stats['seventyFivesPlus'] ?? 0,
      fifties: stats['fifties'] ?? 0,
      thirtiesPlus: stats['thirtiesPlus'] ?? 0,
      fours: totalFours,
      sixes: totalSixes,
      t20MatchesPct: stats['t20MatchesPct'] ?? 100,
      wickets: totalWickets,
      bestBowling: (stats['bestBowling'] ?? '0/0').toString(),
      economy: econ,
      bowlingAvg: bowlAvg,
      bowlingStrikeRate: bowlSR,
      overs: totalOvers,
      maidens: totalMaidens,
      dotPct: stats['dotPct']?.toDouble() ?? 0.0,
      runsGiven: totalRunsConceded,
      catches: stats['catches'] ?? 0,
      runOuts: stats['runOuts'] ?? 0,
      playerOfMatchCount: stats['playerOfMatchCount'] ?? 0,
      winPercentage: (stats['winPercentage'] ?? 0.0).toDouble(),
      rating: (stats['rating'] ?? 0.0).toDouble(),
      recentMatches: const [], // Recent matches loaded separately from match history
    );
  }
}
