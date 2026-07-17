class CreateTournamentModel {
  final String sport;
  final String? coverImage;
  final String tournamentName;
  final DateTime? startDate;
  final DateTime? endDate;
  final String preferredTiming;
  final bool isPublicAccess;
  final String description;

  CreateTournamentModel({
    required this.sport,
    this.coverImage,
    required this.tournamentName,
    this.startDate,
    this.endDate,
    required this.preferredTiming,
    required this.isPublicAccess,
    required this.description,
  });
}
