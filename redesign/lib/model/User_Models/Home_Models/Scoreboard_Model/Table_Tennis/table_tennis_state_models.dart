import 'package:uuid/uuid.dart';

/* ═══════════════════ DATA MODELS & ENUMS ═══════════════════ */

class TableTennisPlayer {
  final String id; // Stable UID
  final String name;
  final String email;
  final String profilePic;
  final int pointsWon;
  final int aces;
  final int serviceFaults;
  final int unforcedErrors;
  final int edgeBalls;

  const TableTennisPlayer({
    required this.id,
    required this.name,
    this.email = '',
    this.profilePic = '',
    this.pointsWon = 0,
    this.aces = 0,
    this.serviceFaults = 0,
    this.unforcedErrors = 0,
    this.edgeBalls = 0,
  });

  TableTennisPlayer copyWith({
    String? id,
    String? name,
    String? email,
    String? profilePic,
    int? pointsWon,
    int? aces,
    int? serviceFaults,
    int? unforcedErrors,
    int? edgeBalls,
  }) {
    return TableTennisPlayer(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profilePic: profilePic ?? this.profilePic,
      pointsWon: pointsWon ?? this.pointsWon,
      aces: aces ?? this.aces,
      serviceFaults: serviceFaults ?? this.serviceFaults,
      unforcedErrors: unforcedErrors ?? this.unforcedErrors,
      edgeBalls: edgeBalls ?? this.edgeBalls,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'profilePic': profilePic,
        'pointsWon': pointsWon,
        'aces': aces,
        'serviceFaults': serviceFaults,
        'unforcedErrors': unforcedErrors,
        'edgeBalls': edgeBalls,
      };

  factory TableTennisPlayer.fromJson(Map<String, dynamic> json) => TableTennisPlayer(
        id: json['id'] ?? const Uuid().v4(),
        name: json['name'] ?? 'Player',
        email: json['email'] ?? '',
        profilePic: json['profilePic'] ?? '',
        pointsWon: json['pointsWon'] ?? 0,
        aces: json['aces'] ?? 0,
        serviceFaults: json['serviceFaults'] ?? 0,
        unforcedErrors: json['unforcedErrors'] ?? 0,
        edgeBalls: json['edgeBalls'] ?? 0,
      );
}

class GameScore {
  final int gameNumber;
  final int sideAPoints;
  final int sideBPoints;
  final bool isCompleted;
  final String? winnerSide;

  const GameScore({
    required this.gameNumber,
    this.sideAPoints = 0,
    this.sideBPoints = 0,
    this.isCompleted = false,
    this.winnerSide,
  });

  GameScore copyWith({
    int? gameNumber,
    int? sideAPoints,
    int? sideBPoints,
    bool? isCompleted,
    String? winnerSide,
  }) {
    return GameScore(
      gameNumber: gameNumber ?? this.gameNumber,
      sideAPoints: sideAPoints ?? this.sideAPoints,
      sideBPoints: sideBPoints ?? this.sideBPoints,
      isCompleted: isCompleted ?? this.isCompleted,
      winnerSide: winnerSide ?? this.winnerSide,
    );
  }

  Map<String, dynamic> toJson() => {
        'gameNumber': gameNumber,
        'sideAPoints': sideAPoints,
        'sideBPoints': sideBPoints,
        'isCompleted': isCompleted,
        'winnerSide': winnerSide,
      };

  factory GameScore.fromJson(Map<String, dynamic> json) => GameScore(
        gameNumber: json['gameNumber'] ?? 1,
        sideAPoints: json['sideAPoints'] ?? 0,
        sideBPoints: json['sideBPoints'] ?? 0,
        isCompleted: json['isCompleted'] ?? false,
        winnerSide: json['winnerSide'],
      );
}

class TableTennisMatchConfig {
  final String format; // 'SINGLES' or 'DOUBLES'
  final String gamesFormat; // 'BEST_OF_1', 'BEST_OF_3', 'BEST_OF_5', 'BEST_OF_7'
  final bool isFriendlyMode;
  final int pointsPerGame; // 11 (ITTF Pro default) or 7 / 21 (Friendly)
  final String homeTeamName;
  final String awayTeamName;

  const TableTennisMatchConfig({
    this.format = 'SINGLES',
    this.gamesFormat = 'BEST_OF_5',
    this.isFriendlyMode = false,
    this.pointsPerGame = 11,
    this.homeTeamName = 'Player A',
    this.awayTeamName = 'Player B',
  });

  int get gamesToWin {
    switch (gamesFormat) {
      case 'BEST_OF_1':
        return 1;
      case 'BEST_OF_3':
        return 2;
      case 'BEST_OF_7':
        return 4;
      case 'BEST_OF_5':
      default:
        return 3;
    }
  }

  TableTennisMatchConfig copyWith({
    String? format,
    String? gamesFormat,
    bool? isFriendlyMode,
    int? pointsPerGame,
    String? homeTeamName,
    String? awayTeamName,
  }) {
    return TableTennisMatchConfig(
      format: format ?? this.format,
      gamesFormat: gamesFormat ?? this.gamesFormat,
      isFriendlyMode: isFriendlyMode ?? this.isFriendlyMode,
      pointsPerGame: pointsPerGame ?? this.pointsPerGame,
      homeTeamName: homeTeamName ?? this.homeTeamName,
      awayTeamName: awayTeamName ?? this.awayTeamName,
    );
  }

  Map<String, dynamic> toJson() => {
        'format': format,
        'gamesFormat': gamesFormat,
        'isFriendlyMode': isFriendlyMode,
        'pointsPerGame': pointsPerGame,
        'homeTeamName': homeTeamName,
        'awayTeamName': awayTeamName,
      };

  factory TableTennisMatchConfig.fromJson(Map<String, dynamic> json) =>
      TableTennisMatchConfig(
        format: json['format'] ?? 'SINGLES',
        gamesFormat: json['gamesFormat'] ?? 'BEST_OF_5',
        isFriendlyMode: json['isFriendlyMode'] ?? false,
        pointsPerGame: json['pointsPerGame'] ?? 11,
        homeTeamName: json['homeTeamName'] ?? 'Player A',
        awayTeamName: json['awayTeamName'] ?? 'Player B',
      );
}

class TableTennisPointEvent {
  final String id;
  final String winnerSide; // 'A' or 'B'
  final String outcomeType; // 'normalPoint', 'ace', 'serviceFault', 'let', 'edgeBall', 'unforcedError'
  final String serverSide; // 'A' or 'B'
  final int serverPlayerIndex;
  final int receiverPlayerIndex;
  final int gameNumber;
  final String scoreBefore;
  final String scoreAfter;
  final DateTime timestamp;

  TableTennisPointEvent({
    required this.id,
    required this.winnerSide,
    this.outcomeType = 'normalPoint',
    required this.serverSide,
    this.serverPlayerIndex = 0,
    this.receiverPlayerIndex = 0,
    required this.gameNumber,
    required this.scoreBefore,
    required this.scoreAfter,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'winnerSide': winnerSide,
        'outcomeType': outcomeType,
        'serverSide': serverSide,
        'serverPlayerIndex': serverPlayerIndex,
        'receiverPlayerIndex': receiverPlayerIndex,
        'gameNumber': gameNumber,
        'scoreBefore': scoreBefore,
        'scoreAfter': scoreAfter,
        'timestamp': timestamp.toIso8601String(),
      };

  factory TableTennisPointEvent.fromJson(Map<String, dynamic> json) =>
      TableTennisPointEvent(
        id: json['id'] ?? const Uuid().v4(),
        winnerSide: json['winnerSide'] ?? 'A',
        outcomeType: json['outcomeType'] ?? 'normalPoint',
        serverSide: json['serverSide'] ?? 'A',
        serverPlayerIndex: json['serverPlayerIndex'] ?? 0,
        receiverPlayerIndex: json['receiverPlayerIndex'] ?? 0,
        gameNumber: json['gameNumber'] ?? 1,
        scoreBefore: json['scoreBefore'] ?? '0-0',
        scoreAfter: json['scoreAfter'] ?? '0-0',
        timestamp: json['timestamp'] != null
            ? DateTime.parse(json['timestamp'])
            : DateTime.now(),
      );
}

class TableTennisMatchState {
  final int sideAPoints;
  final int sideBPoints;
  final int currentGameIndex;
  final List<GameScore> gameScores;
  final int sideAGamesWon;
  final int sideBGamesWon;
  final String servingSide; // 'A' or 'B'
  final int servingPlayerIndex; // 0 or 1 for doubles
  final int receivingPlayerIndex; // 0 or 1 for doubles
  final int serveCount; // 0 or 1 points served in current turn (switch at 2)
  final bool isDeuce;
  final bool isEndsSwitched;
  final bool hasSwitchedEndsInDecidingGame;
  final String gameInitialServer; // Initial server side ('A' or 'B') for current game
  final bool isExpediteActive;
  final int sideATimeoutsLeft;
  final int sideBTimeoutsLeft;
  final String matchStatus; // 'INITIALIZING', 'LIVE', 'COMPLETED', 'RETIRED'
  final String matchResult;
  final TableTennisMatchConfig matchConfig;
  final List<TableTennisPlayer> sideAPlayers;
  final List<TableTennisPlayer> sideBPlayers;
  final List<TableTennisPointEvent> history;
  final String tossWinner;
  final String tossDecision;

  const TableTennisMatchState({
    this.sideAPoints = 0,
    this.sideBPoints = 0,
    this.currentGameIndex = 0,
    this.gameScores = const [],
    this.sideAGamesWon = 0,
    this.sideBGamesWon = 0,
    this.servingSide = 'A',
    this.servingPlayerIndex = 0,
    this.receivingPlayerIndex = 0,
    this.serveCount = 0,
    this.isDeuce = false,
    this.isEndsSwitched = false,
    this.hasSwitchedEndsInDecidingGame = false,
    this.gameInitialServer = 'A',
    this.isExpediteActive = false,
    this.sideATimeoutsLeft = 1,
    this.sideBTimeoutsLeft = 1,
    this.matchStatus = 'INITIALIZING',
    this.matchResult = '',
    this.matchConfig = const TableTennisMatchConfig(),
    this.sideAPlayers = const [],
    this.sideBPlayers = const [],
    this.history = const [],
    this.tossWinner = '',
    this.tossDecision = '',
  });

  TableTennisMatchState copyWith({
    int? sideAPoints,
    int? sideBPoints,
    int? currentGameIndex,
    List<GameScore>? gameScores,
    int? sideAGamesWon,
    int? sideBGamesWon,
    String? servingSide,
    int? servingPlayerIndex,
    int? receivingPlayerIndex,
    int? serveCount,
    bool? isDeuce,
    bool? isEndsSwitched,
    bool? hasSwitchedEndsInDecidingGame,
    String? gameInitialServer,
    bool? isExpediteActive,
    int? sideATimeoutsLeft,
    int? sideBTimeoutsLeft,
    String? matchStatus,
    String? matchResult,
    TableTennisMatchConfig? matchConfig,
    List<TableTennisPlayer>? sideAPlayers,
    List<TableTennisPlayer>? sideBPlayers,
    List<TableTennisPointEvent>? history,
    String? tossWinner,
    String? tossDecision,
  }) {
    return TableTennisMatchState(
      sideAPoints: sideAPoints ?? this.sideAPoints,
      sideBPoints: sideBPoints ?? this.sideBPoints,
      currentGameIndex: currentGameIndex ?? this.currentGameIndex,
      gameScores: gameScores ?? this.gameScores,
      sideAGamesWon: sideAGamesWon ?? this.sideAGamesWon,
      sideBGamesWon: sideBGamesWon ?? this.sideBGamesWon,
      servingSide: servingSide ?? this.servingSide,
      servingPlayerIndex: servingPlayerIndex ?? this.servingPlayerIndex,
      receivingPlayerIndex: receivingPlayerIndex ?? this.receivingPlayerIndex,
      serveCount: serveCount ?? this.serveCount,
      isDeuce: isDeuce ?? this.isDeuce,
      isEndsSwitched: isEndsSwitched ?? this.isEndsSwitched,
      hasSwitchedEndsInDecidingGame:
          hasSwitchedEndsInDecidingGame ?? this.hasSwitchedEndsInDecidingGame,
      gameInitialServer: gameInitialServer ?? this.gameInitialServer,
      isExpediteActive: isExpediteActive ?? this.isExpediteActive,
      sideATimeoutsLeft: sideATimeoutsLeft ?? this.sideATimeoutsLeft,
      sideBTimeoutsLeft: sideBTimeoutsLeft ?? this.sideBTimeoutsLeft,
      matchStatus: matchStatus ?? this.matchStatus,
      matchResult: matchResult ?? this.matchResult,
      matchConfig: matchConfig ?? this.matchConfig,
      sideAPlayers: sideAPlayers ?? this.sideAPlayers,
      sideBPlayers: sideBPlayers ?? this.sideBPlayers,
      history: history ?? this.history,
      tossWinner: tossWinner ?? this.tossWinner,
      tossDecision: tossDecision ?? this.tossDecision,
    );
  }

  Map<String, dynamic> toJson() => {
        'sideAPoints': sideAPoints,
        'sideBPoints': sideBPoints,
        'currentGameIndex': currentGameIndex,
        'gameScores': gameScores.map((g) => g.toJson()).toList(),
        'sideAGamesWon': sideAGamesWon,
        'sideBGamesWon': sideBGamesWon,
        'servingSide': servingSide,
        'servingPlayerIndex': servingPlayerIndex,
        'receivingPlayerIndex': receivingPlayerIndex,
        'serveCount': serveCount,
        'isDeuce': isDeuce,
        'isEndsSwitched': isEndsSwitched,
        'hasSwitchedEndsInDecidingGame': hasSwitchedEndsInDecidingGame,
        'gameInitialServer': gameInitialServer,
        'isExpediteActive': isExpediteActive,
        'sideATimeoutsLeft': sideATimeoutsLeft,
        'sideBTimeoutsLeft': sideBTimeoutsLeft,
        'matchStatus': matchStatus,
        'matchResult': matchResult,
        'matchConfig': matchConfig.toJson(),
        'sideAPlayers': sideAPlayers.map((p) => p.toJson()).toList(),
        'sideBPlayers': sideBPlayers.map((p) => p.toJson()).toList(),
        'history': history.map((e) => e.toJson()).toList(),
        'tossWinner': tossWinner,
        'tossDecision': tossDecision,
      };

  factory TableTennisMatchState.fromJson(Map<String, dynamic> json) =>
      TableTennisMatchState(
        sideAPoints: json['sideAPoints'] ?? 0,
        sideBPoints: json['sideBPoints'] ?? 0,
        currentGameIndex: json['currentGameIndex'] ?? 0,
        gameScores: (json['gameScores'] as List? ?? [])
            .map((g) => GameScore.fromJson(Map<String, dynamic>.from(g)))
            .toList(),
        sideAGamesWon: json['sideAGamesWon'] ?? 0,
        sideBGamesWon: json['sideBGamesWon'] ?? 0,
        servingSide: json['servingSide'] ?? 'A',
        servingPlayerIndex: json['servingPlayerIndex'] ?? 0,
        receivingPlayerIndex: json['receivingPlayerIndex'] ?? 0,
        serveCount: json['serveCount'] ?? 0,
        isDeuce: json['isDeuce'] ?? false,
        isEndsSwitched: json['isEndsSwitched'] ?? false,
        hasSwitchedEndsInDecidingGame:
            json['hasSwitchedEndsInDecidingGame'] ?? false,
        gameInitialServer: json['gameInitialServer'] ?? 'A',
        isExpediteActive: json['isExpediteActive'] ?? false,
        sideATimeoutsLeft: json['sideATimeoutsLeft'] ?? 1,
        sideBTimeoutsLeft: json['sideBTimeoutsLeft'] ?? 1,
        matchStatus: json['matchStatus'] ?? 'INITIALIZING',
        matchResult: json['matchResult'] ?? '',
        matchConfig: TableTennisMatchConfig.fromJson(
            Map<String, dynamic>.from(json['matchConfig'] ?? {})),
        sideAPlayers: (json['sideAPlayers'] as List? ?? [])
            .map((p) => TableTennisPlayer.fromJson(Map<String, dynamic>.from(p)))
            .toList(),
        sideBPlayers: (json['sideBPlayers'] as List? ?? [])
            .map((p) => TableTennisPlayer.fromJson(Map<String, dynamic>.from(p)))
            .toList(),
        history: (json['history'] as List? ?? [])
            .map((e) => TableTennisPointEvent.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
        tossWinner: json['tossWinner'] ?? '',
        tossDecision: json['tossDecision'] ?? '',
      );
}
