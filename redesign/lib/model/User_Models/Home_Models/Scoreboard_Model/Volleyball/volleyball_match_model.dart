import 'dart:convert';

List<Map<String, dynamic>> _toMaps(dynamic value) {
  if (value == null) return [];
  if (value is String) {
    try {
      final decoded = jsonDecode(value);
      if (decoded is List) {
        return decoded.map((item) => Map<String, dynamic>.from(item)).toList();
      }
    } catch (_) {}
  }
  if (value is List) {
    return value.map((item) => Map<String, dynamic>.from(item)).toList();
  }
  return [];
}

Map<String, dynamic> _toMap(dynamic value) {
  if (value == null) return {};
  if (value is String) {
    try {
      return Map<String, dynamic>.from(jsonDecode(value));
    } catch (_) {
      return {};
    }
  }
  if (value is Map) {
    return Map<String, dynamic>.from(value);
  }
  return {};
}

class VolleyballMatchModel {
  final String matchId;
  final String createdBy;
  final String matchName;
  final String tournament;
  final String date;
  final String time;
  final String venue;
  final String court;
  final String referee;
  final String assistantReferee;
  final String category;
  final String format;
  final int pointsPerSet;
  final int finalSetPoints;
  final int timeouts;
  final int substitutions;
  final bool technicalTimeout;
  final bool liberoEnabled;
  final bool challengeEnabled;
  final bool videoReview;
  final bool winByTwo;
  final String status;
  final DateTime createdAt;
  final String homeTeamName;
  final String awayTeamName;
  final String homeCoachName;
  final String awayCoachName;
  final List<Map<String, dynamic>> homeTeamPlayers;
  final List<Map<String, dynamic>> awayTeamPlayers;
  final Map<String, dynamic> metadata;
  final List<Map<String, dynamic>> lineupA;
  final List<Map<String, dynamic>> lineupB;

  // Live Match State
  final int scoreTeamA;
  final int scoreTeamB;
  final int setsTeamA;
  final int setsTeamB;
  final int currentSet;
  final bool isTeamAServing;
  final int matchSeconds;
  final bool isPaused;

  VolleyballMatchModel({
    required this.matchId,
    required this.createdBy,
    this.matchName = '',
    this.tournament = '',
    this.date = '',
    this.time = '',
    this.venue = '',
    this.court = '',
    this.referee = '',
    this.assistantReferee = '',
    this.category = 'Mixed',
    this.format = 'B3',
    this.pointsPerSet = 25,
    this.finalSetPoints = 15,
    this.timeouts = 2,
    this.substitutions = 6,
    this.technicalTimeout = false,
    this.liberoEnabled = true,
    this.challengeEnabled = false,
    this.videoReview = false,
    this.winByTwo = true,
    this.status = 'setup',
    DateTime? createdAt,
    this.homeTeamName = '',
    this.awayTeamName = '',
    this.homeCoachName = '',
    this.awayCoachName = '',
    this.homeTeamPlayers = const [],
    this.awayTeamPlayers = const [],
    this.metadata = const {},
    this.lineupA = const [],
    this.lineupB = const [],
    this.scoreTeamA = 0,
    this.scoreTeamB = 0,
    this.setsTeamA = 0,
    this.setsTeamB = 0,
    this.currentSet = 1,
    this.isTeamAServing = true,
    this.matchSeconds = 0,
    this.isPaused = true,
  }) : createdAt = createdAt ?? DateTime.now();

  VolleyballMatchModel copyWith({
    String? matchId,
    String? createdBy,
    String? matchName,
    String? tournament,
    String? date,
    String? time,
    String? venue,
    String? court,
    String? referee,
    String? assistantReferee,
    String? category,
    String? format,
    int? pointsPerSet,
    int? finalSetPoints,
    int? timeouts,
    int? substitutions,
    bool? technicalTimeout,
    bool? liberoEnabled,
    bool? challengeEnabled,
    bool? videoReview,
    bool? winByTwo,
    String? status,
    DateTime? createdAt,
    String? homeTeamName,
    String? awayTeamName,
    String? homeCoachName,
    String? awayCoachName,
    List<Map<String, dynamic>>? homeTeamPlayers,
    List<Map<String, dynamic>>? awayTeamPlayers,
    Map<String, dynamic>? metadata,
    List<Map<String, dynamic>>? lineupA,
    List<Map<String, dynamic>>? lineupB,
    int? scoreTeamA,
    int? scoreTeamB,
    int? setsTeamA,
    int? setsTeamB,
    int? currentSet,
    bool? isTeamAServing,
    int? matchSeconds,
    bool? isPaused,
  }) {
    return VolleyballMatchModel(
      matchId: matchId ?? this.matchId,
      createdBy: createdBy ?? this.createdBy,
      matchName: matchName ?? this.matchName,
      tournament: tournament ?? this.tournament,
      date: date ?? this.date,
      time: time ?? this.time,
      venue: venue ?? this.venue,
      court: court ?? this.court,
      referee: referee ?? this.referee,
      assistantReferee: assistantReferee ?? this.assistantReferee,
      category: category ?? this.category,
      format: format ?? this.format,
      pointsPerSet: pointsPerSet ?? this.pointsPerSet,
      finalSetPoints: finalSetPoints ?? this.finalSetPoints,
      timeouts: timeouts ?? this.timeouts,
      substitutions: substitutions ?? this.substitutions,
      technicalTimeout: technicalTimeout ?? this.technicalTimeout,
      liberoEnabled: liberoEnabled ?? this.liberoEnabled,
      challengeEnabled: challengeEnabled ?? this.challengeEnabled,
      videoReview: videoReview ?? this.videoReview,
      winByTwo: winByTwo ?? this.winByTwo,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      homeTeamName: homeTeamName ?? this.homeTeamName,
      awayTeamName: awayTeamName ?? this.awayTeamName,
      homeCoachName: homeCoachName ?? this.homeCoachName,
      awayCoachName: awayCoachName ?? this.awayCoachName,
      homeTeamPlayers: homeTeamPlayers ?? this.homeTeamPlayers,
      awayTeamPlayers: awayTeamPlayers ?? this.awayTeamPlayers,
      metadata: metadata ?? this.metadata,
      lineupA: lineupA ?? this.lineupA,
      lineupB: lineupB ?? this.lineupB,
      scoreTeamA: scoreTeamA ?? this.scoreTeamA,
      scoreTeamB: scoreTeamB ?? this.scoreTeamB,
      setsTeamA: setsTeamA ?? this.setsTeamA,
      setsTeamB: setsTeamB ?? this.setsTeamB,
      currentSet: currentSet ?? this.currentSet,
      isTeamAServing: isTeamAServing ?? this.isTeamAServing,
      matchSeconds: matchSeconds ?? this.matchSeconds,
      isPaused: isPaused ?? this.isPaused,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'matchId': matchId,
      'createdBy': createdBy,
      'matchName': matchName,
      'tournament': tournament,
      'date': date,
      'time': time,
      'venue': venue,
      'court': court,
      'referee': referee,
      'assistantReferee': assistantReferee,
      'category': category,
      'format': format,
      'pointsPerSet': pointsPerSet,
      'finalSetPoints': finalSetPoints,
      'timeouts': timeouts,
      'substitutions': substitutions,
      'technicalTimeout': technicalTimeout ? 1 : 0,
      'liberoEnabled': liberoEnabled ? 1 : 0,
      'challengeEnabled': challengeEnabled ? 1 : 0,
      'videoReview': videoReview ? 1 : 0,
      'winByTwo': winByTwo ? 1 : 0,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'homeTeamName': homeTeamName,
      'awayTeamName': awayTeamName,
      'homeCoachName': homeCoachName,
      'awayCoachName': awayCoachName,
      'homeTeamPlayers': jsonEncode(homeTeamPlayers),
      'awayTeamPlayers': jsonEncode(awayTeamPlayers),
      'metadata': jsonEncode(metadata),
      'lineupA': jsonEncode(lineupA),
      'lineupB': jsonEncode(lineupB),
      'scoreTeamA': scoreTeamA,
      'scoreTeamB': scoreTeamB,
      'setsTeamA': setsTeamA,
      'setsTeamB': setsTeamB,
      'currentSet': currentSet,
      'isTeamAServing': isTeamAServing ? 1 : 0,
      'matchSeconds': matchSeconds,
      'isPaused': isPaused ? 1 : 0,
    };
  }

  factory VolleyballMatchModel.fromMap(Map<String, dynamic> map) {
    return VolleyballMatchModel(
      matchId: map['matchId'] ?? '',
      createdBy: map['createdBy'] ?? '',
      matchName: map['matchName'] ?? '',
      tournament: map['tournament'] ?? '',
      date: map['date'] ?? '',
      time: map['time'] ?? '',
      venue: map['venue'] ?? '',
      court: map['court'] ?? '',
      referee: map['referee'] ?? '',
      assistantReferee: map['assistantReferee'] ?? '',
      category: map['category'] ?? 'Mixed',
      format: map['format'] ?? 'B3',
      pointsPerSet: map['pointsPerSet']?.toInt() ?? 25,
      finalSetPoints: map['finalSetPoints']?.toInt() ?? 15,
      timeouts: map['timeouts']?.toInt() ?? 2,
      substitutions: map['substitutions']?.toInt() ?? 6,
      technicalTimeout:
          map['technicalTimeout'] == 1 || map['technicalTimeout'] == true,
      liberoEnabled: map['liberoEnabled'] == 1 || map['liberoEnabled'] == true,
      challengeEnabled:
          map['challengeEnabled'] == 1 || map['challengeEnabled'] == true,
      videoReview: map['videoReview'] == 1 || map['videoReview'] == true,
      winByTwo: map['winByTwo'] == 1 || map['winByTwo'] == true,
      status: map['status'] ?? 'setup',
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
      homeTeamName: map['homeTeamName'] ?? '',
      awayTeamName: map['awayTeamName'] ?? '',
      homeCoachName: map['homeCoachName'] ?? '',
      awayCoachName: map['awayCoachName'] ?? '',
      homeTeamPlayers: _toMaps(map['homeTeamPlayers']),
      awayTeamPlayers: _toMaps(map['awayTeamPlayers']),
      metadata: _toMap(map['metadata']),
      lineupA: _toMaps(map['lineupA']),
      lineupB: _toMaps(map['lineupB']),
      scoreTeamA: map['scoreTeamA']?.toInt() ?? 0,
      scoreTeamB: map['scoreTeamB']?.toInt() ?? 0,
      setsTeamA: map['setsTeamA']?.toInt() ?? 0,
      setsTeamB: map['setsTeamB']?.toInt() ?? 0,
      currentSet: map['currentSet']?.toInt() ?? 1,
      isTeamAServing:
          map['isTeamAServing'] == 1 || map['isTeamAServing'] == true,
      matchSeconds: map['matchSeconds']?.toInt() ?? 0,
      isPaused:
          map['isPaused'] == 1 ||
          map['isPaused'] == true ||
          map['isPaused'] == null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'matchId': matchId,
      'createdBy': createdBy,
      'matchName': matchName,
      'tournament': tournament,
      'date': date,
      'time': time,
      'venue': venue,
      'court': court,
      'referee': referee,
      'assistantReferee': assistantReferee,
      'category': category,
      'format': format,
      'pointsPerSet': pointsPerSet,
      'finalSetPoints': finalSetPoints,
      'timeouts': timeouts,
      'substitutions': substitutions,
      'technicalTimeout': technicalTimeout,
      'liberoEnabled': liberoEnabled,
      'challengeEnabled': challengeEnabled,
      'videoReview': videoReview,
      'winByTwo': winByTwo,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'homeTeamName': homeTeamName,
      'awayTeamName': awayTeamName,
      'homeCoachName': homeCoachName,
      'awayCoachName': awayCoachName,
      'homeTeamPlayers': homeTeamPlayers,
      'awayTeamPlayers': awayTeamPlayers,
      'metadata': metadata,
      'lineupA': lineupA,
      'lineupB': lineupB,
      'scoreTeamA': scoreTeamA,
      'scoreTeamB': scoreTeamB,
      'setsTeamA': setsTeamA,
      'setsTeamB': setsTeamB,
      'currentSet': currentSet,
      'isTeamAServing': isTeamAServing,
      'matchSeconds': matchSeconds,
      'isPaused': isPaused,
    };
  }

  factory VolleyballMatchModel.fromJson(Map<String, dynamic> json) {
    return VolleyballMatchModel(
      matchId: json['matchId'] ?? '',
      createdBy: json['createdBy'] ?? '',
      matchName: json['matchName'] ?? '',
      tournament: json['tournament'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      venue: json['venue'] ?? '',
      court: json['court'] ?? '',
      referee: json['referee'] ?? '',
      assistantReferee: json['assistantReferee'] ?? '',
      category: json['category'] ?? 'Mixed',
      format: json['format'] ?? 'B3',
      pointsPerSet: json['pointsPerSet']?.toInt() ?? 25,
      finalSetPoints: json['finalSetPoints']?.toInt() ?? 15,
      timeouts: json['timeouts']?.toInt() ?? 2,
      substitutions: json['substitutions']?.toInt() ?? 6,
      technicalTimeout: json['technicalTimeout'] ?? false,
      liberoEnabled: json['liberoEnabled'] ?? true,
      challengeEnabled: json['challengeEnabled'] ?? false,
      videoReview: json['videoReview'] ?? false,
      winByTwo: json['winByTwo'] ?? true,
      status: json['status'] ?? 'setup',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      homeTeamName: json['homeTeamName'] ?? '',
      awayTeamName: json['awayTeamName'] ?? '',
      homeCoachName: json['homeCoachName'] ?? '',
      awayCoachName: json['awayCoachName'] ?? '',
      homeTeamPlayers: List<Map<String, dynamic>>.from(
        (json['homeTeamPlayers'] ?? []).map(
          (e) => Map<String, dynamic>.from(e),
        ),
      ),
      awayTeamPlayers: List<Map<String, dynamic>>.from(
        (json['awayTeamPlayers'] ?? []).map(
          (e) => Map<String, dynamic>.from(e),
        ),
      ),
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
      lineupA: List<Map<String, dynamic>>.from(
        (json['lineupA'] ?? []).map((e) => Map<String, dynamic>.from(e)),
      ),
      lineupB: List<Map<String, dynamic>>.from(
        (json['lineupB'] ?? []).map((e) => Map<String, dynamic>.from(e)),
      ),
      scoreTeamA: json['scoreTeamA']?.toInt() ?? 0,
      scoreTeamB: json['scoreTeamB']?.toInt() ?? 0,
      setsTeamA: json['setsTeamA']?.toInt() ?? 0,
      setsTeamB: json['setsTeamB']?.toInt() ?? 0,
      currentSet: json['currentSet']?.toInt() ?? 1,
      isTeamAServing: json['isTeamAServing'] ?? true,
      matchSeconds: json['matchSeconds']?.toInt() ?? 0,
      isPaused: json['isPaused'] ?? true,
    );
  }
}
