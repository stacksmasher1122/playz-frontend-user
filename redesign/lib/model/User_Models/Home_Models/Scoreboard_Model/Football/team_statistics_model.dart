class TeamStatisticsModel {
  final int possession; // percentage 0-100
  final int shots;
  final int shotsOnTarget;
  final int passes;
  final int passAccuracy; // percentage 0-100
  final int corners;
  final int interceptions;
  final int fouls;
  final int yellowCards;
  final int redCards;
  final double expectedGoals;
  final double xpPoints;

  const TeamStatisticsModel({
    required this.possession,
    required this.shots,
    required this.shotsOnTarget,
    required this.passes,
    required this.passAccuracy,
    required this.corners,
    required this.interceptions,
    required this.fouls,
    required this.yellowCards,
    required this.redCards,
    required this.expectedGoals,
    required this.xpPoints,
  });

  TeamStatisticsModel copyWith({
    int? possession,
    int? shots,
    int? shotsOnTarget,
    int? passes,
    int? passAccuracy,
    int? corners,
    int? interceptions,
    int? fouls,
    int? yellowCards,
    int? redCards,
    double? expectedGoals,
    double? xpPoints,
  }) {
    return TeamStatisticsModel(
      possession: possession ?? this.possession,
      shots: shots ?? this.shots,
      shotsOnTarget: shotsOnTarget ?? this.shotsOnTarget,
      passes: passes ?? this.passes,
      passAccuracy: passAccuracy ?? this.passAccuracy,
      corners: corners ?? this.corners,
      interceptions: interceptions ?? this.interceptions,
      fouls: fouls ?? this.fouls,
      yellowCards: yellowCards ?? this.yellowCards,
      redCards: redCards ?? this.redCards,
      expectedGoals: expectedGoals ?? this.expectedGoals,
      xpPoints: xpPoints ?? this.xpPoints,
    );
  }
}
