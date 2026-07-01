class LiveMatchModel {
  final String matchId;
  final String teamAName;
  final String teamBName;
  final String? teamALogo;
  final String? teamBLogo;
  final int scoreA;
  final int scoreB;
  final String currentHalf;
  final int currentMinute;
  final bool isLive;
  final int possessionA;
  final int possessionB;

  const LiveMatchModel({
    required this.matchId,
    required this.teamAName,
    required this.teamBName,
    this.teamALogo,
    this.teamBLogo,
    required this.scoreA,
    required this.scoreB,
    required this.currentHalf,
    required this.currentMinute,
    required this.isLive,
    required this.possessionA,
    required this.possessionB,
  });

  LiveMatchModel copyWith({
    String? matchId,
    String? teamAName,
    String? teamBName,
    String? teamALogo,
    String? teamBLogo,
    int? scoreA,
    int? scoreB,
    String? currentHalf,
    int? currentMinute,
    bool? isLive,
    int? possessionA,
    int? possessionB,
  }) {
    return LiveMatchModel(
      matchId: matchId ?? this.matchId,
      teamAName: teamAName ?? this.teamAName,
      teamBName: teamBName ?? this.teamBName,
      teamALogo: teamALogo ?? this.teamALogo,
      teamBLogo: teamBLogo ?? this.teamBLogo,
      scoreA: scoreA ?? this.scoreA,
      scoreB: scoreB ?? this.scoreB,
      currentHalf: currentHalf ?? this.currentHalf,
      currentMinute: currentMinute ?? this.currentMinute,
      isLive: isLive ?? this.isLive,
      possessionA: possessionA ?? this.possessionA,
      possessionB: possessionB ?? this.possessionB,
    );
  }
}
