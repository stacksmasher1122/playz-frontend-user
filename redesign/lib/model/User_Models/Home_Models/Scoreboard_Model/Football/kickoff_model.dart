class KickoffModel {
  final String matchId;
  final bool teamAOnLeft;
  final String selectedPossession; // "A" or "B"
  final double ballPosition; // 0.0 to 1.0
  final bool isValid;

  const KickoffModel({
    required this.matchId,
    required this.teamAOnLeft,
    required this.selectedPossession,
    required this.ballPosition,
    required this.isValid,
  });

  KickoffModel copyWith({
    String? matchId,
    bool? teamAOnLeft,
    String? selectedPossession,
    double? ballPosition,
    bool? isValid,
  }) {
    return KickoffModel(
      matchId: matchId ?? this.matchId,
      teamAOnLeft: teamAOnLeft ?? this.teamAOnLeft,
      selectedPossession: selectedPossession ?? this.selectedPossession,
      ballPosition: ballPosition ?? this.ballPosition,
      isValid: isValid ?? this.isValid,
    );
  }
}
