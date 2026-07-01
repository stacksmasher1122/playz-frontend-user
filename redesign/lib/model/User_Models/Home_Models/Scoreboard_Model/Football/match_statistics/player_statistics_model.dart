class PlayerStatisticsModel {
  final String playerId;
  final String playerName;
  final String playerImage;
  final String jerseyNumber;
  final String position;
  final int minutesPlayed;
  final int goals;
  final int assists;
  final double expectedGoals;
  final double rating;
  final bool yellowCard;
  final bool redCard;
  final String teamName;

  const PlayerStatisticsModel({
    required this.playerId,
    required this.playerName,
    required this.playerImage,
    required this.jerseyNumber,
    required this.position,
    required this.minutesPlayed,
    required this.goals,
    required this.assists,
    required this.expectedGoals,
    required this.rating,
    required this.yellowCard,
    required this.redCard,
    required this.teamName,
  });

  PlayerStatisticsModel copyWith({
    String? playerId,
    String? playerName,
    String? playerImage,
    String? jerseyNumber,
    String? position,
    int? minutesPlayed,
    int? goals,
    int? assists,
    double? expectedGoals,
    double? rating,
    bool? yellowCard,
    bool? redCard,
    String? teamName,
  }) {
    return PlayerStatisticsModel(
      playerId: playerId ?? this.playerId,
      playerName: playerName ?? this.playerName,
      playerImage: playerImage ?? this.playerImage,
      jerseyNumber: jerseyNumber ?? this.jerseyNumber,
      position: position ?? this.position,
      minutesPlayed: minutesPlayed ?? this.minutesPlayed,
      goals: goals ?? this.goals,
      assists: assists ?? this.assists,
      expectedGoals: expectedGoals ?? this.expectedGoals,
      rating: rating ?? this.rating,
      yellowCard: yellowCard ?? this.yellowCard,
      redCard: redCard ?? this.redCard,
      teamName: teamName ?? this.teamName,
    );
  }
}
