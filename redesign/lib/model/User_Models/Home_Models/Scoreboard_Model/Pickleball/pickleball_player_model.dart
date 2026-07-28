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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'club': club,
      'rating': rating,
      'country': country,
      'image': image,
      'gender': gender,
      'isSelected': isSelected,
    };
  }

  factory PickleballPlayerModel.fromMap(Map<String, dynamic> map) {
    return PickleballPlayerModel(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      club: map['club'] ?? '',
      rating: map['rating'] ?? '',
      country: map['country'] ?? '',
      image: map['image'] ?? '',
      gender: map['gender'] ?? '',
      isSelected: map['isSelected'] ?? false,
    );
  }
}
