class PlayerModel {
  final int id;
  final String name;
  final String avatar;
  final int ranking;
  final String country;
  final bool isSelected;

  const PlayerModel({
    required this.id,
    required this.name,
    required this.avatar,
    required this.ranking,
    required this.country,
    this.isSelected = false,
  });
}
