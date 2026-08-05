import 'dart:convert';

/* ═══════════════════ DATA MODELS & ENUMS ═══════════════════ */

class TennisPlayer {
  final String id; // Stable UID
  final String name;
  final String email;
  final String profilePic;
  final int pointsWon;
  final int aces;
  final int doubleFaults;
  final int winners;
  final int unforcedErrors;
  final int firstServesIn;
  final int firstServesTotal;

  const TennisPlayer({
    required this.id,
    required this.name,
    this.email = '',
    this.profilePic = '',
    this.pointsWon = 0,
    this.aces = 0,
    this.doubleFaults = 0,
    this.winners = 0,
    this.unforcedErrors = 0,
    this.firstServesIn = 0,
    this.firstServesTotal = 0,
  });

  double get firstServePercentage =>
      firstServesTotal == 0 ? 0.0 : (firstServesIn / firstServesTotal) * 100.0;

  TennisPlayer copyWith({
    String? id,
    String? name,
    String? email,
    String? profilePic,
    int? pointsWon,
    int? aces,
    int? doubleFaults,
    int? winners,
    int? unforcedErrors,
    int? firstServesIn,
    int? firstServesTotal,
  }) {
    return TennisPlayer(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profilePic: profilePic ?? this.profilePic,
      pointsWon: pointsWon ?? this.pointsWon,
      aces: aces ?? this.aces,
      doubleFaults: doubleFaults ?? this.doubleFaults,
      winners: winners ?? this.winners,
      unforcedErrors: unforcedErrors ?? this.unforcedErrors,
      firstServesIn: firstServesIn ?? this.firstServesIn,
      firstServesTotal: firstServesTotal ?? this.firstServesTotal,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'profilePic': profilePic,
        'pointsWon': pointsWon,
        'aces': aces,
        'doubleFaults': doubleFaults,
        'winners': winners,
        'unforcedErrors': unforcedErrors,
        'firstServesIn': firstServesIn,
        'firstServesTotal': firstServesTotal,
      };

  factory TennisPlayer.fromJson(Map<String, dynamic> json) => TennisPlayer(
        id: json['id']?.toString() ?? 'player_${DateTime.now().millisecondsSinceEpoch}',
        name: json['name']?.toString() ?? 'Player',
        email: json['email']?.toString() ?? '',
        profilePic: json['profilePic']?.toString() ?? '',
        pointsWon: json['pointsWon'] is int ? json['pointsWon'] : int.tryParse(json['pointsWon']?.toString() ?? '') ?? 0,
        aces: json['aces'] is int ? json['aces'] : int.tryParse(json['aces']?.toString() ?? '') ?? 0,
        doubleFaults: json['doubleFaults'] is int ? json['doubleFaults'] : int.tryParse(json['doubleFaults']?.toString() ?? '') ?? 0,
        winners: json['winners'] is int ? json['winners'] : int.tryParse(json['winners']?.toString() ?? '') ?? 0,
        unforcedErrors: json['unforcedErrors'] is int ? json['unforcedErrors'] : int.tryParse(json['unforcedErrors']?.toString() ?? '') ?? 0,
        firstServesIn: json['firstServesIn'] is int ? json['firstServesIn'] : int.tryParse(json['firstServesIn']?.toString() ?? '') ?? 0,
        firstServesTotal: json['firstServesTotal'] is int ? json['firstServesTotal'] : int.tryParse(json['firstServesTotal']?.toString() ?? '') ?? 0,
      );
}

class SetScore {
  final int setNumber;
  final int sideAGames;
  final int sideBGames;
  final int tiebreakSideAPoints;
  final int tiebreakSideBPoints;
  final bool isTiebreak;
  final bool isCompleted;
  final String? winnerSide;

  const SetScore({
    required this.setNumber,
    this.sideAGames = 0,
    this.sideBGames = 0,
    this.tiebreakSideAPoints = 0,
    this.tiebreakSideBPoints = 0,
    this.isTiebreak = false,
    this.isCompleted = false,
    this.winnerSide,
  });

  SetScore copyWith({
    int? setNumber,
    int? sideAGames,
    int? sideBGames,
    int? tiebreakSideAPoints,
    int? tiebreakSideBPoints,
    bool? isTiebreak,
    bool? isCompleted,
    String? winnerSide,
  }) {
    return SetScore(
      setNumber: setNumber ?? this.setNumber,
      sideAGames: sideAGames ?? this.sideAGames,
      sideBGames: sideBGames ?? this.sideBGames,
      tiebreakSideAPoints: tiebreakSideAPoints ?? this.tiebreakSideAPoints,
      tiebreakSideBPoints: tiebreakSideBPoints ?? this.tiebreakSideBPoints,
      isTiebreak: isTiebreak ?? this.isTiebreak,
      isCompleted: isCompleted ?? this.isCompleted,
      winnerSide: winnerSide ?? this.winnerSide,
    );
  }

  Map<String, dynamic> toJson() => {
        'setNumber': setNumber,
        'sideAGames': sideAGames,
        'sideBGames': sideBGames,
        'tiebreakSideAPoints': tiebreakSideAPoints,
        'tiebreakSideBPoints': tiebreakSideBPoints,
        'isTiebreak': isTiebreak,
        'isCompleted': isCompleted,
        'winnerSide': winnerSide,
      };

  factory SetScore.fromJson(Map<String, dynamic> json) => SetScore(
        setNumber: json['setNumber'] is int ? json['setNumber'] : int.tryParse(json['setNumber']?.toString() ?? '') ?? 1,
        sideAGames: json['sideAGames'] is int ? json['sideAGames'] : int.tryParse(json['sideAGames']?.toString() ?? '') ?? 0,
        sideBGames: json['sideBGames'] is int ? json['sideBGames'] : int.tryParse(json['sideBGames']?.toString() ?? '') ?? 0,
        tiebreakSideAPoints: json['tiebreakSideAPoints'] is int ? json['tiebreakSideAPoints'] : int.tryParse(json['tiebreakSideAPoints']?.toString() ?? '') ?? 0,
        tiebreakSideBPoints: json['tiebreakSideBPoints'] is int ? json['tiebreakSideBPoints'] : int.tryParse(json['tiebreakSideBPoints']?.toString() ?? '') ?? 0,
        isTiebreak: json['isTiebreak'] == true || json['isTiebreak'] == 1,
        isCompleted: json['isCompleted'] == true || json['isCompleted'] == 1,
        winnerSide: json['winnerSide']?.toString(),
      );
}

class TennisMatchConfig {
  final String format; // 'SINGLES' or 'DOUBLES'
  final String setsFormat; // 'BEST_OF_1', 'BEST_OF_3', 'BEST_OF_5'
  final bool isFriendlyMode;
  final int gamesPerSet; // 6 (Pro default) or 4 (Friendly default)
  final int tiebreakTarget; // 7 (Standard) or 10
  final bool noAdScoring; // false (Pro) or true (Friendly)
  final String finalSetFormat; // 'STANDARD_TIEBREAK', 'ADVANTAGE_SET', 'MATCH_TIEBREAK_10'
  final String homeTeamName;
  final String awayTeamName;

  const TennisMatchConfig({
    this.format = 'SINGLES',
    this.setsFormat = 'BEST_OF_3',
    this.isFriendlyMode = false,
    this.gamesPerSet = 6,
    this.tiebreakTarget = 7,
    this.noAdScoring = false,
    this.finalSetFormat = 'STANDARD_TIEBREAK',
    this.homeTeamName = 'Team A',
    this.awayTeamName = 'Team B',
  });

  int get setsToWin {
    switch (setsFormat) {
      case 'BEST_OF_1':
        return 1;
      case 'BEST_OF_5':
        return 3;
      case 'BEST_OF_3':
      default:
        return 2;
    }
  }

  TennisMatchConfig copyWith({
    String? format,
    String? setsFormat,
    bool? isFriendlyMode,
    int? gamesPerSet,
    int? tiebreakTarget,
    bool? noAdScoring,
    String? finalSetFormat,
    String? homeTeamName,
    String? awayTeamName,
  }) {
    return TennisMatchConfig(
      format: format ?? this.format,
      setsFormat: setsFormat ?? this.setsFormat,
      isFriendlyMode: isFriendlyMode ?? this.isFriendlyMode,
      gamesPerSet: gamesPerSet ?? this.gamesPerSet,
      tiebreakTarget: tiebreakTarget ?? this.tiebreakTarget,
      noAdScoring: noAdScoring ?? this.noAdScoring,
      finalSetFormat: finalSetFormat ?? this.finalSetFormat,
      homeTeamName: homeTeamName ?? this.homeTeamName,
      awayTeamName: awayTeamName ?? this.awayTeamName,
    );
  }

  Map<String, dynamic> toJson() => {
        'format': format,
        'setsFormat': setsFormat,
        'isFriendlyMode': isFriendlyMode,
        'gamesPerSet': gamesPerSet,
        'tiebreakTarget': tiebreakTarget,
        'noAdScoring': noAdScoring,
        'finalSetFormat': finalSetFormat,
        'homeTeamName': homeTeamName,
        'awayTeamName': awayTeamName,
      };

  factory TennisMatchConfig.fromJson(Map<String, dynamic> json) =>
      TennisMatchConfig(
        format: json['format']?.toString() ?? 'SINGLES',
        setsFormat: json['setsFormat']?.toString() ?? 'BEST_OF_3',
        isFriendlyMode: json['isFriendlyMode'] == true || json['isFriendlyMode'] == 1,
        gamesPerSet: json['gamesPerSet'] is int ? json['gamesPerSet'] : int.tryParse(json['gamesPerSet']?.toString() ?? '') ?? 6,
        tiebreakTarget: json['tiebreakTarget'] is int ? json['tiebreakTarget'] : int.tryParse(json['tiebreakTarget']?.toString() ?? '') ?? 7,
        noAdScoring: json['noAdScoring'] == true || json['noAdScoring'] == 1,
        finalSetFormat: json['finalSetFormat']?.toString() ?? 'STANDARD_TIEBREAK',
        homeTeamName: json['homeTeamName']?.toString() ?? 'Team A',
        awayTeamName: json['awayTeamName']?.toString() ?? 'Team B',
      );
}

class TennisPointEvent {
  final String id;
  final String winnerSide; // 'A' or 'B'
  final String outcomeType; // 'normalPoint', 'ace', 'winner', 'unforcedError', 'forcedError', 'doubleFault', 'let', 'fault'
  final String serverSide; // 'A' or 'B'
  final int serverPlayerIndex;
  final String servingCourt; // 'DEUCE' or 'AD'
  final bool isSecondServe;
  final int setNumber;
  final int gameNumberInSet;
  final String scoreBefore;
  final String scoreAfter;
  final DateTime timestamp;

  TennisPointEvent({
    required this.id,
    required this.winnerSide,
    this.outcomeType = 'normalPoint',
    required this.serverSide,
    this.serverPlayerIndex = 0,
    required this.servingCourt,
    this.isSecondServe = false,
    required this.setNumber,
    required this.gameNumberInSet,
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
        'servingCourt': servingCourt,
        'isSecondServe': isSecondServe,
        'setNumber': setNumber,
        'gameNumberInSet': gameNumberInSet,
        'scoreBefore': scoreBefore,
        'scoreAfter': scoreAfter,
        'timestamp': timestamp.toIso8601String(),
      };

  factory TennisPointEvent.fromJson(Map<String, dynamic> json) =>
      TennisPointEvent(
        id: json['id']?.toString() ?? 'player_${DateTime.now().millisecondsSinceEpoch}',
        winnerSide: json['winnerSide']?.toString() ?? 'A',
        outcomeType: json['outcomeType']?.toString() ?? 'normalPoint',
        serverSide: json['serverSide']?.toString() ?? 'A',
        serverPlayerIndex: json['serverPlayerIndex'] is int ? json['serverPlayerIndex'] : int.tryParse(json['serverPlayerIndex']?.toString() ?? '') ?? 0,
        servingCourt: json['servingCourt']?.toString() ?? 'DEUCE',
        isSecondServe: json['isSecondServe'] == true || json['isSecondServe'] == 1,
        setNumber: json['setNumber'] is int ? json['setNumber'] : int.tryParse(json['setNumber']?.toString() ?? '') ?? 1,
        gameNumberInSet: json['gameNumberInSet'] is int ? json['gameNumberInSet'] : int.tryParse(json['gameNumberInSet']?.toString() ?? '') ?? 1,
        scoreBefore: json['scoreBefore']?.toString() ?? '0-0',
        scoreAfter: json['scoreAfter']?.toString() ?? '0-0',
        timestamp: json['timestamp'] != null
            ? DateTime.tryParse(json['timestamp'].toString()) ?? DateTime.now()
            : DateTime.now(),
      );
}

class TennisMatchState {
  final String sideAPointScore; // '0', '15', '30', '40', 'AD'
  final String sideBPointScore; // '0', '15', '30', '40', 'AD'
  final int sideAPointCount;
  final int sideBPointCount;
  final int sideATiebreakPoints;
  final int sideBTiebreakPoints;
  final bool isTiebreak;
  final bool isMatchTiebreak;
  final int currentSetIndex;
  final List<SetScore> setScores;
  final int sideASetsWon;
  final int sideBSetsWon;
  final String servingSide; // 'A' or 'B'
  final int servingPlayerIndex; // 0 or 1 for doubles
  final String servingCourt; // 'DEUCE' or 'AD'
  final bool isSecondServe;
  final bool isEndsSwitched;
  final String matchStatus; // 'INITIALIZING', 'LIVE', 'COMPLETED', 'RETIRED'
  final String matchResult;
  final TennisMatchConfig matchConfig;
  final List<TennisPlayer> sideAPlayers;
  final List<TennisPlayer> sideBPlayers;
  final List<TennisPointEvent> history;
  final String tossWinner;
  final String tossDecision;

  const TennisMatchState({
    this.sideAPointScore = '0',
    this.sideBPointScore = '0',
    this.sideAPointCount = 0,
    this.sideBPointCount = 0,
    this.sideATiebreakPoints = 0,
    this.sideBTiebreakPoints = 0,
    this.isTiebreak = false,
    this.isMatchTiebreak = false,
    this.currentSetIndex = 0,
    this.setScores = const [],
    this.sideASetsWon = 0,
    this.sideBSetsWon = 0,
    this.servingSide = 'A',
    this.servingPlayerIndex = 0,
    this.servingCourt = 'DEUCE',
    this.isSecondServe = false,
    this.isEndsSwitched = false,
    this.matchStatus = 'INITIALIZING',
    this.matchResult = '',
    this.matchConfig = const TennisMatchConfig(),
    this.sideAPlayers = const [],
    this.sideBPlayers = const [],
    this.history = const [],
    this.tossWinner = '',
    this.tossDecision = '',
  });

  TennisMatchState copyWith({
    String? sideAPointScore,
    String? sideBPointScore,
    int? sideAPointCount,
    int? sideBPointCount,
    int? sideATiebreakPoints,
    int? sideBTiebreakPoints,
    bool? isTiebreak,
    bool? isMatchTiebreak,
    int? currentSetIndex,
    List<SetScore>? setScores,
    int? sideASetsWon,
    int? sideBSetsWon,
    String? servingSide,
    int? servingPlayerIndex,
    String? servingCourt,
    bool? isSecondServe,
    bool? isEndsSwitched,
    String? matchStatus,
    String? matchResult,
    TennisMatchConfig? matchConfig,
    List<TennisPlayer>? sideAPlayers,
    List<TennisPlayer>? sideBPlayers,
    List<TennisPointEvent>? history,
    String? tossWinner,
    String? tossDecision,
  }) {
    return TennisMatchState(
      sideAPointScore: sideAPointScore ?? this.sideAPointScore,
      sideBPointScore: sideBPointScore ?? this.sideBPointScore,
      sideAPointCount: sideAPointCount ?? this.sideAPointCount,
      sideBPointCount: sideBPointCount ?? this.sideBPointCount,
      sideATiebreakPoints: sideATiebreakPoints ?? this.sideATiebreakPoints,
      sideBTiebreakPoints: sideBTiebreakPoints ?? this.sideBTiebreakPoints,
      isTiebreak: isTiebreak ?? this.isTiebreak,
      isMatchTiebreak: isMatchTiebreak ?? this.isMatchTiebreak,
      currentSetIndex: currentSetIndex ?? this.currentSetIndex,
      setScores: setScores ?? this.setScores,
      sideASetsWon: sideASetsWon ?? this.sideASetsWon,
      sideBSetsWon: sideBSetsWon ?? this.sideBSetsWon,
      servingSide: servingSide ?? this.servingSide,
      servingPlayerIndex: servingPlayerIndex ?? this.servingPlayerIndex,
      servingCourt: servingCourt ?? this.servingCourt,
      isSecondServe: isSecondServe ?? this.isSecondServe,
      isEndsSwitched: isEndsSwitched ?? this.isEndsSwitched,
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
        'sideAPointScore': sideAPointScore,
        'sideBPointScore': sideBPointScore,
        'sideAPointCount': sideAPointCount,
        'sideBPointCount': sideBPointCount,
        'sideATiebreakPoints': sideATiebreakPoints,
        'sideBTiebreakPoints': sideBTiebreakPoints,
        'isTiebreak': isTiebreak,
        'isMatchTiebreak': isMatchTiebreak,
        'currentSetIndex': currentSetIndex,
        'setScores': setScores.map((s) => s.toJson()).toList(),
        'sideASetsWon': sideASetsWon,
        'sideBSetsWon': sideBSetsWon,
        'servingSide': servingSide,
        'servingPlayerIndex': servingPlayerIndex,
        'servingCourt': servingCourt,
        'isSecondServe': isSecondServe,
        'isEndsSwitched': isEndsSwitched,
        'matchStatus': matchStatus,
        'matchResult': matchResult,
        'matchConfig': matchConfig.toJson(),
        'sideAPlayers': sideAPlayers.map((p) => p.toJson()).toList(),
        'sideBPlayers': sideBPlayers.map((p) => p.toJson()).toList(),
        'history': history.map((e) => e.toJson()).toList(),
        'tossWinner': tossWinner,
        'tossDecision': tossDecision,
      };

  factory TennisMatchState.fromJson(Map<String, dynamic> json) =>
      TennisMatchState(
        sideAPointScore: json['sideAPointScore']?.toString() ?? '0',
        sideBPointScore: json['sideBPointScore']?.toString() ?? '0',
        sideAPointCount: json['sideAPointCount'] is int ? json['sideAPointCount'] : int.tryParse(json['sideAPointCount']?.toString() ?? '') ?? 0,
        sideBPointCount: json['sideBPointCount'] is int ? json['sideBPointCount'] : int.tryParse(json['sideBPointCount']?.toString() ?? '') ?? 0,
        sideATiebreakPoints: json['sideATiebreakPoints'] is int ? json['sideATiebreakPoints'] : int.tryParse(json['sideATiebreakPoints']?.toString() ?? '') ?? 0,
        sideBTiebreakPoints: json['sideBTiebreakPoints'] is int ? json['sideBTiebreakPoints'] : int.tryParse(json['sideBTiebreakPoints']?.toString() ?? '') ?? 0,
        isTiebreak: json['isTiebreak'] == true || json['isTiebreak'] == 1,
        isMatchTiebreak: json['isMatchTiebreak'] == true || json['isMatchTiebreak'] == 1,
        currentSetIndex: json['currentSetIndex'] is int ? json['currentSetIndex'] : int.tryParse(json['currentSetIndex']?.toString() ?? '') ?? 0,
        setScores: (json['setScores'] as List? ?? [])
            .map((s) => SetScore.fromJson(Map<String, dynamic>.from(s is String ? jsonDecode(s) : s)))
            .toList(),
        sideASetsWon: json['sideASetsWon'] is int ? json['sideASetsWon'] : int.tryParse(json['sideASetsWon']?.toString() ?? '') ?? 0,
        sideBSetsWon: json['sideBSetsWon'] is int ? json['sideBSetsWon'] : int.tryParse(json['sideBSetsWon']?.toString() ?? '') ?? 0,
        servingSide: json['servingSide']?.toString() ?? 'A',
        servingPlayerIndex: json['servingPlayerIndex'] is int ? json['servingPlayerIndex'] : int.tryParse(json['servingPlayerIndex']?.toString() ?? '') ?? 0,
        servingCourt: json['servingCourt']?.toString() ?? 'DEUCE',
        isSecondServe: json['isSecondServe'] == true || json['isSecondServe'] == 1,
        isEndsSwitched: json['isEndsSwitched'] == true || json['isEndsSwitched'] == 1,
        matchStatus: json['matchStatus']?.toString() ?? 'INITIALIZING',
        matchResult: json['matchResult']?.toString() ?? '',
        matchConfig: json['matchConfig'] != null
            ? TennisMatchConfig.fromJson(Map<String, dynamic>.from(json['matchConfig'] is String ? jsonDecode(json['matchConfig']) : json['matchConfig']))
            : const TennisMatchConfig(),
        sideAPlayers: (json['sideAPlayers'] as List? ?? [])
            .map((p) => TennisPlayer.fromJson(Map<String, dynamic>.from(p is String ? jsonDecode(p) : p)))
            .toList(),
        sideBPlayers: (json['sideBPlayers'] as List? ?? [])
            .map((p) => TennisPlayer.fromJson(Map<String, dynamic>.from(p is String ? jsonDecode(p) : p)))
            .toList(),
        history: (json['history'] as List? ?? [])
            .map((e) => TennisPointEvent.fromJson(Map<String, dynamic>.from(e is String ? jsonDecode(e) : e)))
            .toList(),
        tossWinner: json['tossWinner']?.toString() ?? '',
        tossDecision: json['tossDecision']?.toString() ?? '',
      );
}
