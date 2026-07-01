class PlayerModel {
  final String id;
  final String name;
  final String jerseyNumber;
  final String position; // LB, CB, RB, CDM, CAM, LW, RW, GK, ST, etc.
  final int overall;
  final String fitness;
  final String availability; // "fit", "out", "injured"
  final String form; // icon/emoji like 🔥, ⭐, 📈
  final String? avatarImage;
  final bool isLocked;
  final bool isGoalkeeper;
  final String? returnWeeks; // for injured

  const PlayerModel({
    required this.id,
    required this.name,
    required this.jerseyNumber,
    required this.position,
    required this.overall,
    required this.fitness,
    required this.availability,
    required this.form,
    this.avatarImage,
    this.isLocked = false,
    this.isGoalkeeper = false,
    this.returnWeeks,
  });

  PlayerModel copyWith({
    String? id,
    String? name,
    String? jerseyNumber,
    String? position,
    int? overall,
    String? fitness,
    String? availability,
    String? form,
    String? avatarImage,
    bool? isLocked,
    bool? isGoalkeeper,
    String? returnWeeks,
  }) {
    return PlayerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      jerseyNumber: jerseyNumber ?? this.jerseyNumber,
      position: position ?? this.position,
      overall: overall ?? this.overall,
      fitness: fitness ?? this.fitness,
      availability: availability ?? this.availability,
      form: form ?? this.form,
      avatarImage: avatarImage ?? this.avatarImage,
      isLocked: isLocked ?? this.isLocked,
      isGoalkeeper: isGoalkeeper ?? this.isGoalkeeper,
      returnWeeks: returnWeeks ?? this.returnWeeks,
    );
  }
}
