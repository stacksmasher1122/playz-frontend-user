import 'dart:convert';

class Karateka {
  final String id;
  final String name;
  final String weightClass;
  final int penaltiesCount; // 0=None, 1=Chui 1, 2=Chui 2, 3=Hansoku-Chui, 4=Hansoku (DQ)
  final bool hasSenshu;

  const Karateka({
    required this.id,
    required this.name,
    this.weightClass = 'OPEN',
    this.penaltiesCount = 0,
    this.hasSenshu = false,
  });

  Karateka copyWith({
    String? id,
    String? name,
    String? weightClass,
    int? penaltiesCount,
    bool? hasSenshu,
  }) {
    return Karateka(
      id: id ?? this.id,
      name: name ?? this.name,
      weightClass: weightClass ?? this.weightClass,
      penaltiesCount: penaltiesCount ?? this.penaltiesCount,
      hasSenshu: hasSenshu ?? this.hasSenshu,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'weightClass': weightClass,
        'penaltiesCount': penaltiesCount,
        'hasSenshu': hasSenshu,
      };

  factory Karateka.fromJson(Map<String, dynamic> json) => Karateka(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        weightClass: json['weightClass']?.toString() ?? 'OPEN',
        penaltiesCount: json['penaltiesCount'] is int ? json['penaltiesCount'] : int.tryParse(json['penaltiesCount']?.toString() ?? '') ?? 0,
        hasSenshu: json['hasSenshu'] == true || json['hasSenshu'] == 1,
      );
}

class KarateMatchConfig {
  final String category; // 'SENIOR_3MIN', 'JUNIOR_2MIN', 'CUSTOM'
  final int boutDurationMinutes; // 1, 2, 3, 4
  final bool senshuRuleEnabled; // First point advantage
  final int maxLeadSuperiority; // Default 8 pts

  const KarateMatchConfig({
    this.category = 'SENIOR_3MIN',
    this.boutDurationMinutes = 3,
    this.senshuRuleEnabled = true,
    this.maxLeadSuperiority = 8,
  });

  Map<String, dynamic> toJson() => {
        'category': category,
        'boutDurationMinutes': boutDurationMinutes,
        'senshuRuleEnabled': senshuRuleEnabled,
        'maxLeadSuperiority': maxLeadSuperiority,
      };

  factory KarateMatchConfig.fromJson(Map<String, dynamic> json) => KarateMatchConfig(
        category: json['category']?.toString() ?? 'SENIOR_3MIN',
        boutDurationMinutes: json['boutDurationMinutes'] is int ? json['boutDurationMinutes'] : int.tryParse(json['boutDurationMinutes']?.toString() ?? '') ?? 3,
        senshuRuleEnabled: json['senshuRuleEnabled'] == true || json['senshuRuleEnabled'] == 1,
        maxLeadSuperiority: json['maxLeadSuperiority'] is int ? json['maxLeadSuperiority'] : int.tryParse(json['maxLeadSuperiority']?.toString() ?? '') ?? 8,
      );
}

class KarateMatchState {
  final Karateka akaFighter; // AKA (Red Corner)
  final Karateka aoFighter; // AO (Blue Corner)
  final int sideAPoints;
  final int sideBPoints;
  final String? senshuSide; // 'aka' or 'ao'
  final int boutTimeRemaining;
  final bool isMatchFinished;
  final String? victoryType; // 'SUPERIORITY_8PT', 'SENSHU_ADVANTAGE', 'HANSOKU_DQ', 'POINTS'
  final String? winnerSide; // 'aka', 'ao', 'draw'
  final KarateMatchConfig config;

  const KarateMatchState({
    required this.akaFighter,
    required this.aoFighter,
    required this.sideAPoints,
    required this.sideBPoints,
    this.senshuSide,
    required this.boutTimeRemaining,
    required this.isMatchFinished,
    this.victoryType,
    this.winnerSide,
    required this.config,
  });

  factory KarateMatchState.initial({
    required Karateka akaFighter,
    required Karateka aoFighter,
    required KarateMatchConfig config,
  }) {
    return KarateMatchState(
      akaFighter: akaFighter,
      aoFighter: aoFighter,
      sideAPoints: 0,
      sideBPoints: 0,
      senshuSide: null,
      boutTimeRemaining: config.boutDurationMinutes * 60,
      isMatchFinished: false,
      victoryType: null,
      winnerSide: null,
      config: config,
    );
  }

  KarateMatchState copyWith({
    Karateka? akaFighter,
    Karateka? aoFighter,
    int? sideAPoints,
    int? sideBPoints,
    String? senshuSide,
    int? boutTimeRemaining,
    bool? isMatchFinished,
    String? victoryType,
    String? winnerSide,
    KarateMatchConfig? config,
  }) {
    return KarateMatchState(
      akaFighter: akaFighter ?? this.akaFighter,
      aoFighter: aoFighter ?? this.aoFighter,
      sideAPoints: sideAPoints ?? this.sideAPoints,
      sideBPoints: sideBPoints ?? this.sideBPoints,
      senshuSide: senshuSide ?? this.senshuSide,
      boutTimeRemaining: boutTimeRemaining ?? this.boutTimeRemaining,
      isMatchFinished: isMatchFinished ?? this.isMatchFinished,
      victoryType: victoryType ?? this.victoryType,
      winnerSide: winnerSide ?? this.winnerSide,
      config: config ?? this.config,
    );
  }

  Map<String, dynamic> toJson() => {
        'akaFighter': akaFighter.toJson(),
        'aoFighter': aoFighter.toJson(),
        'sideAPoints': sideAPoints,
        'sideBPoints': sideBPoints,
        'senshuSide': senshuSide,
        'boutTimeRemaining': boutTimeRemaining,
        'isMatchFinished': isMatchFinished,
        'victoryType': victoryType,
        'winnerSide': winnerSide,
        'config': config.toJson(),
      };

  factory KarateMatchState.fromJson(Map<String, dynamic> json) => KarateMatchState(
        akaFighter: json['akaFighter'] != null
            ? Karateka.fromJson(Map<String, dynamic>.from(json['akaFighter'] is String ? jsonDecode(json['akaFighter']) : json['akaFighter']))
            : const Karateka(id: 'aka', name: 'AKA (Red)'),
        aoFighter: json['aoFighter'] != null
            ? Karateka.fromJson(Map<String, dynamic>.from(json['aoFighter'] is String ? jsonDecode(json['aoFighter']) : json['aoFighter']))
            : const Karateka(id: 'ao', name: 'AO (Blue)'),
        sideAPoints: json['sideAPoints'] is int ? json['sideAPoints'] : int.tryParse(json['sideAPoints']?.toString() ?? '') ?? 0,
        sideBPoints: json['sideBPoints'] is int ? json['sideBPoints'] : int.tryParse(json['sideBPoints']?.toString() ?? '') ?? 0,
        senshuSide: json['senshuSide']?.toString(),
        boutTimeRemaining: json['boutTimeRemaining'] is int ? json['boutTimeRemaining'] : int.tryParse(json['boutTimeRemaining']?.toString() ?? '') ?? 180,
        isMatchFinished: json['isMatchFinished'] == true || json['isMatchFinished'] == 1,
        victoryType: json['victoryType']?.toString(),
        winnerSide: json['winnerSide']?.toString(),
        config: json['config'] != null
            ? KarateMatchConfig.fromJson(Map<String, dynamic>.from(json['config'] is String ? jsonDecode(json['config']) : json['config']))
            : const KarateMatchConfig(),
      );
}

class KarateMatchEngine {
  KarateMatchState _state;
  final List<KarateMatchState> _history = [];

  KarateMatchEngine(this._state) {
    _history.add(_state);
  }

  KarateMatchState get state => _state;

  void scoreYuko(String scoringSide) => scorePoints(scoringSide, 1);
  void scoreWazaAri(String scoringSide) => scorePoints(scoringSide, 2);
  void scoreIppon(String scoringSide) => scorePoints(scoringSide, 3);

  void scorePoints(String scoringSide, int points) { // +1 Yuko, +2 Waza-Ari, +3 Ippon
    if (_state.isMatchFinished) return;
    _history.add(_state);

    int newPtsA = _state.sideAPoints;
    int newPtsB = _state.sideBPoints;
    String? newSenshu = _state.senshuSide;

    Karateka aka = _state.akaFighter;
    Karateka ao = _state.aoFighter;

    if (scoringSide == 'aka') {
      newPtsA += points;
    } else {
      newPtsB += points;
    }

    // Award SENSHU (First uncontested point advantage) if no senshu awarded yet
    if (newSenshu == null && _state.config.senshuRuleEnabled) {
      if (scoringSide == 'aka' && aka.penaltiesCount == 0) {
        newSenshu = 'aka';
        aka = aka.copyWith(hasSenshu: true);
      } else if (scoringSide == 'ao' && ao.penaltiesCount == 0) {
        newSenshu = 'ao';
        ao = ao.copyWith(hasSenshu: true);
      }
    }

    // WKF 8-Point Lead Superiority Check (e.g. 8-0, 9-1)
    bool superiority = false;
    String? winner;
    int diff = (newPtsA - newPtsB).abs();
    if (diff >= _state.config.maxLeadSuperiority) {
      superiority = true;
      winner = newPtsA > newPtsB ? 'aka' : 'ao';
    }

    _state = _state.copyWith(
      akaFighter: aka,
      aoFighter: ao,
      sideAPoints: newPtsA,
      sideBPoints: newPtsB,
      senshuSide: newSenshu,
      isMatchFinished: superiority,
      victoryType: superiority ? 'SUPERIORITY_8PT (Lead Advantage)' : null,
      winnerSide: winner,
    );
  }

  void recordPenalty(String foulSide) {
    if (_state.isMatchFinished) return;
    _history.add(_state);

    Karateka aka = _state.akaFighter;
    Karateka ao = _state.aoFighter;
    bool dq = false;
    String? winner;

    if (foulSide == 'aka') {
      int newCount = aka.penaltiesCount + 1;
      if (newCount >= 4) { // Hansoku (Disqualification)
        dq = true;
        winner = 'ao';
        newCount = 4;
      }
      aka = aka.copyWith(penaltiesCount: newCount);
    } else {
      int newCount = ao.penaltiesCount + 1;
      if (newCount >= 4) { // Hansoku (Disqualification)
        dq = true;
        winner = 'aka';
        newCount = 4;
      }
      ao = ao.copyWith(penaltiesCount: newCount);
    }

    _state = _state.copyWith(
      akaFighter: aka,
      aoFighter: ao,
      isMatchFinished: dq,
      victoryType: dq ? 'HANSOKU (Disqualification)' : null,
      winnerSide: winner,
    );
  }

  void recordDisqualification(String dqSide) {
    _history.add(_state);
    final winner = dqSide == 'aka' ? 'ao' : 'aka';
    _state = _state.copyWith(
      isMatchFinished: true,
      victoryType: 'HANSOKU (Disqualification)',
      winnerSide: winner,
    );
  }

  void finishBout() {
    if (_state.isMatchFinished) return;
    _history.add(_state);

    String? winner;
    String victoryType = 'POINTS DECISION';

    if (_state.sideAPoints > _state.sideBPoints) {
      winner = 'aka';
    } else if (_state.sideBPoints > _state.sideAPoints) {
      winner = 'ao';
    } else {
      // Points are tied (e.g. 3-3): Senshu tie-breaker rule applies!
      if (_state.senshuSide != null) {
        winner = _state.senshuSide;
        victoryType = 'SENSHU ADVANTAGE (First Point)';
      } else {
        winner = 'draw';
      }
    }

    _state = _state.copyWith(
      isMatchFinished: true,
      victoryType: victoryType,
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

  bool get canUndo => _history.length > 1;

  void undo() {
    if (!canUndo) return;
    _history.removeLast();
    _state = _history.last;
  }
}
