import 'dart:convert';

class PickleballPlayer {
  final String id;
  final String name;
  final int number;
  final int pointsScored;
  final int aces;
  final int faults;

  const PickleballPlayer({
    required this.id,
    required this.name,
    this.number = 0,
    this.pointsScored = 0,
    this.aces = 0,
    this.faults = 0,
  });

  PickleballPlayer copyWith({
    String? id,
    String? name,
    int? number,
    int? pointsScored,
    int? aces,
    int? faults,
  }) {
    return PickleballPlayer(
      id: id ?? this.id,
      name: name ?? this.name,
      number: number ?? this.number,
      pointsScored: pointsScored ?? this.pointsScored,
      aces: aces ?? this.aces,
      faults: faults ?? this.faults,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'number': number,
        'pointsScored': pointsScored,
        'aces': aces,
        'faults': faults,
      };

  factory PickleballPlayer.fromJson(Map<String, dynamic> json) => PickleballPlayer(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        number: json['number'] is int ? json['number'] : int.tryParse(json['number']?.toString() ?? '') ?? 0,
        pointsScored: json['pointsScored'] is int ? json['pointsScored'] : int.tryParse(json['pointsScored']?.toString() ?? '') ?? 0,
        aces: json['aces'] is int ? json['aces'] : int.tryParse(json['aces']?.toString() ?? '') ?? 0,
        faults: json['faults'] is int ? json['faults'] : int.tryParse(json['faults']?.toString() ?? '') ?? 0,
      );
}

class PickleballGameScore {
  final int gameNumber;
  final int sideAPoints;
  final int sideBPoints;
  final bool isCompleted;
  final String? winnerSide; // 'sideA' or 'sideB'

  const PickleballGameScore({
    required this.gameNumber,
    this.sideAPoints = 0,
    this.sideBPoints = 0,
    this.isCompleted = false,
    this.winnerSide,
  });

  PickleballGameScore copyWith({
    int? gameNumber,
    int? sideAPoints,
    int? sideBPoints,
    bool? isCompleted,
    String? winnerSide,
  }) {
    return PickleballGameScore(
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

  factory PickleballGameScore.fromJson(Map<String, dynamic> json) => PickleballGameScore(
        gameNumber: json['gameNumber'] is int ? json['gameNumber'] : int.tryParse(json['gameNumber']?.toString() ?? '') ?? 1,
        sideAPoints: json['sideAPoints'] is int ? json['sideAPoints'] : int.tryParse(json['sideAPoints']?.toString() ?? '') ?? 0,
        sideBPoints: json['sideBPoints'] is int ? json['sideBPoints'] : int.tryParse(json['sideBPoints']?.toString() ?? '') ?? 0,
        isCompleted: json['isCompleted'] == true || json['isCompleted'] == 1,
        winnerSide: json['winnerSide']?.toString(),
      );
}

class PickleballMatchConfig {
  final String format; // 'SINGLES' or 'DOUBLES'
  final int targetPoints; // 11, 15, or 21
  final bool winByTwo;
  final bool isSideoutScoring; // true (USAPA default) or false (Rally scoring)
  final int gamesToWin; // 2 for Best of 3, 1 for Best of 1, 3 for Best of 5
  final bool isProRules;

  const PickleballMatchConfig({
    this.format = 'SINGLES',
    this.targetPoints = 11,
    this.winByTwo = true,
    this.isSideoutScoring = true,
    this.gamesToWin = 2,
    this.isProRules = true,
  });

  Map<String, dynamic> toJson() => {
        'format': format,
        'targetPoints': targetPoints,
        'winByTwo': winByTwo,
        'isSideoutScoring': isSideoutScoring,
        'gamesToWin': gamesToWin,
        'isProRules': isProRules,
      };

  factory PickleballMatchConfig.fromJson(Map<String, dynamic> json) => PickleballMatchConfig(
        format: json['format']?.toString() ?? 'SINGLES',
        targetPoints: json['targetPoints'] is int ? json['targetPoints'] : int.tryParse(json['targetPoints']?.toString() ?? '') ?? 11,
        winByTwo: json['winByTwo'] == true || json['winByTwo'] == 1,
        isSideoutScoring: json['isSideoutScoring'] == true || json['isSideoutScoring'] == 1,
        gamesToWin: json['gamesToWin'] is int ? json['gamesToWin'] : int.tryParse(json['gamesToWin']?.toString() ?? '') ?? 2,
        isProRules: json['isProRules'] == true || json['isProRules'] == 1,
      );
}

class PickleballMatchState {
  final List<PickleballPlayer> teamA;
  final List<PickleballPlayer> teamB;
  final int sideAPoints;
  final int sideBPoints;
  final int sideAGamesWon;
  final int sideBGamesWon;
  final String servingSide; // 'sideA' or 'sideB'
  final int serverNumber; // 1 or 2 (In Doubles: Server 1 or Server 2; In Singles: always 1)
  final int currentGameIndex;
  final List<PickleballGameScore> gameScores;
  final bool isGameCompleted;
  final bool isMatchFinished;
  final String? matchWinner;
  final PickleballMatchConfig config;

  const PickleballMatchState({
    required this.teamA,
    required this.teamB,
    required this.sideAPoints,
    required this.sideBPoints,
    required this.sideAGamesWon,
    required this.sideBGamesWon,
    required this.servingSide,
    required this.serverNumber,
    required this.currentGameIndex,
    required this.gameScores,
    required this.isGameCompleted,
    required this.isMatchFinished,
    this.matchWinner,
    required this.config,
  });

  factory PickleballMatchState.initial({
    required List<PickleballPlayer> teamA,
    required List<PickleballPlayer> teamB,
    required PickleballMatchConfig config,
    String servingSide = 'sideA',
  }) {
    return PickleballMatchState(
      teamA: teamA,
      teamB: teamB,
      sideAPoints: 0,
      sideBPoints: 0,
      sideAGamesWon: 0,
      sideBGamesWon: 0,
      servingSide: servingSide,
      serverNumber: config.format == 'DOUBLES' ? 2 : 1, // First server in doubles starts on Server 2 by USAPA rule
      currentGameIndex: 0,
      gameScores: const [
        PickleballGameScore(gameNumber: 1, sideAPoints: 0, sideBPoints: 0),
      ],
      isGameCompleted: false,
      isMatchFinished: false,
      matchWinner: null,
      config: config,
    );
  }

  String get officialScoreCall {
    final servingPts = servingSide == 'sideA' ? sideAPoints : sideBPoints;
    final receivingPts = servingSide == 'sideA' ? sideBPoints : sideAPoints;
    if (config.format == 'DOUBLES') {
      return '$servingPts - $receivingPts - $serverNumber';
    }
    return '$servingPts - $receivingPts';
  }

  PickleballMatchState copyWith({
    List<PickleballPlayer>? teamA,
    List<PickleballPlayer>? teamB,
    int? sideAPoints,
    int? sideBPoints,
    int? sideAGamesWon,
    int? sideBGamesWon,
    String? servingSide,
    int? serverNumber,
    int? currentGameIndex,
    List<PickleballGameScore>? gameScores,
    bool? isGameCompleted,
    bool? isMatchFinished,
    String? matchWinner,
    PickleballMatchConfig? config,
  }) {
    return PickleballMatchState(
      teamA: teamA ?? this.teamA,
      teamB: teamB ?? this.teamB,
      sideAPoints: sideAPoints ?? this.sideAPoints,
      sideBPoints: sideBPoints ?? this.sideBPoints,
      sideAGamesWon: sideAGamesWon ?? this.sideAGamesWon,
      sideBGamesWon: sideBGamesWon ?? this.sideBGamesWon,
      servingSide: servingSide ?? this.servingSide,
      serverNumber: serverNumber ?? this.serverNumber,
      currentGameIndex: currentGameIndex ?? this.currentGameIndex,
      gameScores: gameScores ?? this.gameScores,
      isGameCompleted: isGameCompleted ?? this.isGameCompleted,
      isMatchFinished: isMatchFinished ?? this.isMatchFinished,
      matchWinner: matchWinner ?? this.matchWinner,
      config: config ?? this.config,
    );
  }

  Map<String, dynamic> toJson() => {
        'teamA': teamA.map((p) => p.toJson()).toList(),
        'teamB': teamB.map((p) => p.toJson()).toList(),
        'sideAPoints': sideAPoints,
        'sideBPoints': sideBPoints,
        'sideAGamesWon': sideAGamesWon,
        'sideBGamesWon': sideBGamesWon,
        'servingSide': servingSide,
        'serverNumber': serverNumber,
        'currentGameIndex': currentGameIndex,
        'gameScores': gameScores.map((g) => g.toJson()).toList(),
        'isGameCompleted': isGameCompleted,
        'isMatchFinished': isMatchFinished,
        'matchWinner': matchWinner,
        'config': config.toJson(),
      };

  factory PickleballMatchState.fromJson(Map<String, dynamic> json) => PickleballMatchState(
        teamA: (json['teamA'] as List? ?? [])
            .map((p) => PickleballPlayer.fromJson(Map<String, dynamic>.from(p is String ? jsonDecode(p) : p)))
            .toList(),
        teamB: (json['teamB'] as List? ?? [])
            .map((p) => PickleballPlayer.fromJson(Map<String, dynamic>.from(p is String ? jsonDecode(p) : p)))
            .toList(),
        sideAPoints: json['sideAPoints'] is int ? json['sideAPoints'] : int.tryParse(json['sideAPoints']?.toString() ?? '') ?? 0,
        sideBPoints: json['sideBPoints'] is int ? json['sideBPoints'] : int.tryParse(json['sideBPoints']?.toString() ?? '') ?? 0,
        sideAGamesWon: json['sideAGamesWon'] is int ? json['sideAGamesWon'] : int.tryParse(json['sideAGamesWon']?.toString() ?? '') ?? 0,
        sideBGamesWon: json['sideBGamesWon'] is int ? json['sideBGamesWon'] : int.tryParse(json['sideBGamesWon']?.toString() ?? '') ?? 0,
        servingSide: json['servingSide']?.toString() ?? 'sideA',
        serverNumber: json['serverNumber'] is int ? json['serverNumber'] : int.tryParse(json['serverNumber']?.toString() ?? '') ?? 1,
        currentGameIndex: json['currentGameIndex'] is int ? json['currentGameIndex'] : int.tryParse(json['currentGameIndex']?.toString() ?? '') ?? 0,
        gameScores: (json['gameScores'] as List? ?? [])
            .map((g) => PickleballGameScore.fromJson(Map<String, dynamic>.from(g is String ? jsonDecode(g) : g)))
            .toList(),
        isGameCompleted: json['isGameCompleted'] == true || json['isGameCompleted'] == 1,
        isMatchFinished: json['isMatchFinished'] == true || json['isMatchFinished'] == 1,
        matchWinner: json['matchWinner']?.toString(),
        config: json['config'] != null
            ? PickleballMatchConfig.fromJson(Map<String, dynamic>.from(json['config'] is String ? jsonDecode(json['config']) : json['config']))
            : const PickleballMatchConfig(),
      );
}

class PickleballMatchEngine {
  PickleballMatchState _state;
  final List<PickleballMatchState> _history = [];

  PickleballMatchEngine(this._state) {
    _history.add(_state);
  }

  PickleballMatchState get state => _state;

  void scorePoint(String scoringSide) {
    if (_state.isMatchFinished || _state.isGameCompleted) return;
    _history.add(_state);

    int newPtsA = _state.sideAPoints;
    int newPtsB = _state.sideBPoints;
    String newServingSide = _state.servingSide;
    int newServerNum = _state.serverNumber;

    if (_state.config.isSideoutScoring) {
      // USAPA Sideout Scoring Mode: Points only awarded if scoring side is currently serving!
      if (scoringSide == _state.servingSide) {
        if (scoringSide == 'sideA') {
          newPtsA += 1;
        } else {
          newPtsB += 1;
        }
      } else {
        // Fault by serving team! Switch server or sideout.
        if (_state.config.format == 'DOUBLES' && _state.serverNumber == 1) {
          newServerNum = 2;
        } else {
          // Sideout to opponent!
          newServingSide = _state.servingSide == 'sideA' ? 'sideB' : 'sideA';
          newServerNum = 1;
        }
      }
    } else {
      // Rally Scoring Mode: Point awarded on every rally
      if (scoringSide == 'sideA') {
        newPtsA += 1;
      } else {
        newPtsB += 1;
      }
      newServingSide = scoringSide;
      newServerNum = 1;
    }

    // Check if current game won
    final target = _state.config.targetPoints;
    final winByTwo = _state.config.winByTwo;

    bool gameWonA = newPtsA >= target && (!winByTwo || (newPtsA - newPtsB >= 2));
    bool gameWonB = newPtsB >= target && (!winByTwo || (newPtsB - newPtsA >= 2));

    List<PickleballGameScore> updatedGameScores = List.from(_state.gameScores);
    if (updatedGameScores.isNotEmpty) {
      final curGame = updatedGameScores[_state.currentGameIndex];
      updatedGameScores[_state.currentGameIndex] = curGame.copyWith(
        sideAPoints: newPtsA,
        sideBPoints: newPtsB,
        isCompleted: gameWonA || gameWonB,
        winnerSide: gameWonA ? 'sideA' : (gameWonB ? 'sideB' : null),
      );
    }

    int newGamesWonA = _state.sideAGamesWon + (gameWonA ? 1 : 0);
    int newGamesWonB = _state.sideBGamesWon + (gameWonB ? 1 : 0);

    bool matchFinished = newGamesWonA >= _state.config.gamesToWin || newGamesWonB >= _state.config.gamesToWin;
    String? winner;
    if (matchFinished) {
      winner = newGamesWonA > newGamesWonB ? 'sideA' : 'sideB';
    }

    _state = _state.copyWith(
      sideAPoints: newPtsA,
      sideBPoints: newPtsB,
      sideAGamesWon: newGamesWonA,
      sideBGamesWon: newGamesWonB,
      servingSide: newServingSide,
      serverNumber: newServerNum,
      gameScores: updatedGameScores,
      isGameCompleted: gameWonA || gameWonB,
      isMatchFinished: matchFinished,
      matchWinner: winner,
    );
  }

  void registerFault() {
    if (_state.isMatchFinished || _state.isGameCompleted) return;
    final opponent = _state.servingSide == 'sideA' ? 'sideB' : 'sideA';
    scorePoint(opponent);
  }

  void advanceGame() {
    if (_state.isMatchFinished) return;
    _history.add(_state);

    final nextGameIdx = _state.currentGameIndex + 1;
    final newGameScores = List<PickleballGameScore>.from(_state.gameScores)
      ..add(PickleballGameScore(gameNumber: nextGameIdx + 1, sideAPoints: 0, sideBPoints: 0));

    // Next game server alternates
    final nextServing = _state.servingSide == 'sideA' ? 'sideB' : 'sideA';

    _state = _state.copyWith(
      sideAPoints: 0,
      sideBPoints: 0,
      servingSide: nextServing,
      serverNumber: _state.config.format == 'DOUBLES' ? 2 : 1,
      currentGameIndex: nextGameIdx,
      gameScores: newGameScores,
      isGameCompleted: false,
    );
  }

  void endMatch() {
    _history.add(_state);
    String? winner;
    if (_state.sideAGamesWon > _state.sideBGamesWon) {
      winner = 'sideA';
    } else if (_state.sideBGamesWon > _state.sideAGamesWon) {
      winner = 'sideB';
    } else {
      winner = 'draw';
    }

    _state = _state.copyWith(
      isMatchFinished: true,
      matchWinner: winner,
    );
  }

  bool get canUndo => _history.length > 1;

  void undo() {
    if (!canUndo) return;
    _history.removeLast();
    _state = _history.last;
  }
}
