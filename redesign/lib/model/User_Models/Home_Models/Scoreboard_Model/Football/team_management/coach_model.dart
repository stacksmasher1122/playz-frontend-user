class CoachModel {
  final String coachName;
  final int experience; // Years
  final String license; // e.g., "Pro License Division"
  final String teamName;

  const CoachModel({
    required this.coachName,
    required this.experience,
    required this.license,
    required this.teamName,
  });

  CoachModel copyWith({
    String? coachName,
    int? experience,
    String? license,
    String? teamName,
  }) {
    return CoachModel(
      coachName: coachName ?? this.coachName,
      experience: experience ?? this.experience,
      license: license ?? this.license,
      teamName: teamName ?? this.teamName,
    );
  }
}
