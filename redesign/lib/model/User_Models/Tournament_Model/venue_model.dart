class VenueModel {
  final String id;
  final String name;
  final String image;
  final double distance;
  final double rating;
  final int reviewCount;
  final bool isIndoor;
  final String category;
  final String location;
  bool isSelected;

  VenueModel({
    required this.id,
    required this.name,
    required this.image,
    required this.distance,
    required this.rating,
    required this.reviewCount,
    required this.isIndoor,
    required this.category,
    required this.location,
    this.isSelected = false,
  });
}
