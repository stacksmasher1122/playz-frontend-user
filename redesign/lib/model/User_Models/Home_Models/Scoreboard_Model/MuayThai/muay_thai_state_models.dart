import 'dart:convert';

class NakMuay {
  final String id;
  final String name;
  final String weightClass;
  final int knockdownsCount;
  final int foulsCount;

  const NakMuay({
    required this.id,
    required this.name,
    this.weightClass = 'OPEN',
    this.knockdownsCount = 0,
    this.foulsCount = 0,
  });

  NakMuay copyWith({
    String? id,
    String? name,
    String? weightClass,
    int? knockdownsCount,
    int? foulsCount,
  }) {
    return NakMuay(
      id: id ?? this.id,
      name: name ?? this.name,
      weightClass: weightClass ?? this.weightClass,
      knockdownsCount: knockdownsCount ?? this.knockdownsCount,
      foulsCount: foulsCount ?? this.foulsCount,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'weightClass': weightClass,
        'knockdownsCount': knockdownsCount,
        'foulsCount': foulsCount,
      };

  factory NakMuay.fromJson(Map<String, dynamic> json) => NakMuay(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        weightClass: json['weightClass']?.toString() ?? 'OPEN',
        knockdownsCount: json['knockdownsCount'] is int ? json['knockdownsCount'] : int.tryParse(json['knockdownsCount']?.toString() ?? '') ?? 0,
        foulsCount: json['foulsCount'] is int ? json['foulsCount'] : int.tryParse(json['foulsCount']?.toString() ?? '') ?? 0,
      );
}

class MuayThaiRoundScore {
  final int roundNumber;
  final int scoreA; // 10, 9, 8, 7
  final int scoreB; // 10, 9, 8, 7

  const MuayThaiRoundScore({
    required this.roundNumber,
    required this.scoreA,
    required this.scoreB,
  });

  Map<String, dynamic> toJson() => {
        'roundNumber': roundNumber,
        'scoreA': scoreA,
        'scoreB': scoreB,
      };

  factory MuayThaiRoundScore.fromJson(Map<String, dynamic> json) => MuayThaiRoundScore(
        roundNumber: json['roundNumber'] is int ? json['roundNumber'] : int.tryParse(json['roundNumber']?.toString() ?? '') ?? 1,
        scoreA: json['scoreA'] is int ? json['scoreA'] : int.tryParse(json['scoreA']?.toString() ?? '') ?? 10,
        scoreB: json['scoreB'] is int ? json['scoreB'] : int.tryParse(json['scoreB']?.toString() ?? '') ?? 9,
      );
}

class MuayThaiMatchConfig {
  final String format; // 'STADIUM_5x3MIN', 'AMATEUR_3x3MIN', 'CUSTOM'
  final int totalRounds; // 3, 5
  final int roundDurationMinutes; // 2, 3
  final int restDurationSeconds; // 60, 120

  const MuayThaiMatchConfig({
    this.format = 'STADIUM_5x3MIN',
    this.totalRounds = 5,
    this.roundDurationMinutes = 3,
    this.restDurationSeconds = 60,
  });

  Map<String, dynamic> toJson() => {
        'format': format,
        'totalRounds': totalRounds,
        'roundDurationMinutes': roundDurationMinutes,
        'restDurationSeconds': restDurationSeconds,
      };

  factory MuayThaiMatchConfig.fromJson(Map<String, dynamic> json) => MuayThaiMatchConfig(
        format: json['format']?.toString() ?? 'STADIUM_5x3MIN',
        totalRounds: json['totalRounds'] is int ? json['totalRounds'] : int.tryParse(json['totalRounds']?.toString() ?? '') ?? 5,
        roundDurationMinutes: json['roundDurationMinutes'] is int ? json['roundDurationMinutes'] : int.tryParse(json['roundDurationMinutes']?.toString() ?? '') ?? 3,
        restDurationSeconds: json['restDurationSeconds'] is int ? json['restDurationSeconds'] : int.tryParse(json['restDurationSeconds']?.toString() ?? '') ?? 60,
      );
}

class MuayThaiMatchState {
  final NakMuay fighterA; // RED Corner
  final NakMuay fighterB; // BLUE Corner
  final int currentRound;
  final bool isRestTime;
  final int roundTimeRemaining;
  final int restTimeRemaining;
  final List<MuayThaiRoundScore> roundScores;
  final bool isMatchFinished;
  final String? victoryType; // 'KO', 'TKO', 'RSC', 'DECISION', 'DQ', 'NC'
  final String? winnerSide; // 'fighterA', 'fighterB', 'draw'
  final MuayThaiMatchConfig config;

  const MuayThaiMatchState({
    required this.fighterA,
    required this.fighterB,
    required this.currentRound,
    required this.isRestTime,
    required this.roundTimeRemaining,
    required this.restTimeRemaining,
    required this.roundScores,
    required this.isMatchFinished,
    this.victoryType,
    this.winnerSide,
    required this.config,
  });

  factory MuayThaiMatchState.initial({
    required NakMuay fighterA,
    required NakMuay fighterB,
    required MuayThaiMatchConfig config,
  }) {
    return MuayThaiMatchState(
      fighterA: fighterA,
      fighterB: fighterB,
      currentRound: 1,
      isRestTime: false,
      roundTimeRemaining: config.roundDurationMinutes * 60,
      restTimeRemaining: config.restDurationSeconds,
      roundScores: const [],
      isMatchFinished: false,
      victoryType: null,
      winnerSide: null,
      config: config,
    );
  }

  int get totalScoreA => roundScores.fold(0, (sum, r) => sum + r.scoreA);
  int get totalScoreB => roundScores.fold(0, (sum, r) => sum + r.scoreB);

  MuayThaiMatchState copyWith({
    NakMuay? fighterA,
    NakMuay? fighterB,
    int? currentRound,
    bool? isRestTime,
    int? roundTimeRemaining,
    int? restTimeRemaining,
    List<MuayThaiRoundScore>? roundScores,
    bool? isMatchFinished,
    String? victoryType,
    String? winnerSide,
    MuayThaiMatchConfig? config,
  }) {
    return MuayThaiMatchState(
      fighterA: fighterA ?? this.fighterA,
      fighterB: fighterB ?? this.fighterB,
      currentRound: currentRound ?? this.currentRound,
      isRestTime: isRestTime ?? this.isRestTime,
      roundTimeRemaining: roundTimeRemaining ?? this.roundTimeRemaining,
      restTimeRemaining: restTimeRemaining ?? this.restTimeRemaining,
      roundScores: roundScores ?? this.roundScores,
      isMatchFinished: isMatchFinished ?? this.isMatchFinished,
      victoryType: victoryType ?? this.victoryType,
      winnerSide: winnerSide ?? this.winnerSide,
      config: config ?? this.config,
    );
  }

  Map<String, dynamic> toJson() => {
        'fighterA': fighterA.toJson(),
        'fighterB': fighterB.toJson(),
        'currentRound': currentRound,
        'isRestTime': isRestTime,
        'roundTimeRemaining': roundTimeRemaining,
        'restTimeRemaining': restTimeRemaining,
        'roundScores': roundScores.map((r) => r.toJson()).toList(),
        'isMatchFinished': isMatchFinished,
        'victoryType': victoryType,
        'winnerSide': winnerSide,
        'config': config.toJson(),
      };

  factory MuayThaiMatchState.fromJson(Map<String, dynamic> json) => MuayThaiMatchState(
        fighterA: json['fighterA'] != null
            ? NakMuay.fromJson(Map<String, dynamic>.from(json['fighterA'] is String ? jsonDecode(json['fighterA']) : json['fighterA']))
            : const NakMuay(id: 'red', name: 'RED Corner'),
        fighterB: json['fighterB'] != null
            ? NakMuay.fromJson(Map<String, dynamic>.from(json['fighterB'] is String ? jsonDecode(json['fighterB']) : json['fighterB']))
            : const NakMuay(id: 'blue', name: 'BLUE Corner'),
        currentRound: json['currentRound'] is int ? json['currentRound'] : int.tryParse(json['currentRound']?.toString() ?? '') ?? 1,
        isRestTime: json['isRestTime'] == true || json['isRestTime'] == 1,
        roundTimeRemaining: json['roundTimeRemaining'] is int ? json['roundTimeRemaining'] : int.tryParse(json['roundTimeRemaining']?.toString() ?? '') ?? 180,
        restTimeRemaining: json['restTimeRemaining'] is int ? json['restTimeRemaining'] : int.tryParse(json['restTimeRemaining']?.toString() ?? '') ?? 60,
        roundScores: json['roundScores'] != null
            ? (json['roundScores'] as List).map((r) => MuayThaiRoundScore.fromJson(Map<String, dynamic>.from(r is String ? jsonDecode(r) : r))).toList()
            : const [],
        isMatchFinished: json['isMatchFinished'] == true || json['isMatchFinished'] == 1,
        victoryType: json['victoryType']?.toString(),
        winnerSide: json['winnerSide']?.toString(),
        config: json['config'] != null
            ? MuayThaiMatchConfig.fromJson(Map<String, dynamic>.from(json['config'] is String ? jsonDecode(json['config']) : json['config']))
            : const MuayThaiMatchConfig(),
      );
}

class MuayThaiMatchEngine {
  MuayThaiMatchState _state;
  final List<MuayThaiMatchState> _history = [];

  MuayThaiMatchEngine(this._state);

  MuayThaiMatchState get state => _state;

  bool get canUndo => _history.isNotEmpty;

  void undo() {
    if (!canUndo) return;
    _state = _history.removeLast();
  }

  void scoreRound(int scoreA, int scoreB) {
    if (_state.isMatchFinished) return;
    _history.add(_state);

    final updatedScores = List<MuayThaiRoundScore>.from(_state.roundScores)
      ..add(MuayThaiRoundScore(
        roundNumber: _state.currentRound,
        scoreA: scoreA,
        scoreB: scoreB,
      ));

    if (_state.currentRound >= _state.config.totalRounds) {
      // Bout Complete
      int totA = updatedScores.fold(0, (sum, r) => sum + r.scoreA);
      int totB = updatedScores.fold(0, (sum, r) => sum + r.scoreB);

      String? winner;
      if (totA > totB) {
        winner = 'fighterA';
      } else if (totB > totA) {
        winner = 'fighterB';
      } else {
        winner = 'draw';
      }

      _state = _state.copyWith(
        roundScores: updatedScores,
        isMatchFinished: true,
        victoryType: 'DECISION ($totA - $totB)',
        winnerSide: winner,
      );
    } else {
      // Enter Rest Break
      _state = _state.copyWith(
        roundScores: updatedScores,
        isRestTime: true,
        restTimeRemaining: _state.config.restDurationSeconds,
      );
    }
  }

  void recordKnockdown(String side) {
    if (_state.isMatchFinished) return;
    _history.add(_state);

    if (side == 'fighterA') {
      _state = _state.copyWith(
        fighterA: _state.fighterA.copyWith(knockdownsCount: _state.fighterA.knockdownsCount + 1),
      );
    } else {
      _state = _state.copyWith(
        fighterB: _state.fighterB.copyWith(knockdownsCount: _state.fighterB.knockdownsCount + 1),
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

  void stopMatch(String victoryType, String winnerSide) {
    _history.add(_state);
    _state = _state.copyWith(
      isMatchFinished: true,
      victoryType: victoryType,
      winnerSide: winnerSide,
    );
  }
}
