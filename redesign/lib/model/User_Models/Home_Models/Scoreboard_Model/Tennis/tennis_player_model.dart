class TennisPlayerModel {
  final String id;
  final String name;
  final String club;
  final String ranking;
  final String countryCode;
  final String imageUrl;
  final String imagePath;
  final String country;

  const TennisPlayerModel({
    required this.id,
    required this.name,
    required this.club,
    required this.ranking,
    required this.countryCode,
    required this.imageUrl,
    this.imagePath = '',
    this.country = '',
  });
}
