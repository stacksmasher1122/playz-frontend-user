import 'dart:convert';

class KhoKhoPlayer {
  final String id;
  final String name;
  final int number;
  final int batchNumber; // Batch 1, 2, 3...
  final int outsTaken;
  final int pointsScored;

  const KhoKhoPlayer({
    required this.id,
    required this.name,
    this.number = 0,
    this.batchNumber = 1,
    this.outsTaken = 0,
    this.pointsScored = 0,
  });

  KhoKhoPlayer copyWith({
    String? id,
    String? name,
    int? number,
    int? batchNumber,
    int? outsTaken,
    int? pointsScored,
  }) {
    return KhoKhoPlayer(
      id: id ?? this.id,
      name: name ?? this.name,
      number: number ?? this.number,
      batchNumber: batchNumber ?? this.batchNumber,
      outsTaken: outsTaken ?? this.outsTaken,
      pointsScored: pointsScored ?? this.pointsScored,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'number': number,
        'batchNumber': batchNumber,
        'outsTaken': outsTaken,
        'pointsScored': pointsScored,
      };

  factory KhoKhoPlayer.fromJson(Map<String, dynamic> json) => KhoKhoPlayer(
        id: json['id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        number: json['number'] as int? ?? 0,
        batchNumber: json['batchNumber'] as int? ?? 1,
        outsTaken: json['outsTaken'] as int? ?? 0,
        pointsScored: json['pointsScored'] as int? ?? 0,
      );
}

enum KhoKhoEventType { out, poleDive, dreamRun }

class KhoKhoTurnEvent {
  final String team; // 'sideA' or 'sideB'
  final KhoKhoEventType eventType;
  final int points;
  final int turnNumber;
  final String description;

  const KhoKhoTurnEvent({
    required this.team,
    required this.eventType,
    required this.points,
    required this.turnNumber,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
        'team': team,
        'eventType': eventType.name,
        'points': points,
        'turnNumber': turnNumber,
        'description': description,
      };

  factory KhoKhoTurnEvent.fromJson(Map<String, dynamic> json) => KhoKhoTurnEvent(
        team: json['team'] as String? ?? 'sideA',
        eventType: KhoKhoEventType.values.firstWhere(
          (e) => e.name == json['eventType'],
          orElse: () => KhoKhoEventType.out,
        ),
        points: json['points'] as int? ?? 1,
        turnNumber: json['turnNumber'] as int? ?? 1,
        description: json['description'] as String? ?? '',
      );
}

class KhoKhoMatchConfig {
  final int maxTurns; // 4 turns (2 innings)
  final int turnDurationMinutes; // 9m or 7m
  final bool isProRules;
  final int squadLimit;
  final int defendersPerBatch;

  const KhoKhoMatchConfig({
    this.maxTurns = 4,
    this.turnDurationMinutes = 9,
    this.isProRules = true,
    this.squadLimit = 12,
    this.defendersPerBatch = 3,
  });

  Map<String, dynamic> toJson() => {
        'maxTurns': maxTurns,
        'turnDurationMinutes': turnDurationMinutes,
        'isProRules': isProRules,
        'squadLimit': squadLimit,
        'defendersPerBatch': defendersPerBatch,
      };

  factory KhoKhoMatchConfig.fromJson(Map<String, dynamic> json) => KhoKhoMatchConfig(
        maxTurns: json['maxTurns'] as int? ?? 4,
        turnDurationMinutes: json['turnDurationMinutes'] as int? ?? 9,
        isProRules: json['isProRules'] as bool? ?? true,
        squadLimit: json['squadLimit'] as int? ?? 12,
        defendersPerBatch: json['defendersPerBatch'] as int? ?? 3,
      );
}

class KhoKhoMatchState {
  final List<KhoKhoPlayer> teamA;
  final List<KhoKhoPlayer> teamB;
  final int pointsA;
  final int pointsB;
  final int currentTurn; // 1 to 4
  final String activeChasingTeam; // 'sideA' or 'sideB'
  final int currentDefenderBatch; // 1, 2, 3...
  final bool isTurnCompleted;
  final bool isMatchFinished;
  final String? matchWinner;
  final KhoKhoMatchConfig config;
  final List<KhoKhoTurnEvent> turnEvents;

  const KhoKhoMatchState({
    required this.teamA,
    required this.teamB,
    required this.pointsA,
    required this.pointsB,
    required this.currentTurn,
    required this.activeChasingTeam,
    required this.currentDefenderBatch,
    required this.isTurnCompleted,
    required this.isMatchFinished,
    this.matchWinner,
    required this.config,
    required this.turnEvents,
  });

  factory KhoKhoMatchState.initial({
    required List<KhoKhoPlayer> teamA,
    required List<KhoKhoPlayer> teamB,
    required KhoKhoMatchConfig config,
    String activeChasingTeam = 'sideA',
  }) {
    return KhoKhoMatchState(
      teamA: teamA,
      teamB: teamB,
      pointsA: 0,
      pointsB: 0,
      currentTurn: 1,
      activeChasingTeam: activeChasingTeam,
      currentDefenderBatch: 1,
      isTurnCompleted: false,
      isMatchFinished: false,
      matchWinner: null,
      config: config,
      turnEvents: const [],
    );
  }

  KhoKhoMatchState copyWith({
    List<KhoKhoPlayer>? teamA,
    List<KhoKhoPlayer>? teamB,
    int? pointsA,
    int? pointsB,
    int? currentTurn,
    String? activeChasingTeam,
    int? currentDefenderBatch,
    bool? isTurnCompleted,
    bool? isMatchFinished,
    String? matchWinner,
    KhoKhoMatchConfig? config,
    List<KhoKhoTurnEvent>? turnEvents,
  }) {
    return KhoKhoMatchState(
      teamA: teamA ?? this.teamA,
      teamB: teamB ?? this.teamB,
      pointsA: pointsA ?? this.pointsA,
      pointsB: pointsB ?? this.pointsB,
      currentTurn: currentTurn ?? this.currentTurn,
      activeChasingTeam: activeChasingTeam ?? this.activeChasingTeam,
      currentDefenderBatch: currentDefenderBatch ?? this.currentDefenderBatch,
      isTurnCompleted: isTurnCompleted ?? this.isTurnCompleted,
      isMatchFinished: isMatchFinished ?? this.isMatchFinished,
      matchWinner: matchWinner ?? this.matchWinner,
      config: config ?? this.config,
      turnEvents: turnEvents ?? this.turnEvents,
    );
  }

  Map<String, dynamic> toJson() => {
        'teamA': teamA.map((p) => p.toJson()).toList(),
        'teamB': teamB.map((p) => p.toJson()).toList(),
        'pointsA': pointsA,
        'pointsB': pointsB,
        'currentTurn': currentTurn,
        'activeChasingTeam': activeChasingTeam,
        'currentDefenderBatch': currentDefenderBatch,
        'isTurnCompleted': isTurnCompleted,
        'isMatchFinished': isMatchFinished,
        'matchWinner': matchWinner,
        'config': config.toJson(),
        'turnEvents': turnEvents.map((t) => t.toJson()).toList(),
      };

  factory KhoKhoMatchState.fromJson(Map<String, dynamic> json) => KhoKhoMatchState(
        teamA: (json['teamA'] as List? ?? [])
            .map((p) => KhoKhoPlayer.fromJson(p as Map<String, dynamic>))
            .toList(),
        teamB: (json['teamB'] as List? ?? [])
            .map((p) => KhoKhoPlayer.fromJson(p as Map<String, dynamic>))
            .toList(),
        pointsA: json['pointsA'] as int? ?? 0,
        pointsB: json['pointsB'] as int? ?? 0,
        currentTurn: json['currentTurn'] as int? ?? 1,
        activeChasingTeam: json['activeChasingTeam'] as String? ?? 'sideA',
        currentDefenderBatch: json['currentDefenderBatch'] as int? ?? 1,
        isTurnCompleted: json['isTurnCompleted'] as bool? ?? false,
        isMatchFinished: json['isMatchFinished'] as bool? ?? false,
        matchWinner: json['matchWinner'] as String?,
        config: json['config'] != null
            ? KhoKhoMatchConfig.fromJson(json['config'] as Map<String, dynamic>)
            : const KhoKhoMatchConfig(),
        turnEvents: (json['turnEvents'] as List? ?? [])
            .map((t) => KhoKhoTurnEvent.fromJson(t as Map<String, dynamic>))
            .toList(),
      );
}

class KhoKhoMatchEngine {
  KhoKhoMatchState _state;
  final List<KhoKhoMatchState> _history = [];

  KhoKhoMatchEngine(this._state) {
    _history.add(_state);
  }

  KhoKhoMatchState get state => _state;

  void scoreOut(String chasingTeam, {bool isPoleDive = false}) {
    if (_state.isMatchFinished) return;

    _history.add(_state);
    final pts = isPoleDive ? 2 : 1;
    int newPointsA = _state.pointsA;
    int newPointsB = _state.pointsB;

    if (chasingTeam == 'sideA') {
      newPointsA += pts;
    } else {
      newPointsB += pts;
    }

    final newEvent = KhoKhoTurnEvent(
      team: chasingTeam,
      eventType: isPoleDive ? KhoKhoEventType.poleDive : KhoKhoEventType.out,
      points: pts,
      turnNumber: _state.currentTurn,
      description: isPoleDive ? 'Pole Dive (+2 pts)' : 'Defender Out (+1 pt)',
    );

    final newEvents = List<KhoKhoTurnEvent>.from(_state.turnEvents)..add(newEvent);

    _state = _state.copyWith(
      pointsA: newPointsA,
      pointsB: newPointsB,
      turnEvents: newEvents,
    );
  }

  void awardDreamRun(String defendingTeam) {
    if (_state.isMatchFinished) return;

    _history.add(_state);
    int newPointsA = _state.pointsA;
    int newPointsB = _state.pointsB;

    if (defendingTeam == 'sideA') {
      newPointsA += 1;
    } else {
      newPointsB += 1;
    }

    final newEvent = KhoKhoTurnEvent(
      team: defendingTeam,
      eventType: KhoKhoEventType.dreamRun,
      points: 1,
      turnNumber: _state.currentTurn,
      description: 'Dream Run Bonus (+1 pt)',
    );

    final newEvents = List<KhoKhoTurnEvent>.from(_state.turnEvents)..add(newEvent);

    _state = _state.copyWith(
      pointsA: newPointsA,
      pointsB: newPointsB,
      turnEvents: newEvents,
    );
  }

  void advanceTurn() {
    if (_state.isMatchFinished) return;

    _history.add(_state);
    final nextTurn = _state.currentTurn + 1;

    if (nextTurn > _state.config.maxTurns) {
      endMatch();
    } else {
      final nextChaser = _state.activeChasingTeam == 'sideA' ? 'sideB' : 'sideA';
      _state = _state.copyWith(
        currentTurn: nextTurn,
        activeChasingTeam: nextChaser,
        currentDefenderBatch: 1,
        isTurnCompleted: false,
      );
    }
  }

  void completeCurrentTurn() {
    if (_state.isMatchFinished) return;
    _history.add(_state);
    _state = _state.copyWith(
      isTurnCompleted: true,
    );
  }

  void endMatch() {
    _history.add(_state);
    String? winner;
    if (_state.pointsA > _state.pointsB) {
      winner = 'sideA';
    } else if (_state.pointsB > _state.pointsA) {
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
