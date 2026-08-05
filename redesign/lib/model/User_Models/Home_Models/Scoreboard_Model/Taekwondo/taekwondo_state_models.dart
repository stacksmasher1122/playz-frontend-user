import 'dart:convert';

class Taekwondoin {
  final String id;
  final String name;
  final String weightClass;
  final int gamJeomCount; // 0..5 (5 = PUN Disqualification)
  final int roundsWon;

  const Taekwondoin({
    required this.id,
    required this.name,
    this.weightClass = 'OPEN',
    this.gamJeomCount = 0,
    this.roundsWon = 0,
  });

  Taekwondoin copyWith({
    String? id,
    String? name,
    String? weightClass,
    int? gamJeomCount,
    int? roundsWon,
  }) {
    return Taekwondoin(
      id: id ?? this.id,
      name: name ?? this.name,
      weightClass: weightClass ?? this.weightClass,
      gamJeomCount: gamJeomCount ?? this.gamJeomCount,
      roundsWon: roundsWon ?? this.roundsWon,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'weightClass': weightClass,
        'gamJeomCount': gamJeomCount,
        'roundsWon': roundsWon,
      };

  factory Taekwondoin.fromJson(Map<String, dynamic> json) => Taekwondoin(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        weightClass: json['weightClass']?.toString() ?? 'OPEN',
        gamJeomCount: json['gamJeomCount'] is int ? json['gamJeomCount'] : int.tryParse(json['gamJeomCount']?.toString() ?? '') ?? 0,
        roundsWon: json['roundsWon'] is int ? json['roundsWon'] : int.tryParse(json['roundsWon']?.toString() ?? '') ?? 0,
      );
}

class TaekwondoMatchConfig {
  final String category; // 'SENIOR_3x2MIN', 'JUNIOR_3x1_5MIN', 'CUSTOM'
  final int totalRounds; // 3 or 5
  final int roundDurationMinutes; // 1, 2, 3
  final int restDurationSeconds; // 30, 60
  final int pointGapThreshold; // Default 12 pts

  const TaekwondoMatchConfig({
    this.category = 'SENIOR_3x2MIN',
    this.totalRounds = 3,
    this.roundDurationMinutes = 2,
    this.restDurationSeconds = 60,
    this.pointGapThreshold = 12,
  });

  Map<String, dynamic> toJson() => {
        'category': category,
        'totalRounds': totalRounds,
        'roundDurationMinutes': roundDurationMinutes,
        'restDurationSeconds': restDurationSeconds,
        'pointGapThreshold': pointGapThreshold,
      };

  factory TaekwondoMatchConfig.fromJson(Map<String, dynamic> json) => TaekwondoMatchConfig(
        category: json['category']?.toString() ?? 'SENIOR_3x2MIN',
        totalRounds: json['totalRounds'] is int ? json['totalRounds'] : int.tryParse(json['totalRounds']?.toString() ?? '') ?? 3,
        roundDurationMinutes: json['roundDurationMinutes'] is int ? json['roundDurationMinutes'] : int.tryParse(json['roundDurationMinutes']?.toString() ?? '') ?? 2,
        restDurationSeconds: json['restDurationSeconds'] is int ? json['restDurationSeconds'] : int.tryParse(json['restDurationSeconds']?.toString() ?? '') ?? 60,
        pointGapThreshold: json['pointGapThreshold'] is int ? json['pointGapThreshold'] : int.tryParse(json['pointGapThreshold']?.toString() ?? '') ?? 12,
      );
}

class TaekwondoMatchState {
  final Taekwondoin hongFighter; // HONG (Red Corner)
  final Taekwondoin chongFighter; // CHONG (Blue Corner)
  final int currentRound;
  final bool isRestTime;
  final int roundTimeRemaining;
  final int restTimeRemaining;
  final int sideAPoints;
  final int sideBPoints;
  final bool isMatchFinished;
  final String? victoryType; // 'PTG (Point Gap)', 'PUN (Disqualification)', 'POINTS', 'KO'
  final String? winnerSide; // 'hong', 'chong', 'draw'
  final TaekwondoMatchConfig config;

  const TaekwondoMatchState({
    required this.hongFighter,
    required this.chongFighter,
    required this.currentRound,
    required this.isRestTime,
    required this.roundTimeRemaining,
    required this.restTimeRemaining,
    required this.sideAPoints,
    required this.sideBPoints,
    required this.isMatchFinished,
    this.victoryType,
    this.winnerSide,
    required this.config,
  });

  factory TaekwondoMatchState.initial({
    required Taekwondoin hongFighter,
    required Taekwondoin chongFighter,
    required TaekwondoMatchConfig config,
  }) {
    return TaekwondoMatchState(
      hongFighter: hongFighter,
      chongFighter: chongFighter,
      currentRound: 1,
      isRestTime: false,
      roundTimeRemaining: config.roundDurationMinutes * 60,
      restTimeRemaining: config.restDurationSeconds,
      sideAPoints: 0,
      sideBPoints: 0,
      isMatchFinished: false,
      victoryType: null,
      winnerSide: null,
      config: config,
    );
  }

  TaekwondoMatchState copyWith({
    Taekwondoin? hongFighter,
    Taekwondoin? chongFighter,
    int? currentRound,
    bool? isRestTime,
    int? roundTimeRemaining,
    int? restTimeRemaining,
    int? sideAPoints,
    int? sideBPoints,
    bool? isMatchFinished,
    String? victoryType,
    String? winnerSide,
    TaekwondoMatchConfig? config,
  }) {
    return TaekwondoMatchState(
      hongFighter: hongFighter ?? this.hongFighter,
      chongFighter: chongFighter ?? this.chongFighter,
      currentRound: currentRound ?? this.currentRound,
      isRestTime: isRestTime ?? this.isRestTime,
      roundTimeRemaining: roundTimeRemaining ?? this.roundTimeRemaining,
      restTimeRemaining: restTimeRemaining ?? this.restTimeRemaining,
      sideAPoints: sideAPoints ?? this.sideAPoints,
      sideBPoints: sideBPoints ?? this.sideBPoints,
      isMatchFinished: isMatchFinished ?? this.isMatchFinished,
      victoryType: victoryType ?? this.victoryType,
      winnerSide: winnerSide ?? this.winnerSide,
      config: config ?? this.config,
    );
  }

  Map<String, dynamic> toJson() => {
        'hongFighter': hongFighter.toJson(),
        'chongFighter': chongFighter.toJson(),
        'currentRound': currentRound,
        'isRestTime': isRestTime,
        'roundTimeRemaining': roundTimeRemaining,
        'restTimeRemaining': restTimeRemaining,
        'sideAPoints': sideAPoints,
        'sideBPoints': sideBPoints,
        'isMatchFinished': isMatchFinished,
        'victoryType': victoryType,
        'winnerSide': winnerSide,
        'config': config.toJson(),
      };

  factory TaekwondoMatchState.fromJson(Map<String, dynamic> json) => TaekwondoMatchState(
        hongFighter: json['hongFighter'] != null
            ? Taekwondoin.fromJson(Map<String, dynamic>.from(json['hongFighter'] is String ? jsonDecode(json['hongFighter']) : json['hongFighter']))
            : const Taekwondoin(id: 'hong', name: 'HONG (Red)'),
        chongFighter: json['chongFighter'] != null
            ? Taekwondoin.fromJson(Map<String, dynamic>.from(json['chongFighter'] is String ? jsonDecode(json['chongFighter']) : json['chongFighter']))
            : const Taekwondoin(id: 'chong', name: 'CHONG (Blue)'),
        currentRound: json['currentRound'] is int ? json['currentRound'] : int.tryParse(json['currentRound']?.toString() ?? '') ?? 1,
        isRestTime: json['isRestTime'] == true || json['isRestTime'] == 1,
        roundTimeRemaining: json['roundTimeRemaining'] is int ? json['roundTimeRemaining'] : int.tryParse(json['roundTimeRemaining']?.toString() ?? '') ?? 120,
        restTimeRemaining: json['restTimeRemaining'] is int ? json['restTimeRemaining'] : int.tryParse(json['restTimeRemaining']?.toString() ?? '') ?? 60,
        sideAPoints: json['sideAPoints'] is int ? json['sideAPoints'] : int.tryParse(json['sideAPoints']?.toString() ?? '') ?? 0,
        sideBPoints: json['sideBPoints'] is int ? json['sideBPoints'] : int.tryParse(json['sideBPoints']?.toString() ?? '') ?? 0,
        isMatchFinished: json['isMatchFinished'] == true || json['isMatchFinished'] == 1,
        victoryType: json['victoryType']?.toString(),
        winnerSide: json['winnerSide']?.toString(),
        config: json['config'] != null
            ? TaekwondoMatchConfig.fromJson(Map<String, dynamic>.from(json['config'] is String ? jsonDecode(json['config']) : json['config']))
            : const TaekwondoMatchConfig(),
      );
}

class TaekwondoMatchEngine {
  TaekwondoMatchState _state;
  final List<TaekwondoMatchState> _history = [];

  TaekwondoMatchEngine(this._state);

  TaekwondoMatchState get state => _state;

  bool get canUndo => _history.isNotEmpty;

  void undo() {
    if (!canUndo) return;
    _state = _history.removeLast();
  }

  void scorePoints(String scoringSide, int points) {
    if (_state.isMatchFinished) return;
    _history.add(_state);

    int newPtsA = _state.sideAPoints;
    int newPtsB = _state.sideBPoints;

    if (scoringSide == 'hong') {
      newPtsA += points;
    } else {
      newPtsB += points;
    }

    // World Taekwondo Point Gap Superiority (PTG) Check (>= 12 pts lead)
    bool gapFinish = false;
    String? winner;
    int diff = (newPtsA - newPtsB).abs();
    if (diff >= _state.config.pointGapThreshold) {
      gapFinish = true;
      winner = newPtsA > newPtsB ? 'hong' : 'chong';
    }

    _state = _state.copyWith(
      sideAPoints: newPtsA,
      sideBPoints: newPtsB,
      isMatchFinished: gapFinish,
      victoryType: gapFinish ? 'PTG (Point Gap Superiority)' : null,
      winnerSide: winner,
    );
  }

  void recordGamJeom(String foulSide) {
    if (_state.isMatchFinished) return;
    _history.add(_state);

    Taekwondoin hong = _state.hongFighter;
    Taekwondoin chong = _state.chongFighter;
    int newPtsA = _state.sideAPoints;
    int newPtsB = _state.sideBPoints;
    bool punDQ = false;
    String? winner;

    if (foulSide == 'hong') {
      int newGam = hong.gamJeomCount + 1;
      newPtsB += 1; // +1 Point awarded to opponent (CHONG)
      if (newGam >= 5) {
        punDQ = true;
        winner = 'chong';
        newGam = 5;
      }
      hong = hong.copyWith(gamJeomCount: newGam);
    } else {
      int newGam = chong.gamJeomCount + 1;
      newPtsA += 1; // +1 Point awarded to opponent (HONG)
      if (newGam >= 5) {
        punDQ = true;
        winner = 'hong';
        newGam = 5;
      }
      chong = chong.copyWith(gamJeomCount: newGam);
    }

    _state = _state.copyWith(
      hongFighter: hong,
      chongFighter: chong,
      sideAPoints: newPtsA,
      sideBPoints: newPtsB,
      isMatchFinished: punDQ,
      victoryType: punDQ ? 'PUN (5 Gam-Jeom Disqualification)' : null,
      winnerSide: winner,
    );
  }

  void endRound() {
    if (_state.isMatchFinished) return;
    _history.add(_state);

    if (_state.currentRound >= _state.config.totalRounds) {
      // Final Round Finished
      finishMatch();
    } else {
      // Start Rest Break
      _state = _state.copyWith(
        isRestTime: true,
        restTimeRemaining: _state.config.restDurationSeconds,
      );
    }
  }

  void nextRound() {
    if (_state.isMatchFinished) return;
    _history.add(_state);

    _state = _state.copyWith(
      currentRound: _state.currentRound + 1,
      isRestTime: false,
      roundTimeRemaining: _state.config.roundDurationMinutes * 60,
    );
  }

  void recordDisqualification(String dqSide) {
    _history.add(_state);
    final winner = dqSide == 'hong' ? 'chong' : 'hong';
    _state = _state.copyWith(
      isMatchFinished: true,
      victoryType: 'PUN (Disqualification)',
      winnerSide: winner,
    );
  }

  void finishMatch() {
    if (_state.isMatchFinished) return;
    _history.add(_state);

    String? winner;
    if (_state.sideAPoints > _state.sideBPoints) {
      winner = 'hong';
    } else if (_state.sideBPoints > _state.sideAPoints) {
      winner = 'chong';
    } else {
      winner = 'draw';
    }

    _state = _state.copyWith(
      isMatchFinished: true,
      victoryType: 'POINTS DECISION',
      winnerSide: winner,
    );
  }

  void stopMatch(String victoryType, String winnerSide) {
    _history.add(_state);
    _state = _state.copyWith(
      isMatchFinished: true,
      victoryType: victoryType,
      winnerSide: winnerSide,
    );
  }
}
