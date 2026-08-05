import 'package:flutter/foundation.dart';

enum SquashScoringSystem { pars, hiho }

enum ServeBox { left, right }

enum PlayerSide { sideA, sideB }

class SquashPlayer {
  final String name;
  final String email;
  final String profileImageUrl;

  const SquashPlayer({
    required this.name,
    this.email = '',
    this.profileImageUrl = '',
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'profileImageUrl': profileImageUrl,
      };

  factory SquashPlayer.fromJson(Map<String, dynamic> json) => SquashPlayer(
        name: json['name'] as String? ?? '',
        email: json['email'] as String? ?? '',
        profileImageUrl: json['profileImageUrl'] as String? ?? '',
      );
}

class SquashGameResult {
  final int gameNumber;
  final int sideAScore;
  final int sideBScore;
  final PlayerSide winner;

  const SquashGameResult({
    required this.gameNumber,
    required this.sideAScore,
    required this.sideBScore,
    required this.winner,
  });

  Map<String, dynamic> toJson() => {
        'gameNumber': gameNumber,
        'sideAScore': sideAScore,
        'sideBScore': sideBScore,
        'winner': winner.name,
      };

  factory SquashGameResult.fromJson(Map<String, dynamic> json) =>
      SquashGameResult(
        gameNumber: json['gameNumber'] as int,
        sideAScore: json['sideAScore'] as int,
        sideBScore: json['sideBScore'] as int,
        winner: PlayerSide.values.firstWhere(
          (e) => e.name == json['winner'],
          orElse: () => PlayerSide.sideA,
        ),
      );
}

class SquashMatchConfig {
  final SquashScoringSystem scoringSystem;
  final int pointsToWin;
  final int gamesToWin;
  final bool winByTwo;
  final bool isFriendlyRules;
  final bool isDoubles;

  const SquashMatchConfig({
    this.scoringSystem = SquashScoringSystem.pars,
    this.pointsToWin = 11,
    this.gamesToWin = 2,
    this.winByTwo = true,
    this.isFriendlyRules = false,
    this.isDoubles = false,
  });

  Map<String, dynamic> toJson() => {
        'scoringSystem': scoringSystem.name,
        'pointsToWin': pointsToWin,
        'gamesToWin': gamesToWin,
        'winByTwo': winByTwo,
        'isFriendlyRules': isFriendlyRules,
        'isDoubles': isDoubles,
      };

  factory SquashMatchConfig.fromJson(Map<String, dynamic> json) =>
      SquashMatchConfig(
        scoringSystem: SquashScoringSystem.values.firstWhere(
          (e) => e.name == json['scoringSystem'],
          orElse: () => SquashScoringSystem.pars,
        ),
        pointsToWin: json['pointsToWin'] as int? ?? 11,
        gamesToWin: json['gamesToWin'] as int? ?? 2,
        winByTwo: json['winByTwo'] as bool? ?? true,
        isFriendlyRules: json['isFriendlyRules'] as bool? ?? false,
        isDoubles: json['isDoubles'] as bool? ?? false,
      );
}

@immutable
class SquashMatchState {
  final SquashMatchConfig config;
  final List<SquashPlayer> teamA;
  final List<SquashPlayer> teamB;
  final int sideAPointScore;
  final int sideBPointScore;
  final int sideAGamesWon;
  final int sideBGamesWon;
  final int currentGameIndex;
  final PlayerSide currentServer;
  final int serverPlayerIndex; // 0 or 1 for Doubles
  final ServeBox currentServeBox;
  final bool mustSelectServeBox;
  final List<SquashGameResult> gameHistory;
  final List<String> conductLog; // Log of WSF Rule 15 warnings/strokes/games
  final bool isGameFinished;
  final bool isMatchFinished;
  final PlayerSide? matchWinner;
  final bool isDeuceChoicePending; // Used in HIHO at 8-8
  final int hihoTargetPoints; // 9 or 10 when chosen at 8-8 in HIHO

  const SquashMatchState({
    required this.config,
    required this.teamA,
    required this.teamB,
    this.sideAPointScore = 0,
    this.sideBPointScore = 0,
    this.sideAGamesWon = 0,
    this.sideBGamesWon = 0,
    this.currentGameIndex = 1,
    this.currentServer = PlayerSide.sideA,
    this.serverPlayerIndex = 0,
    this.currentServeBox = ServeBox.right,
    this.mustSelectServeBox = true, // WSF Rule 4.2: Server chooses box at start of every game
    this.gameHistory = const [],
    this.conductLog = const [],
    this.isGameFinished = false,
    this.isMatchFinished = false,
    this.matchWinner,
    this.isDeuceChoicePending = false,
    this.hihoTargetPoints = 9,
  });

  SquashMatchState copyWith({
    SquashMatchConfig? config,
    List<SquashPlayer>? teamA,
    List<SquashPlayer>? teamB,
    int? sideAPointScore,
    int? sideBPointScore,
    int? sideAGamesWon,
    int? sideBGamesWon,
    int? currentGameIndex,
    PlayerSide? currentServer,
    int? serverPlayerIndex,
    ServeBox? currentServeBox,
    bool? mustSelectServeBox,
    List<SquashGameResult>? gameHistory,
    List<String>? conductLog,
    bool? isGameFinished,
    bool? isMatchFinished,
    PlayerSide? matchWinner,
    bool? isDeuceChoicePending,
    int? hihoTargetPoints,
  }) {
    return SquashMatchState(
      config: config ?? this.config,
      teamA: teamA ?? this.teamA,
      teamB: teamB ?? this.teamB,
      sideAPointScore: sideAPointScore ?? this.sideAPointScore,
      sideBPointScore: sideBPointScore ?? this.sideBPointScore,
      sideAGamesWon: sideAGamesWon ?? this.sideAGamesWon,
      sideBGamesWon: sideBGamesWon ?? this.sideBGamesWon,
      currentGameIndex: currentGameIndex ?? this.currentGameIndex,
      currentServer: currentServer ?? this.currentServer,
      serverPlayerIndex: serverPlayerIndex ?? this.serverPlayerIndex,
      currentServeBox: currentServeBox ?? this.currentServeBox,
      mustSelectServeBox: mustSelectServeBox ?? this.mustSelectServeBox,
      gameHistory: gameHistory ?? this.gameHistory,
      conductLog: conductLog ?? this.conductLog,
      isGameFinished: isGameFinished ?? this.isGameFinished,
      isMatchFinished: isMatchFinished ?? this.isMatchFinished,
      matchWinner: matchWinner ?? this.matchWinner,
      isDeuceChoicePending: isDeuceChoicePending ?? this.isDeuceChoicePending,
      hihoTargetPoints: hihoTargetPoints ?? this.hihoTargetPoints,
    );
  }

  Map<String, dynamic> toJson() => {
        'config': config.toJson(),
        'teamA': teamA.map((p) => p.toJson()).toList(),
        'teamB': teamB.map((p) => p.toJson()).toList(),
        'sideAPointScore': sideAPointScore,
        'sideBPointScore': sideBPointScore,
        'sideAGamesWon': sideAGamesWon,
        'sideBGamesWon': sideBGamesWon,
        'currentGameIndex': currentGameIndex,
        'currentServer': currentServer.name,
        'serverPlayerIndex': serverPlayerIndex,
        'currentServeBox': currentServeBox.name,
        'mustSelectServeBox': mustSelectServeBox,
        'gameHistory': gameHistory.map((g) => g.toJson()).toList(),
        'conductLog': conductLog,
        'isGameFinished': isGameFinished,
        'isMatchFinished': isMatchFinished,
        'matchWinner': matchWinner?.name,
        'isDeuceChoicePending': isDeuceChoicePending,
        'hihoTargetPoints': hihoTargetPoints,
      };

  factory SquashMatchState.fromJson(Map<String, dynamic> json) =>
      SquashMatchState(
        config: SquashMatchConfig.fromJson(
            json['config'] as Map<String, dynamic>? ?? {}),
        teamA: (json['teamA'] as List? ?? [])
            .map((p) => SquashPlayer.fromJson(p as Map<String, dynamic>))
            .toList(),
        teamB: (json['teamB'] as List? ?? [])
            .map((p) => SquashPlayer.fromJson(p as Map<String, dynamic>))
            .toList(),
        sideAPointScore: json['sideAPointScore'] as int? ?? 0,
        sideBPointScore: json['sideBPointScore'] as int? ?? 0,
        sideAGamesWon: json['sideAGamesWon'] as int? ?? 0,
        sideBGamesWon: json['sideBGamesWon'] as int? ?? 0,
        currentGameIndex: json['currentGameIndex'] as int? ?? 1,
        currentServer: PlayerSide.values.firstWhere(
          (e) => e.name == json['currentServer'],
          orElse: () => PlayerSide.sideA,
        ),
        serverPlayerIndex: json['serverPlayerIndex'] as int? ?? 0,
        currentServeBox: ServeBox.values.firstWhere(
          (e) => e.name == json['currentServeBox'],
          orElse: () => ServeBox.right,
        ),
        mustSelectServeBox: json['mustSelectServeBox'] as bool? ?? true,
        gameHistory: (json['gameHistory'] as List? ?? [])
            .map((g) => SquashGameResult.fromJson(g as Map<String, dynamic>))
            .toList(),
        conductLog: List<String>.from(json['conductLog'] as List? ?? []),
        isGameFinished: json['isGameFinished'] as bool? ?? false,
        isMatchFinished: json['isMatchFinished'] as bool? ?? false,
        matchWinner: json['matchWinner'] != null
            ? PlayerSide.values.firstWhere(
                (e) => e.name == json['matchWinner'],
                orElse: () => PlayerSide.sideA,
              )
            : null,
        isDeuceChoicePending: json['isDeuceChoicePending'] as bool? ?? false,
        hihoTargetPoints: json['hihoTargetPoints'] as int? ?? 9,
      );
}
