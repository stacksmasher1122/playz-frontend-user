class LiveMatchStatsModel {
  final String duration;
  final String courtName;
  
  // Player A (e.g. Reyes)
  final String playerAName;
  final String playerARank;
  final String playerACountry;
  final int playerASets;
  final String playerAGames; // string because it could be 'Ad' etc, but usually int
  final String playerAPoints; // '0', '15', '30', '40', 'Ad'
  
  // Player B (e.g. Jenkins)
  final String playerBName;
  final String playerBRank;
  final String playerBCountry;
  final int playerBSets;
  final String playerBGames;
  final String playerBPoints;
  
  // Stats
  final int playerAFirstServePercent;
  final int playerBFirstServePercent;
  final int playerAAces;
  final int playerBAces;
  final int playerANetPointsWon;
  final int playerANetPointsTotal;
  final int playerBNetPointsWon;
  final int playerBNetPointsTotal;
  
  final bool isPlayerAServing;

  const LiveMatchStatsModel({
    this.duration = '1h 24m',
    this.courtName = 'COURT 1',
    this.playerAName = 'ALEXANDRA REYES',
    this.playerARank = '#4',
    this.playerACountry = 'SPAIN',
    this.playerASets = 1,
    this.playerAGames = '6',
    this.playerAPoints = '40',
    this.playerBName = 'SARAH JENKINS',
    this.playerBRank = '#12',
    this.playerBCountry = 'USA',
    this.playerBSets = 1,
    this.playerBGames = '4',
    this.playerBPoints = '30',
    this.playerAFirstServePercent = 68,
    this.playerBFirstServePercent = 54,
    this.playerAAces = 12,
    this.playerBAces = 4,
    this.playerANetPointsWon = 8,
    this.playerANetPointsTotal = 10,
    this.playerBNetPointsWon = 5,
    this.playerBNetPointsTotal = 12,
    this.isPlayerAServing = true,
  });

  LiveMatchStatsModel copyWith({
    String? playerAPoints,
    String? playerBPoints,
    bool? isPlayerAServing,
  }) {
    return LiveMatchStatsModel(
      duration: duration,
      courtName: courtName,
      playerAName: playerAName,
      playerARank: playerARank,
      playerACountry: playerACountry,
      playerASets: playerASets,
      playerAGames: playerAGames,
      playerAPoints: playerAPoints ?? this.playerAPoints,
      playerBName: playerBName,
      playerBRank: playerBRank,
      playerBCountry: playerBCountry,
      playerBSets: playerBSets,
      playerBGames: playerBGames,
      playerBPoints: playerBPoints ?? this.playerBPoints,
      playerAFirstServePercent: playerAFirstServePercent,
      playerBFirstServePercent: playerBFirstServePercent,
      playerAAces: playerAAces,
      playerBAces: playerBAces,
      playerANetPointsWon: playerANetPointsWon,
      playerANetPointsTotal: playerANetPointsTotal,
      playerBNetPointsWon: playerBNetPointsWon,
      playerBNetPointsTotal: playerBNetPointsTotal,
      isPlayerAServing: isPlayerAServing ?? this.isPlayerAServing,
    );
  }
}
