import 'dart:convert';

class BoxingFighter {
  final String id;
  final String name;
  final String weightClass;
  final int knockdownsLanded;
  final int foulsCommitted;

  const BoxingFighter({
    required this.id,
    required this.name,
    this.weightClass = 'WELTERWEIGHT',
    this.knockdownsLanded = 0,
    this.foulsCommitted = 0,
  });

  BoxingFighter copyWith({
    String? id,
    String? name,
    String? weightClass,
    int? knockdownsLanded,
    int? foulsCommitted,
  }) {
    return BoxingFighter(
      id: id ?? this.id,
      name: name ?? this.name,
      weightClass: weightClass ?? this.weightClass,
      knockdownsLanded: knockdownsLanded ?? this.knockdownsLanded,
      foulsCommitted: foulsCommitted ?? this.foulsCommitted,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'weightClass': weightClass,
        'knockdownsLanded': knockdownsLanded,
        'foulsCommitted': foulsCommitted,
      };

  factory BoxingFighter.fromJson(Map<String, dynamic> json) => BoxingFighter(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        weightClass: json['weightClass']?.toString() ?? 'WELTERWEIGHT',
        knockdownsLanded: json['knockdownsLanded'] is int ? json['knockdownsLanded'] : int.tryParse(json['knockdownsLanded']?.toString() ?? '') ?? 0,
        foulsCommitted: json['foulsCommitted'] is int ? json['foulsCommitted'] : int.tryParse(json['foulsCommitted']?.toString() ?? '') ?? 0,
      );
}

class BoxingRoundScore {
  final int roundNumber;
  final int sideAPoints;
  final int sideBPoints;
  final bool isCompleted;

  const BoxingRoundScore({
    required this.roundNumber,
    this.sideAPoints = 0,
    this.sideBPoints = 0,
    this.isCompleted = false,
  });

  BoxingRoundScore copyWith({
    int? roundNumber,
    int? sideAPoints,
    int? sideBPoints,
    bool? isCompleted,
  }) {
    return BoxingRoundScore(
      roundNumber: roundNumber ?? this.roundNumber,
      sideAPoints: sideAPoints ?? this.sideAPoints,
      sideBPoints: sideBPoints ?? this.sideBPoints,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() => {
        'roundNumber': roundNumber,
        'sideAPoints': sideAPoints,
        'sideBPoints': sideBPoints,
        'isCompleted': isCompleted,
      };

  factory BoxingRoundScore.fromJson(Map<String, dynamic> json) => BoxingRoundScore(
        roundNumber: json['roundNumber'] is int ? json['roundNumber'] : int.tryParse(json['roundNumber']?.toString() ?? '') ?? 1,
        sideAPoints: json['sideAPoints'] is int ? json['sideAPoints'] : int.tryParse(json['sideAPoints']?.toString() ?? '') ?? 0,
        sideBPoints: json['sideBPoints'] is int ? json['sideBPoints'] : int.tryParse(json['sideBPoints']?.toString() ?? '') ?? 0,
        isCompleted: json['isCompleted'] == true || json['isCompleted'] == 1,
      );
}

class BoxingMatchConfig {
  final String format; // 'PROFESSIONAL', 'AMATEUR', 'FRIENDLY'
  final int totalRounds; // 3, 4, 6, 8, 10, 12
  final int roundDurationMinutes; // 1, 2, 3
  final int restDurationSeconds; // 30, 60

  const BoxingMatchConfig({
    this.format = 'PROFESSIONAL',
    this.totalRounds = 12,
    this.roundDurationMinutes = 3,
    this.restDurationSeconds = 60,
  });

  Map<String, dynamic> toJson() => {
        'format': format,
        'totalRounds': totalRounds,
        'roundDurationMinutes': roundDurationMinutes,
        'restDurationSeconds': restDurationSeconds,
      };

  factory BoxingMatchConfig.fromJson(Map<String, dynamic> json) => BoxingMatchConfig(
        format: json['format']?.toString() ?? 'PROFESSIONAL',
        totalRounds: json['totalRounds'] is int ? json['totalRounds'] : int.tryParse(json['totalRounds']?.toString() ?? '') ?? 12,
        roundDurationMinutes: json['roundDurationMinutes'] is int ? json['roundDurationMinutes'] : int.tryParse(json['roundDurationMinutes']?.toString() ?? '') ?? 3,
        restDurationSeconds: json['restDurationSeconds'] is int ? json['restDurationSeconds'] : int.tryParse(json['restDurationSeconds']?.toString() ?? '') ?? 60,
      );
}

class BoxingMatchState {
  final BoxingFighter fighterA; // Red Corner
  final BoxingFighter fighterB; // Blue Corner
  final int sideAPoints;
  final int sideBPoints;
  final int currentRoundIndex;
  final List<BoxingRoundScore> roundScores;
  final bool isRoundActive;
  final bool isRestPeriod;
  final int roundTimeRemaining;
  final bool isMatchFinished;
  final String? stoppageType; // 'KO', 'TKO', 'DQ', 'POINTS'
  final String? winnerSide; // 'fighterA' or 'fighterB' or 'draw'
  final BoxingMatchConfig config;

  const BoxingMatchState({
    required this.fighterA,
    required this.fighterB,
    required this.sideAPoints,
    required this.sideBPoints,
    required this.currentRoundIndex,
    required this.roundScores,
    required this.isRoundActive,
    required this.isRestPeriod,
    required this.roundTimeRemaining,
    required this.isMatchFinished,
    this.stoppageType,
    this.winnerSide,
    required this.config,
  });

  factory BoxingMatchState.initial({
    required BoxingFighter fighterA,
    required BoxingFighter fighterB,
    required BoxingMatchConfig config,
  }) {
    return BoxingMatchState(
      fighterA: fighterA,
      fighterB: fighterB,
      sideAPoints: 0,
      sideBPoints: 0,
      currentRoundIndex: 0,
      roundScores: const [
        BoxingRoundScore(roundNumber: 1, sideAPoints: 0, sideBPoints: 0),
      ],
      isRoundActive: true,
      isRestPeriod: false,
      roundTimeRemaining: config.roundDurationMinutes * 60,
      isMatchFinished: false,
      stoppageType: null,
      winnerSide: null,
      config: config,
    );
  }

  BoxingMatchState copyWith({
    BoxingFighter? fighterA,
    BoxingFighter? fighterB,
    int? sideAPoints,
    int? sideBPoints,
    int? currentRoundIndex,
    List<BoxingRoundScore>? roundScores,
    bool? isRoundActive,
    bool? isRestPeriod,
    int? roundTimeRemaining,
    bool? isMatchFinished,
    String? stoppageType,
    String? winnerSide,
    BoxingMatchConfig? config,
  }) {
    return BoxingMatchState(
      fighterA: fighterA ?? this.fighterA,
      fighterB: fighterB ?? this.fighterB,
      sideAPoints: sideAPoints ?? this.sideAPoints,
      sideBPoints: sideBPoints ?? this.sideBPoints,
      currentRoundIndex: currentRoundIndex ?? this.currentRoundIndex,
      roundScores: roundScores ?? this.roundScores,
      isRoundActive: isRoundActive ?? this.isRoundActive,
      isRestPeriod: isRestPeriod ?? this.isRestPeriod,
      roundTimeRemaining: roundTimeRemaining ?? this.roundTimeRemaining,
      isMatchFinished: isMatchFinished ?? this.isMatchFinished,
      stoppageType: stoppageType ?? this.stoppageType,
      winnerSide: winnerSide ?? this.winnerSide,
      config: config ?? this.config,
    );
  }

  Map<String, dynamic> toJson() => {
        'fighterA': fighterA.toJson(),
        'fighterB': fighterB.toJson(),
        'sideAPoints': sideAPoints,
        'sideBPoints': sideBPoints,
        'currentRoundIndex': currentRoundIndex,
        'roundScores': roundScores.map((r) => r.toJson()).toList(),
        'isRoundActive': isRoundActive,
        'isRestPeriod': isRestPeriod,
        'roundTimeRemaining': roundTimeRemaining,
        'isMatchFinished': isMatchFinished,
        'stoppageType': stoppageType,
        'winnerSide': winnerSide,
        'config': config.toJson(),
      };

  factory BoxingMatchState.fromJson(Map<String, dynamic> json) => BoxingMatchState(
        fighterA: json['fighterA'] != null
            ? BoxingFighter.fromJson(Map<String, dynamic>.from(json['fighterA'] is String ? jsonDecode(json['fighterA']) : json['fighterA']))
            : const BoxingFighter(id: 'a', name: 'Red Corner'),
        fighterB: json['fighterB'] != null
            ? BoxingFighter.fromJson(Map<String, dynamic>.from(json['fighterB'] is String ? jsonDecode(json['fighterB']) : json['fighterB']))
            : const BoxingFighter(id: 'b', name: 'Blue Corner'),
        sideAPoints: json['sideAPoints'] is int ? json['sideAPoints'] : int.tryParse(json['sideAPoints']?.toString() ?? '') ?? 0,
        sideBPoints: json['sideBPoints'] is int ? json['sideBPoints'] : int.tryParse(json['sideBPoints']?.toString() ?? '') ?? 0,
        currentRoundIndex: json['currentRoundIndex'] is int ? json['currentRoundIndex'] : int.tryParse(json['currentRoundIndex']?.toString() ?? '') ?? 0,
        roundScores: (json['roundScores'] as List? ?? [])
            .map((r) => BoxingRoundScore.fromJson(Map<String, dynamic>.from(r is String ? jsonDecode(r) : r)))
            .toList(),
        isRoundActive: json['isRoundActive'] == true || json['isRoundActive'] == 1,
        isRestPeriod: json['isRestPeriod'] == true || json['isRestPeriod'] == 1,
        roundTimeRemaining: json['roundTimeRemaining'] is int ? json['roundTimeRemaining'] : int.tryParse(json['roundTimeRemaining']?.toString() ?? '') ?? 180,
        isMatchFinished: json['isMatchFinished'] == true || json['isMatchFinished'] == 1,
        stoppageType: json['stoppageType']?.toString(),
        winnerSide: json['winnerSide']?.toString(),
        config: json['config'] != null
            ? BoxingMatchConfig.fromJson(Map<String, dynamic>.from(json['config'] is String ? jsonDecode(json['config']) : json['config']))
            : const BoxingMatchConfig(),
      );
}

class BoxingMatchEngine {
  BoxingMatchState _state;
  final List<BoxingMatchState> _history = [];

  BoxingMatchEngine(this._state) {
    _history.add(_state);
  }

  BoxingMatchState get state => _state;

  void addPoint(String scoringSide, [int points = 1]) {
    if (_state.isMatchFinished) return;
    _history.add(_state);

    int newPtsA = _state.sideAPoints;
    int newPtsB = _state.sideBPoints;

    if (scoringSide == 'fighterA') {
      newPtsA += points;
    } else {
      newPtsB += points;
    }

    List<BoxingRoundScore> updatedRounds = List.from(_state.roundScores);
    if (updatedRounds.isNotEmpty) {
      final cur = updatedRounds[_state.currentRoundIndex];
      updatedRounds[_state.currentRoundIndex] = cur.copyWith(
        sideAPoints: cur.sideAPoints + (scoringSide == 'fighterA' ? points : 0),
        sideBPoints: cur.sideBPoints + (scoringSide == 'fighterB' ? points : 0),
      );
    }

    _state = _state.copyWith(
      sideAPoints: newPtsA,
      sideBPoints: newPtsB,
      roundScores: updatedRounds,
    );
  }

  void recordKnockdown(String downSide) {
    if (_state.isMatchFinished) return;
    _history.add(_state);

    BoxingFighter fA = _state.fighterA;
    BoxingFighter fB = _state.fighterB;

    int newPtsA = _state.sideAPoints;
    int newPtsB = _state.sideBPoints;

    if (downSide == 'fighterA') { // Fighter A is knocked down -> Fighter B scores +2 bonus pts!
      fB = fB.copyWith(knockdownsLanded: fB.knockdownsLanded + 1);
      newPtsB += 2;
    } else { // Fighter B is knocked down -> Fighter A scores +2 bonus pts!
      fA = fA.copyWith(knockdownsLanded: fA.knockdownsLanded + 1);
      newPtsA += 2;
    }

    _state = _state.copyWith(
      fighterA: fA,
      fighterB: fB,
      sideAPoints: newPtsA,
      sideBPoints: newPtsB,
    );
  }

  void recordFoul(String foulSide) {
    if (_state.isMatchFinished) return;
    _history.add(_state);

    BoxingFighter fA = _state.fighterA;
    BoxingFighter fB = _state.fighterB;

    int newPtsA = _state.sideAPoints;
    int newPtsB = _state.sideBPoints;

    if (foulSide == 'fighterA') {
      fA = fA.copyWith(foulsCommitted: fA.foulsCommitted + 1);
      newPtsA = (newPtsA - 1) < 0 ? 0 : newPtsA - 1;
    } else {
      fB = fB.copyWith(foulsCommitted: fB.foulsCommitted + 1);
      newPtsB = (newPtsB - 1) < 0 ? 0 : newPtsB - 1;
    }

    _state = _state.copyWith(
      fighterA: fA,
      fighterB: fB,
      sideAPoints: newPtsA,
      sideBPoints: newPtsB,
    );
  }

  void completeRound() {
    if (_state.isMatchFinished) return;
    _history.add(_state);

    List<BoxingRoundScore> updatedRounds = List.from(_state.roundScores);
    if (updatedRounds.isNotEmpty) {
      updatedRounds[_state.currentRoundIndex] = updatedRounds[_state.currentRoundIndex].copyWith(isCompleted: true);
    }

    bool matchEnded = _state.currentRoundIndex + 1 >= _state.config.totalRounds;
    String? winner;
    if (matchEnded) {
      if (_state.sideAPoints > _state.sideBPoints) winner = 'fighterA';
      else if (_state.sideBPoints > _state.sideAPoints) winner = 'fighterB';
      else winner = 'draw';
    }

    _state = _state.copyWith(
      roundScores: updatedRounds,
      isRoundActive: false,
      isRestPeriod: !matchEnded,
      isMatchFinished: matchEnded,
      stoppageType: matchEnded ? 'POINTS DECISION' : null,
      winnerSide: winner,
    );
  }

  void advanceNextRound() {
    if (_state.isMatchFinished) return;
    _history.add(_state);

    final nextIdx = _state.currentRoundIndex + 1;
    final newRounds = List<BoxingRoundScore>.from(_state.roundScores)
      ..add(BoxingRoundScore(roundNumber: nextIdx + 1, sideAPoints: 0, sideBPoints: 0));

    _state = _state.copyWith(
      currentRoundIndex: nextIdx,
      roundScores: newRounds,
      isRoundActive: true,
      isRestPeriod: false,
      roundTimeRemaining: _state.config.roundDurationMinutes * 60,
    );
  }

  void stopMatch(String stoppageType, String winnerSide) {
    _history.add(_state);
    _state = _state.copyWith(
      isMatchFinished: true,
      stoppageType: stoppageType,
      winnerSide: winnerSide,
      isRoundActive: false,
      isRestPeriod: false,
    );
  }

  bool get canUndo => _history.length > 1;

  void undo() {
    if (!canUndo) return;
    _history.removeLast();
    _state = _history.last;
  }
}
