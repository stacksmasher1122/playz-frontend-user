import 'dart:convert';

class Wrestler {
  final String id;
  final String name;
  final String weightClass;
  final int cautions;
  final int highestMoveValue; // For UWW tie-breaker criteria (e.g. 5 > 4 > 2 > 1)

  const Wrestler({
    required this.id,
    required this.name,
    this.weightClass = '74 KG',
    this.cautions = 0,
    this.highestMoveValue = 0,
  });

  Wrestler copyWith({
    String? id,
    String? name,
    String? weightClass,
    int? cautions,
    int? highestMoveValue,
  }) {
    return Wrestler(
      id: id ?? this.id,
      name: name ?? this.name,
      weightClass: weightClass ?? this.weightClass,
      cautions: cautions ?? this.cautions,
      highestMoveValue: highestMoveValue ?? this.highestMoveValue,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'weightClass': weightClass,
        'cautions': cautions,
        'highestMoveValue': highestMoveValue,
      };

  factory Wrestler.fromJson(Map<String, dynamic> json) => Wrestler(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        weightClass: json['weightClass']?.toString() ?? '74 KG',
        cautions: json['cautions'] is int ? json['cautions'] : int.tryParse(json['cautions']?.toString() ?? '') ?? 0,
        highestMoveValue: json['highestMoveValue'] is int ? json['highestMoveValue'] : int.tryParse(json['highestMoveValue']?.toString() ?? '') ?? 0,
      );
}

class WrestlingPeriodScore {
  final int periodNumber;
  final int sideAPoints;
  final int sideBPoints;
  final bool isCompleted;

  const WrestlingPeriodScore({
    required this.periodNumber,
    this.sideAPoints = 0,
    this.sideBPoints = 0,
    this.isCompleted = false,
  });

  WrestlingPeriodScore copyWith({
    int? periodNumber,
    int? sideAPoints,
    int? sideBPoints,
    bool? isCompleted,
  }) {
    return WrestlingPeriodScore(
      periodNumber: periodNumber ?? this.periodNumber,
      sideAPoints: sideAPoints ?? this.sideAPoints,
      sideBPoints: sideBPoints ?? this.sideBPoints,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() => {
        'periodNumber': periodNumber,
        'sideAPoints': sideAPoints,
        'sideBPoints': sideBPoints,
        'isCompleted': isCompleted,
      };

  factory WrestlingPeriodScore.fromJson(Map<String, dynamic> json) => WrestlingPeriodScore(
        periodNumber: json['periodNumber'] is int ? json['periodNumber'] : int.tryParse(json['periodNumber']?.toString() ?? '') ?? 1,
        sideAPoints: json['sideAPoints'] is int ? json['sideAPoints'] : int.tryParse(json['sideAPoints']?.toString() ?? '') ?? 0,
        sideBPoints: json['sideBPoints'] is int ? json['sideBPoints'] : int.tryParse(json['sideBPoints']?.toString() ?? '') ?? 0,
        isCompleted: json['isCompleted'] == true || json['isCompleted'] == 1,
      );
}

class WrestlingMatchConfig {
  final String style; // 'FREESTYLE' or 'GRECO_ROMAN'
  final int totalPeriods; // Default 2
  final int periodDurationMinutes; // Default 3 mins
  final int restDurationSeconds; // Default 30s
  final int techFallDifference; // 10 pts for Freestyle, 8 pts for Greco-Roman

  const WrestlingMatchConfig({
    this.style = 'FREESTYLE',
    this.totalPeriods = 2,
    this.periodDurationMinutes = 3,
    this.restDurationSeconds = 30,
    this.techFallDifference = 10,
  });

  Map<String, dynamic> toJson() => {
        'style': style,
        'totalPeriods': totalPeriods,
        'periodDurationMinutes': periodDurationMinutes,
        'restDurationSeconds': restDurationSeconds,
        'techFallDifference': techFallDifference,
      };

  factory WrestlingMatchConfig.fromJson(Map<String, dynamic> json) => WrestlingMatchConfig(
        style: json['style']?.toString() ?? 'FREESTYLE',
        totalPeriods: json['totalPeriods'] is int ? json['totalPeriods'] : int.tryParse(json['totalPeriods']?.toString() ?? '') ?? 2,
        periodDurationMinutes: json['periodDurationMinutes'] is int ? json['periodDurationMinutes'] : int.tryParse(json['periodDurationMinutes']?.toString() ?? '') ?? 3,
        restDurationSeconds: json['restDurationSeconds'] is int ? json['restDurationSeconds'] : int.tryParse(json['restDurationSeconds']?.toString() ?? '') ?? 30,
        techFallDifference: json['techFallDifference'] is int ? json['techFallDifference'] : int.tryParse(json['techFallDifference']?.toString() ?? '') ?? 10,
      );
}

class WrestlingMatchState {
  final Wrestler wrestlerA; // Red Corner
  final Wrestler wrestlerB; // Blue Corner
  final int sideAPoints;
  final int sideBPoints;
  final int currentPeriodIndex;
  final List<WrestlingPeriodScore> periodScores;
  final bool isPeriodActive;
  final bool isRestPeriod;
  final int periodTimeRemaining;
  final bool isMatchFinished;
  final String? victoryType; // 'VFA (Fall)', 'VSU (Technical Superiority)', 'VPO (Points)'
  final String? winnerSide; // 'wrestlerA', 'wrestlerB', 'draw'
  final String? lastScoredSide; // For UWW tie-break criteria
  final WrestlingMatchConfig config;

  const WrestlingMatchState({
    required this.wrestlerA,
    required this.wrestlerB,
    required this.sideAPoints,
    required this.sideBPoints,
    required this.currentPeriodIndex,
    required this.periodScores,
    required this.isPeriodActive,
    required this.isRestPeriod,
    required this.periodTimeRemaining,
    required this.isMatchFinished,
    this.victoryType,
    this.winnerSide,
    this.lastScoredSide,
    required this.config,
  });

  factory WrestlingMatchState.initial({
    required Wrestler wrestlerA,
    required Wrestler wrestlerB,
    required WrestlingMatchConfig config,
  }) {
    return WrestlingMatchState(
      wrestlerA: wrestlerA,
      wrestlerB: wrestlerB,
      sideAPoints: 0,
      sideBPoints: 0,
      currentPeriodIndex: 0,
      periodScores: const [
        WrestlingPeriodScore(periodNumber: 1, sideAPoints: 0, sideBPoints: 0),
      ],
      isPeriodActive: true,
      isRestPeriod: false,
      periodTimeRemaining: config.periodDurationMinutes * 60,
      isMatchFinished: false,
      victoryType: null,
      winnerSide: null,
      lastScoredSide: null,
      config: config,
    );
  }

  WrestlingMatchState copyWith({
    Wrestler? wrestlerA,
    Wrestler? wrestlerB,
    int? sideAPoints,
    int? sideBPoints,
    int? currentPeriodIndex,
    List<WrestlingPeriodScore>? periodScores,
    bool? isPeriodActive,
    bool? isRestPeriod,
    int? periodTimeRemaining,
    bool? isMatchFinished,
    String? victoryType,
    String? winnerSide,
    String? lastScoredSide,
    WrestlingMatchConfig? config,
  }) {
    return WrestlingMatchState(
      wrestlerA: wrestlerA ?? this.wrestlerA,
      wrestlerB: wrestlerB ?? this.wrestlerB,
      sideAPoints: sideAPoints ?? this.sideAPoints,
      sideBPoints: sideBPoints ?? this.sideBPoints,
      currentPeriodIndex: currentPeriodIndex ?? this.currentPeriodIndex,
      periodScores: periodScores ?? this.periodScores,
      isPeriodActive: isPeriodActive ?? this.isPeriodActive,
      isRestPeriod: isRestPeriod ?? this.isRestPeriod,
      periodTimeRemaining: periodTimeRemaining ?? this.periodTimeRemaining,
      isMatchFinished: isMatchFinished ?? this.isMatchFinished,
      victoryType: victoryType ?? this.victoryType,
      winnerSide: winnerSide ?? this.winnerSide,
      lastScoredSide: lastScoredSide ?? this.lastScoredSide,
      config: config ?? this.config,
    );
  }

  Map<String, dynamic> toJson() => {
        'wrestlerA': wrestlerA.toJson(),
        'wrestlerB': wrestlerB.toJson(),
        'sideAPoints': sideAPoints,
        'sideBPoints': sideBPoints,
        'currentPeriodIndex': currentPeriodIndex,
        'periodScores': periodScores.map((p) => p.toJson()).toList(),
        'isPeriodActive': isPeriodActive,
        'isRestPeriod': isRestPeriod,
        'periodTimeRemaining': periodTimeRemaining,
        'isMatchFinished': isMatchFinished,
        'victoryType': victoryType,
        'winnerSide': winnerSide,
        'lastScoredSide': lastScoredSide,
        'config': config.toJson(),
      };

  factory WrestlingMatchState.fromJson(Map<String, dynamic> json) => WrestlingMatchState(
        wrestlerA: json['wrestlerA'] != null
            ? Wrestler.fromJson(Map<String, dynamic>.from(json['wrestlerA'] is String ? jsonDecode(json['wrestlerA']) : json['wrestlerA']))
            : const Wrestler(id: 'a', name: 'Red Corner'),
        wrestlerB: json['wrestlerB'] != null
            ? Wrestler.fromJson(Map<String, dynamic>.from(json['wrestlerB'] is String ? jsonDecode(json['wrestlerB']) : json['wrestlerB']))
            : const Wrestler(id: 'b', name: 'Blue Corner'),
        sideAPoints: json['sideAPoints'] is int ? json['sideAPoints'] : int.tryParse(json['sideAPoints']?.toString() ?? '') ?? 0,
        sideBPoints: json['sideBPoints'] is int ? json['sideBPoints'] : int.tryParse(json['sideBPoints']?.toString() ?? '') ?? 0,
        currentPeriodIndex: json['currentPeriodIndex'] is int ? json['currentPeriodIndex'] : int.tryParse(json['currentPeriodIndex']?.toString() ?? '') ?? 0,
        periodScores: (json['periodScores'] as List? ?? [])
            .map((p) => WrestlingPeriodScore.fromJson(Map<String, dynamic>.from(p is String ? jsonDecode(p) : p)))
            .toList(),
        isPeriodActive: json['isPeriodActive'] == true || json['isPeriodActive'] == 1,
        isRestPeriod: json['isRestPeriod'] == true || json['isRestPeriod'] == 1,
        periodTimeRemaining: json['periodTimeRemaining'] is int ? json['periodTimeRemaining'] : int.tryParse(json['periodTimeRemaining']?.toString() ?? '') ?? 180,
        isMatchFinished: json['isMatchFinished'] == true || json['isMatchFinished'] == 1,
        victoryType: json['victoryType']?.toString(),
        winnerSide: json['winnerSide']?.toString(),
        lastScoredSide: json['lastScoredSide']?.toString(),
        config: json['config'] != null
            ? WrestlingMatchConfig.fromJson(Map<String, dynamic>.from(json['config'] is String ? jsonDecode(json['config']) : json['config']))
            : const WrestlingMatchConfig(),
      );
}

class WrestlingMatchEngine {
  WrestlingMatchState _state;
  final List<WrestlingMatchState> _history = [];

  WrestlingMatchEngine(this._state) {
    _history.add(_state);
  }

  WrestlingMatchState get state => _state;

  void addPoints(String scoringSide, int points) {
    if (_state.isMatchFinished) return;
    _history.add(_state);

    Wrestler wA = _state.wrestlerA;
    Wrestler wB = _state.wrestlerB;

    int newPtsA = _state.sideAPoints;
    int newPtsB = _state.sideBPoints;

    if (scoringSide == 'wrestlerA') {
      newPtsA += points;
      if (points > wA.highestMoveValue) {
        wA = wA.copyWith(highestMoveValue: points);
      }
    } else {
      newPtsB += points;
      if (points > wB.highestMoveValue) {
        wB = wB.copyWith(highestMoveValue: points);
      }
    }

    List<WrestlingPeriodScore> updatedPeriods = List.from(_state.periodScores);
    if (updatedPeriods.isNotEmpty) {
      final cur = updatedPeriods[_state.currentPeriodIndex];
      updatedPeriods[_state.currentPeriodIndex] = cur.copyWith(
        sideAPoints: cur.sideAPoints + (scoringSide == 'wrestlerA' ? points : 0),
        sideBPoints: cur.sideBPoints + (scoringSide == 'wrestlerB' ? points : 0),
      );
    }

    // UWW Technical Superiority (VSU) check (>=10 pts lead in Freestyle, >=8 pts in Greco-Roman)
    bool techFall = false;
    String? winner;
    int diff = (newPtsA - newPtsB).abs();
    if (diff >= _state.config.techFallDifference) {
      techFall = true;
      winner = newPtsA > newPtsB ? 'wrestlerA' : 'wrestlerB';
    }

    _state = _state.copyWith(
      wrestlerA: wA,
      wrestlerB: wB,
      sideAPoints: newPtsA,
      sideBPoints: newPtsB,
      periodScores: updatedPeriods,
      lastScoredSide: scoringSide,
      isMatchFinished: techFall,
      victoryType: techFall ? 'VSU (Technical Superiority)' : null,
      winnerSide: winner,
    );
  }

  void recordCaution(String foulSide) {
    if (_state.isMatchFinished) return;
    _history.add(_state);

    Wrestler wA = _state.wrestlerA;
    Wrestler wB = _state.wrestlerB;

    int newPtsA = _state.sideAPoints;
    int newPtsB = _state.sideBPoints;
    String? scoringSide;

    if (foulSide == 'wrestlerA') { // Caution to A -> B gets +1 pt
      wA = wA.copyWith(cautions: wA.cautions + 1);
      newPtsB += 1;
      scoringSide = 'wrestlerB';
    } else { // Caution to B -> A gets +1 pt
      wB = wB.copyWith(cautions: wB.cautions + 1);
      newPtsA += 1;
      scoringSide = 'wrestlerA';
    }

    _state = _state.copyWith(
      wrestlerA: wA,
      wrestlerB: wB,
      sideAPoints: newPtsA,
      sideBPoints: newPtsB,
      lastScoredSide: scoringSide,
    );
  }

  void recordFall(String winnerSide) {
    _history.add(_state);
    _state = _state.copyWith(
      isMatchFinished: true,
      victoryType: 'VFA (Victory by Fall / Pin)',
      winnerSide: winnerSide,
      isPeriodActive: false,
      isRestPeriod: false,
    );
  }

  void completePeriod() {
    if (_state.isMatchFinished) return;
    _history.add(_state);

    List<WrestlingPeriodScore> updatedPeriods = List.from(_state.periodScores);
    if (updatedPeriods.isNotEmpty) {
      updatedPeriods[_state.currentPeriodIndex] = updatedPeriods[_state.currentPeriodIndex].copyWith(isCompleted: true);
    }

    bool matchEnded = _state.currentPeriodIndex + 1 >= _state.config.totalPeriods;
    String? winner;
    if (matchEnded) {
      // UWW Criteria Tie-Breaker if points are equal
      if (_state.sideAPoints > _state.sideBPoints) {
        winner = 'wrestlerA';
      } else if (_state.sideBPoints > _state.sideAPoints) {
        winner = 'wrestlerB';
      } else {
        // Tie-breaker 1: Highest value move
        if (_state.wrestlerA.highestMoveValue > _state.wrestlerB.highestMoveValue) {
          winner = 'wrestlerA';
        } else if (_state.wrestlerB.highestMoveValue > _state.wrestlerA.highestMoveValue) {
          winner = 'wrestlerB';
        } else {
          // Tie-breaker 2: Fewest cautions
          if (_state.wrestlerA.cautions < _state.wrestlerB.cautions) {
            winner = 'wrestlerA';
          } else if (_state.wrestlerB.cautions < _state.wrestlerA.cautions) {
            winner = 'wrestlerB';
          } else {
            // Tie-breaker 3: Last scored point
            winner = _state.lastScoredSide ?? 'wrestlerA';
          }
        }
      }
    }

    _state = _state.copyWith(
      periodScores: updatedPeriods,
      isPeriodActive: false,
      isRestPeriod: !matchEnded,
      isMatchFinished: matchEnded,
      victoryType: matchEnded ? 'VPO (Victory by Points)' : null,
      winnerSide: winner,
    );
  }

  void advanceNextPeriod() {
    if (_state.isMatchFinished) return;
    _history.add(_state);

    final nextIdx = _state.currentPeriodIndex + 1;
    final newPeriods = List<WrestlingPeriodScore>.from(_state.periodScores)
      ..add(WrestlingPeriodScore(periodNumber: nextIdx + 1, sideAPoints: 0, sideBPoints: 0));

    _state = _state.copyWith(
      currentPeriodIndex: nextIdx,
      periodScores: newPeriods,
      isPeriodActive: true,
      isRestPeriod: false,
      periodTimeRemaining: _state.config.periodDurationMinutes * 60,
    );
  }

  void stopMatch(String victoryType, String winnerSide) {
    _history.add(_state);
    _state = _state.copyWith(
      isMatchFinished: true,
      victoryType: victoryType,
      winnerSide: winnerSide,
      isPeriodActive: false,
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
