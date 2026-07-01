import 'player_statistics_model.dart';

class PlayerModel {
  final String playerId;
  final String playerName;
  final String playerNumber;
  final String playerImage;
  final String position; // e.g. "FWD / ATTACKING MID", "DEF / CENTER BACK"
  final bool captain;
  final String fitness; // e.g. "FIT", "INJURED"
  final String injuryStatus; // optional extra info
  final double rating;
  final String form; // To hold form representation, e.g. recent matches
  final PlayerStatisticsModel statistics;

  const PlayerModel({
    required this.playerId,
    required this.playerName,
    required this.playerNumber,
    required this.playerImage,
    required this.position,
    this.captain = false,
    required this.fitness,
    this.injuryStatus = '',
    required this.rating,
    this.form = '',
    required this.statistics,
  });

  PlayerModel copyWith({
    String? playerId,
    String? playerName,
    String? playerNumber,
    String? playerImage,
    String? position,
    bool? captain,
    String? fitness,
    String? injuryStatus,
    double? rating,
    String? form,
    PlayerStatisticsModel? statistics,
  }) {
    return PlayerModel(
      playerId: playerId ?? this.playerId,
      playerName: playerName ?? this.playerName,
      playerNumber: playerNumber ?? this.playerNumber,
      playerImage: playerImage ?? this.playerImage,
      position: position ?? this.position,
      captain: captain ?? this.captain,
      fitness: fitness ?? this.fitness,
      injuryStatus: injuryStatus ?? this.injuryStatus,
      rating: rating ?? this.rating,
      form: form ?? this.form,
      statistics: statistics ?? this.statistics,
    );
  }
}
