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
  final double? latitude;
  final double? longitude;
  final String? fullAddress;
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
    this.latitude,
    this.longitude,
    this.fullAddress,
    this.isSelected = false,
  });
}
