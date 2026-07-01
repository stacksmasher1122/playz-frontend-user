class PlayerStatisticsModel {
  final int goals;
  final int assists;
  final double tackles;
  final int passAccuracy;
  final double distance;
  final int sprints;
  final int cleanSheets;
  final int saves;
  final int recovery; // percentage

  const PlayerStatisticsModel({
    this.goals = 0,
    this.assists = 0,
    this.tackles = 0.0,
    this.passAccuracy = 0,
    this.distance = 0.0,
    this.sprints = 0,
    this.cleanSheets = 0,
    this.saves = 0,
    this.recovery = 0,
  });

  PlayerStatisticsModel copyWith({
    int? goals,
    int? assists,
    double? tackles,
    int? passAccuracy,
    double? distance,
    int? sprints,
    int? cleanSheets,
    int? saves,
    int? recovery,
  }) {
    return PlayerStatisticsModel(
      goals: goals ?? this.goals,
      assists: assists ?? this.assists,
      tackles: tackles ?? this.tackles,
      passAccuracy: passAccuracy ?? this.passAccuracy,
      distance: distance ?? this.distance,
      sprints: sprints ?? this.sprints,
      cleanSheets: cleanSheets ?? this.cleanSheets,
      saves: saves ?? this.saves,
      recovery: recovery ?? this.recovery,
    );
  }
}
