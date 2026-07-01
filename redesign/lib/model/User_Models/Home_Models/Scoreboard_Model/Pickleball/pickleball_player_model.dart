class PickleballPlayerModel {
  final int id;
  final String name;
  final String club;
  final String rating;
  final String country;
  final String image;
  final String gender;
  bool isSelected;

  PickleballPlayerModel({
    required this.id,
    required this.name,
    required this.club,
    required this.rating,
    required this.country,
    required this.image,
    required this.gender,
    this.isSelected = false,
  });
}
