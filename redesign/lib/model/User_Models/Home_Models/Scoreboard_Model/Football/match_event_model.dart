class MatchEventModel {
  final String id;
  final String eventType; // e.g. "Goal", "Card", "Substitution", "VAR"
  final String team; // "A" or "B"
  final String? player;
  final int minute;
  final String description;

  const MatchEventModel({
    required this.id,
    required this.eventType,
    required this.team,
    this.player,
    required this.minute,
    required this.description,
  });

  MatchEventModel copyWith({
    String? id,
    String? eventType,
    String? team,
    String? player,
    int? minute,
    String? description,
  }) {
    return MatchEventModel(
      id: id ?? this.id,
      eventType: eventType ?? this.eventType,
      team: team ?? this.team,
      player: player ?? this.player,
      minute: minute ?? this.minute,
      description: description ?? this.description,
    );
  }
}
