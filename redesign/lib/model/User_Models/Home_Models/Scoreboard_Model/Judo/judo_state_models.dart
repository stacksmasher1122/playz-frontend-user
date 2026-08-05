import 'dart:convert';

class Judoka {
  final String id;
  final String name;
  final String weightClass;
  final int wazaAriCount; // 0, 1, or 2 (2 = Ippon)
  final int shidoCount; // 0, 1, 2, or 3 (3 = Hansoku-make DQ)
  final bool isIpponAwarded;

  const Judoka({
    required this.id,
    required this.name,
    this.weightClass = 'OPEN',
    this.wazaAriCount = 0,
    this.shidoCount = 0,
    this.isIpponAwarded = false,
  });

  Judoka copyWith({
    String? id,
    String? name,
    String? weightClass,
    int? wazaAriCount,
    int? shidoCount,
    bool? isIpponAwarded,
  }) {
    return Judoka(
      id: id ?? this.id,
      name: name ?? this.name,
      weightClass: weightClass ?? this.weightClass,
      wazaAriCount: wazaAriCount ?? this.wazaAriCount,
      shidoCount: shidoCount ?? this.shidoCount,
      isIpponAwarded: isIpponAwarded ?? this.isIpponAwarded,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'weightClass': weightClass,
        'wazaAriCount': wazaAriCount,
        'shidoCount': shidoCount,
        'isIpponAwarded': isIpponAwarded,
      };

  factory Judoka.fromJson(Map<String, dynamic> json) => Judoka(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        weightClass: json['weightClass']?.toString() ?? 'OPEN',
        wazaAriCount: json['wazaAriCount'] is int ? json['wazaAriCount'] : int.tryParse(json['wazaAriCount']?.toString() ?? '') ?? 0,
        shidoCount: json['shidoCount'] is int ? json['shidoCount'] : int.tryParse(json['shidoCount']?.toString() ?? '') ?? 0,
        isIpponAwarded: json['isIpponAwarded'] == true || json['isIpponAwarded'] == 1,
      );
}

class JudoMatchConfig {
  final String category; // 'SENIOR_4MIN', 'CADET_3MIN', 'CUSTOM'
  final int contestDurationMinutes; // 2, 3, 4, 5
  final bool osaekomiTimerEnabled;

  const JudoMatchConfig({
    this.category = 'SENIOR_4MIN',
    this.contestDurationMinutes = 4,
    this.osaekomiTimerEnabled = true,
  });

  Map<String, dynamic> toJson() => {
        'category': category,
        'contestDurationMinutes': contestDurationMinutes,
        'osaekomiTimerEnabled': osaekomiTimerEnabled,
      };

  factory JudoMatchConfig.fromJson(Map<String, dynamic> json) => JudoMatchConfig(
        category: json['category']?.toString() ?? 'SENIOR_4MIN',
        contestDurationMinutes: json['contestDurationMinutes'] is int ? json['contestDurationMinutes'] : int.tryParse(json['contestDurationMinutes']?.toString() ?? '') ?? 4,
        osaekomiTimerEnabled: json['osaekomiTimerEnabled'] == true || json['osaekomiTimerEnabled'] == 1,
      );
}

class JudoMatchState {
  final Judoka whiteFighter; // WHITE (Judoka A)
  final Judoka blueFighter; // BLUE (Judoka B)
  final int contestTimeRemaining;
  final bool isOsaekomiActive;
  final int osaekomiTime; // in seconds (0..20)
  final String? osaekomiSide; // 'white' or 'blue'
  final bool isGoldenScore;
  final bool isMatchFinished;
  final String? victoryType; // 'IPPON', 'WAZA_ARI_AWASETE_IPPON', 'WAZA_ARI', 'HANSOKU_MAKE', 'GOLDEN_SCORE'
  final String? winnerSide; // 'white', 'blue', 'draw'
  final JudoMatchConfig config;

  const JudoMatchState({
    required this.whiteFighter,
    required this.blueFighter,
    required this.contestTimeRemaining,
    required this.isOsaekomiActive,
    required this.osaekomiTime,
    this.osaekomiSide,
    required this.isGoldenScore,
    required this.isMatchFinished,
    this.victoryType,
    this.winnerSide,
    required this.config,
  });

  factory JudoMatchState.initial({
    required Judoka whiteFighter,
    required Judoka blueFighter,
    required JudoMatchConfig config,
  }) {
    return JudoMatchState(
      whiteFighter: whiteFighter,
      blueFighter: blueFighter,
      contestTimeRemaining: config.contestDurationMinutes * 60,
      isOsaekomiActive: false,
      osaekomiTime: 0,
      osaekomiSide: null,
      isGoldenScore: false,
      isMatchFinished: false,
      victoryType: null,
      winnerSide: null,
      config: config,
    );
  }

  JudoMatchState copyWith({
    Judoka? whiteFighter,
    Judoka? blueFighter,
    int? contestTimeRemaining,
    bool? isOsaekomiActive,
    int? osaekomiTime,
    String? osaekomiSide,
    bool? isGoldenScore,
    bool? isMatchFinished,
    String? victoryType,
    String? winnerSide,
    JudoMatchConfig? config,
  }) {
    return JudoMatchState(
      whiteFighter: whiteFighter ?? this.whiteFighter,
      blueFighter: blueFighter ?? this.blueFighter,
      contestTimeRemaining: contestTimeRemaining ?? this.contestTimeRemaining,
      isOsaekomiActive: isOsaekomiActive ?? this.isOsaekomiActive,
      osaekomiTime: osaekomiTime ?? this.osaekomiTime,
      osaekomiSide: osaekomiSide ?? this.osaekomiSide,
      isGoldenScore: isGoldenScore ?? this.isGoldenScore,
      isMatchFinished: isMatchFinished ?? this.isMatchFinished,
      victoryType: victoryType ?? this.victoryType,
      winnerSide: winnerSide ?? this.winnerSide,
      config: config ?? this.config,
    );
  }

  Map<String, dynamic> toJson() => {
        'whiteFighter': whiteFighter.toJson(),
        'blueFighter': blueFighter.toJson(),
        'contestTimeRemaining': contestTimeRemaining,
        'isOsaekomiActive': isOsaekomiActive,
        'osaekomiTime': osaekomiTime,
        'osaekomiSide': osaekomiSide,
        'isGoldenScore': isGoldenScore,
        'isMatchFinished': isMatchFinished,
        'victoryType': victoryType,
        'winnerSide': winnerSide,
        'config': config.toJson(),
      };

  factory JudoMatchState.fromJson(Map<String, dynamic> json) => JudoMatchState(
        whiteFighter: json['whiteFighter'] != null
            ? Judoka.fromJson(Map<String, dynamic>.from(json['whiteFighter'] is String ? jsonDecode(json['whiteFighter']) : json['whiteFighter']))
            : const Judoka(id: 'white', name: 'WHITE Corner'),
        blueFighter: json['blueFighter'] != null
            ? Judoka.fromJson(Map<String, dynamic>.from(json['blueFighter'] is String ? jsonDecode(json['blueFighter']) : json['blueFighter']))
            : const Judoka(id: 'blue', name: 'BLUE Corner'),
        contestTimeRemaining: json['contestTimeRemaining'] is int ? json['contestTimeRemaining'] : int.tryParse(json['contestTimeRemaining']?.toString() ?? '') ?? 240,
        isOsaekomiActive: json['isOsaekomiActive'] == true || json['isOsaekomiActive'] == 1,
        osaekomiTime: json['osaekomiTime'] is int ? json['osaekomiTime'] : int.tryParse(json['osaekomiTime']?.toString() ?? '') ?? 0,
        osaekomiSide: json['osaekomiSide']?.toString(),
        isGoldenScore: json['isGoldenScore'] == true || json['isGoldenScore'] == 1,
        isMatchFinished: json['isMatchFinished'] == true || json['isMatchFinished'] == 1,
        victoryType: json['victoryType']?.toString(),
        winnerSide: json['winnerSide']?.toString(),
        config: json['config'] != null
            ? JudoMatchConfig.fromJson(Map<String, dynamic>.from(json['config'] is String ? jsonDecode(json['config']) : json['config']))
            : const JudoMatchConfig(),
      );
}

class JudoMatchEngine {
  JudoMatchState _state;
  final List<JudoMatchState> _history = [];

  JudoMatchEngine(this._state) {
    _history.add(_state);
  }

  JudoMatchState get state => _state;

  void scoreIppon(String scoringSide) {
    if (_state.isMatchFinished) return;
    _history.add(_state);

    Judoka white = _state.whiteFighter;
    Judoka blue = _state.blueFighter;

    if (scoringSide == 'white') {
      white = white.copyWith(isIpponAwarded: true);
    } else {
      blue = blue.copyWith(isIpponAwarded: true);
    }

    _state = _state.copyWith(
      whiteFighter: white,
      blueFighter: blue,
      isMatchFinished: true,
      victoryType: 'IPPON (Full Technical Victory)',
      winnerSide: scoringSide,
      isOsaekomiActive: false,
    );
  }

  void scoreWazaAri(String scoringSide) {
    if (_state.isMatchFinished) return;
    _history.add(_state);

    Judoka white = _state.whiteFighter;
    Judoka blue = _state.blueFighter;
    bool isFinished = false;
    String? victoryType;
    String? winner;

    if (scoringSide == 'white') {
      int newWaza = white.wazaAriCount + 1;
      if (newWaza >= 2) {
        // Waza-ari awasete Ippon (2 Waza-ari = Ippon)
        isFinished = true;
        victoryType = 'WAZA-ARI AWASETE IPPON (2 Waza-Ari)';
        winner = 'white';
        white = white.copyWith(wazaAriCount: 2, isIpponAwarded: true);
      } else {
        white = white.copyWith(wazaAriCount: newWaza);
        if (_state.isGoldenScore) {
          isFinished = true;
          victoryType = 'WAZA-ARI (Golden Score)';
          winner = 'white';
        }
      }
    } else {
      int newWaza = blue.wazaAriCount + 1;
      if (newWaza >= 2) {
        // Waza-ari awasete Ippon (2 Waza-ari = Ippon)
        isFinished = true;
        victoryType = 'WAZA-ARI AWASETE IPPON (2 Waza-Ari)';
        winner = 'blue';
        blue = blue.copyWith(wazaAriCount: 2, isIpponAwarded: true);
      } else {
        blue = blue.copyWith(wazaAriCount: newWaza);
        if (_state.isGoldenScore) {
          isFinished = true;
          victoryType = 'WAZA-ARI (Golden Score)';
          winner = 'blue';
        }
      }
    }

    _state = _state.copyWith(
      whiteFighter: white,
      blueFighter: blue,
      isMatchFinished: isFinished,
      victoryType: victoryType,
      winnerSide: winner,
    );
  }

  void startOsaekomi(String pinSide) {
    if (_state.isMatchFinished || _state.isOsaekomiActive) return;
    _history.add(_state);

    _state = _state.copyWith(
      isOsaekomiActive: true,
      osaekomiTime: 0,
      osaekomiSide: pinSide,
    );
  }

  void tickOsaekomi() {
    if (!_state.isOsaekomiActive || _state.isMatchFinished) return;

    int newTime = _state.osaekomiTime + 1;
    String? pinSide = _state.osaekomiSide;

    if (newTime >= 20) {
      // 20 Seconds Osaekomi = IPPON!
      _state = _state.copyWith(osaekomiTime: 20);
      if (pinSide != null) {
        scoreIppon(pinSide);
      }
    } else {
      _state = _state.copyWith(osaekomiTime: newTime);
    }
  }

  void stopOsaekomiToketa() { // Toketa (Break / Release)
    if (!_state.isOsaekomiActive) return;
    _history.add(_state);

    int seconds = _state.osaekomiTime;
    String? side = _state.osaekomiSide;

    _state = _state.copyWith(
      isOsaekomiActive: false,
      osaekomiTime: 0,
      osaekomiSide: null,
    );

    // 10 to 19 seconds = Waza-Ari!
    if (seconds >= 10 && seconds < 20 && side != null) {
      scoreWazaAri(side);
    }
  }

  void recordShido(String foulSide) {
    if (_state.isMatchFinished) return;
    _history.add(_state);

    Judoka white = _state.whiteFighter;
    Judoka blue = _state.blueFighter;
    bool isFinished = false;
    String? victoryType;
    String? winner;

    if (foulSide == 'white') {
      int newShido = white.shidoCount + 1;
      if (newShido >= 3) {
        // 3 Shido = Hansoku-make (Disqualification)
        isFinished = true;
        victoryType = 'HANSOKU-MAKE (3 Shido Disqualification)';
        winner = 'blue';
        newShido = 3;
      }
      white = white.copyWith(shidoCount: newShido);
    } else {
      int newShido = blue.shidoCount + 1;
      if (newShido >= 3) {
        isFinished = true;
        victoryType = 'HANSOKU-MAKE (3 Shido Disqualification)';
        winner = 'white';
        newShido = 3;
      }
      blue = blue.copyWith(shidoCount: newShido);
    }

    _state = _state.copyWith(
      whiteFighter: white,
      blueFighter: blue,
      isMatchFinished: isFinished,
      victoryType: victoryType,
      winnerSide: winner,
    );
  }

  void recordHansokuMake(String dqSide) {
    _history.add(_state);
    final winner = dqSide == 'white' ? 'blue' : 'white';
    _state = _state.copyWith(
      isMatchFinished: true,
      victoryType: 'HANSOKU-MAKE (Direct Disqualification)',
      winnerSide: winner,
    );
  }

  void finishContest() {
    if (_state.isMatchFinished) return;
    _history.add(_state);

    final wWaza = _state.whiteFighter.wazaAriCount;
    final bWaza = _state.blueFighter.wazaAriCount;

    String? winner;
    String victoryType = 'POINTS DECISION';

    if (wWaza > bWaza) {
      winner = 'white';
      victoryType = 'WAZA-ARI ADVANTAGE';
    } else if (bWaza > wWaza) {
      winner = 'blue';
      victoryType = 'WAZA-ARI ADVANTAGE';
    } else {
      // Tied scores -> Golden Score Mode
      _state = _state.copyWith(
        isGoldenScore: true,
        victoryType: 'GOLDEN SCORE (Sudden Death)',
      );
      return;
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
