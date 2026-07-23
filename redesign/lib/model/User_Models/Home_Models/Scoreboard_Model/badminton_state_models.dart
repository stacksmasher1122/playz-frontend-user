/* ═══════════════════ ENUMS ═══════════════════ */

enum MatchStatus {
  notStarted,
  inProgress,
  completed,
  abandoned,
  timeout, // A11 Fix: Added timeout status
}

enum PlayerSide {
  sideA,
  sideB,
}

enum ServiceCourt {
  left,
  right,
}

/* ═══════════════════ DATA MODELS ═══════════════════ */

class BadmintonMatchConfig {
  final int pointsToWin; // usually 21
  final int maxPointCap; // usually 30
  final bool winByTwo;
  final int gamesToWin; // usually 2 (for best of 3)
  final bool isFriendlyRules; // if true, thresholds might be more relaxed or win-by-two disabled
  final bool intervalsEnabled; // interval at 11 points
  final bool endsChangeEnabled; // change ends at interval in deciding game

  const BadmintonMatchConfig({
    this.pointsToWin = 21,
    this.maxPointCap = 30,
    this.winByTwo = true,
    this.gamesToWin = 2, // Best of 3
    this.isFriendlyRules = false,
    this.intervalsEnabled = true,
    this.endsChangeEnabled = true,
  });

  Map<String, dynamic> toJson() => {
        'pointsToWin': pointsToWin,
        'maxPointCap': maxPointCap,
        'winByTwo': winByTwo,
        'gamesToWin': gamesToWin,
        'isFriendlyRules': isFriendlyRules,
        'intervalsEnabled': intervalsEnabled,
        'endsChangeEnabled': endsChangeEnabled,
      };

  BadmintonMatchConfig copyWith({
    int? pointsToWin,
    int? maxPointCap,
    bool? winByTwo,
    int? gamesToWin,
    bool? isFriendlyRules,
    bool? intervalsEnabled,
    bool? endsChangeEnabled,
  }) {
    return BadmintonMatchConfig(
      pointsToWin: pointsToWin ?? this.pointsToWin,
      maxPointCap: maxPointCap ?? this.maxPointCap,
      winByTwo: winByTwo ?? this.winByTwo,
      gamesToWin: gamesToWin ?? this.gamesToWin,
      isFriendlyRules: isFriendlyRules ?? this.isFriendlyRules,
      intervalsEnabled: intervalsEnabled ?? this.intervalsEnabled,
      endsChangeEnabled: endsChangeEnabled ?? this.endsChangeEnabled,
    );
  }

  factory BadmintonMatchConfig.fromJson(Map<String, dynamic> json) => BadmintonMatchConfig(
        pointsToWin: json['pointsToWin'] ?? 21,
        maxPointCap: json['maxPointCap'] ?? 30,
        winByTwo: json['winByTwo'] ?? true,
        gamesToWin: json['gamesToWin'] ?? 2,
        isFriendlyRules: json['isFriendlyRules'] ?? false,
        intervalsEnabled: json['intervalsEnabled'] ?? true,
        endsChangeEnabled: json['endsChangeEnabled'] ?? true,
      );
}

// Player model
class BadmintonPlayer {
  final String name;

  const BadmintonPlayer({
    required this.name,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
      };

  BadmintonPlayer copyWith({
    String? name,
  }) {
    return BadmintonPlayer(
      name: name ?? this.name,
    );
  }

  factory BadmintonPlayer.fromJson(Map<String, dynamic> json) => BadmintonPlayer(
        name: json['name'] ?? '',
      );
}

// Represents one game in the match
class BadmintonGame {
  final int scoreA;
  final int scoreB;
  final bool isCompleted;
  final PlayerSide? winner;

  const BadmintonGame({
    this.scoreA = 0,
    this.scoreB = 0,
    this.isCompleted = false,
    this.winner,
  });

  Map<String, dynamic> toJson() => {
        'scoreA': scoreA,
        'scoreB': scoreB,
        'isCompleted': isCompleted,
        'winner': winner?.index,
      };

  BadmintonGame copyWith({
    int? scoreA,
    int? scoreB,
    bool? isCompleted,
    PlayerSide? winner,
  }) {
    return BadmintonGame(
      scoreA: scoreA ?? this.scoreA,
      scoreB: scoreB ?? this.scoreB,
      isCompleted: isCompleted ?? this.isCompleted,
      winner: winner ?? this.winner,
    );
  }

  factory BadmintonGame.fromJson(Map<String, dynamic> json) => BadmintonGame(
        scoreA: json['scoreA'] ?? 0,
        scoreB: json['scoreB'] ?? 0,
        isCompleted: json['isCompleted'] ?? false,
        winner: json['winner'] != null ? PlayerSide.values[json['winner']] : null,
      );
}

// Top level immutable match state
class BadmintonMatchState {
  final BadmintonMatchConfig config;

  // Players
  final List<BadmintonPlayer> teamA;
  final List<BadmintonPlayer> teamB;

  // Game scores (historical + current)
  final List<BadmintonGame> games;
  final int currentGameIndex;

  // Current game state
  final int currentScoreA;
  final int currentScoreB;

  // Serving context
  final PlayerSide servingSide;
  final int serverIndexA; // which player is serving if A serves (0 or 1 for doubles)
  final int serverIndexB;
  final ServiceCourt serviceCourt;

  // Interval/Ends state
  final bool hasIntervalOccurred;
  final bool hasEndsChangedDecider;

  // Match overall status
  final MatchStatus status;
  final PlayerSide? matchWinner;

  const BadmintonMatchState({
    required this.config,
    required this.teamA,
    required this.teamB,
    this.games = const [],
    this.currentGameIndex = 0,
    this.currentScoreA = 0,
    this.currentScoreB = 0,
    this.servingSide = PlayerSide.sideA,
    this.serverIndexA = 0,
    this.serverIndexB = 0,
    this.serviceCourt = ServiceCourt.right,
    this.hasIntervalOccurred = false,
    this.hasEndsChangedDecider = false,
    this.status = MatchStatus.notStarted,
    this.matchWinner,
  });

  Map<String, dynamic> toJson() => {
        'config': config.toJson(),
        'teamA': teamA.map((p) => p.toJson()).toList(),
        'teamB': teamB.map((p) => p.toJson()).toList(),
        'games': games.map((g) => g.toJson()).toList(),
        'currentGameIndex': currentGameIndex,
        'currentScoreA': currentScoreA,
        'currentScoreB': currentScoreB,
        'servingSide': servingSide.index,
        'serverIndexA': serverIndexA,
        'serverIndexB': serverIndexB,
        'serviceCourt': serviceCourt.index,
        'hasIntervalOccurred': hasIntervalOccurred,
        'hasEndsChangedDecider': hasEndsChangedDecider,
        'status': status.index,
        'matchWinner': matchWinner?.index,
      };

  factory BadmintonMatchState.fromJson(Map<String, dynamic> json) {
    return BadmintonMatchState(
      config: BadmintonMatchConfig.fromJson(json['config'] ?? {}),
      teamA: (json['teamA'] as List?)?.map((p) => BadmintonPlayer.fromJson(p)).toList() ?? [],
      teamB: (json['teamB'] as List?)?.map((p) => BadmintonPlayer.fromJson(p)).toList() ?? [],
      games: (json['games'] as List?)?.map((g) => BadmintonGame.fromJson(g)).toList() ?? [],
      currentGameIndex: json['currentGameIndex'] ?? 0,
      currentScoreA: json['currentScoreA'] ?? 0,
      currentScoreB: json['currentScoreB'] ?? 0,
      servingSide: PlayerSide.values[json['servingSide'] ?? 0],
      serverIndexA: json['serverIndexA'] ?? 0,
      serverIndexB: json['serverIndexB'] ?? 0,
      serviceCourt: ServiceCourt.values[json['serviceCourt'] ?? 1],
      hasIntervalOccurred: json['hasIntervalOccurred'] ?? false,
      hasEndsChangedDecider: json['hasEndsChangedDecider'] ?? false,
      status: MatchStatus.values[json['status'] ?? 0],
      matchWinner: json['matchWinner'] != null ? PlayerSide.values[json['matchWinner']] : null,
    );
  }

  BadmintonMatchState copyWith({
    BadmintonMatchConfig? config,
    List<BadmintonPlayer>? teamA,
    List<BadmintonPlayer>? teamB,
    List<BadmintonGame>? games,
    int? currentGameIndex,
    int? currentScoreA,
    int? currentScoreB,
    PlayerSide? servingSide,
    int? serverIndexA,
    int? serverIndexB,
    ServiceCourt? serviceCourt,
    bool? hasIntervalOccurred,
    bool? hasEndsChangedDecider,
    MatchStatus? status,
    PlayerSide? matchWinner,
  }) {
    return BadmintonMatchState(
      config: config ?? this.config,
      teamA: teamA ?? this.teamA,
      teamB: teamB ?? this.teamB,
      games: games ?? this.games,
      currentGameIndex: currentGameIndex ?? this.currentGameIndex,
      currentScoreA: currentScoreA ?? this.currentScoreA,
      currentScoreB: currentScoreB ?? this.currentScoreB,
      servingSide: servingSide ?? this.servingSide,
      serverIndexA: serverIndexA ?? this.serverIndexA,
      serverIndexB: serverIndexB ?? this.serverIndexB,
      serviceCourt: serviceCourt ?? this.serviceCourt,
      hasIntervalOccurred: hasIntervalOccurred ?? this.hasIntervalOccurred,
      hasEndsChangedDecider: hasEndsChangedDecider ?? this.hasEndsChangedDecider,
      status: status ?? this.status,
      matchWinner: matchWinner ?? this.matchWinner,
    );
  }
}
