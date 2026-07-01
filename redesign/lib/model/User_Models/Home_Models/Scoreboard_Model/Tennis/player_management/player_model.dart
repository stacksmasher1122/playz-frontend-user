class PlayerModel {
  final String id;
  final String name;
  final String club;
  final String country;
  final int ranking;
  final String imagePath;
  final bool isAvailable;

  const PlayerModel({
    required this.id,
    required this.name,
    required this.club,
    required this.country,
    required this.ranking,
    required this.imagePath,
    required this.isAvailable,
  });
}
