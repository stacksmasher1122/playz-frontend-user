import 'package:cloud_firestore/cloud_firestore.dart';

class TurfModel {
  final String id;
  final String ownerId;
  final String turfName;
  final String fullAddress;
  final String city;
  final String state;
  final String pincode;
  final double latitude;
  final double longitude;
  final String description;
  final List<String> sports;
  final List<String> amenities;
  final Map<String, String> operatingHours;
  final String heroImageUrl;
  final List<String> imageUrls;
  final String status;
  final bool isVerified;
  final bool isPaused;
  final bool isDeleted;
  final DateTime? createdAt;

  /// Lowest ground price — populated after grounds are fetched
  double? lowestPrice;

  TurfModel({
    required this.id,
    required this.ownerId,
    required this.turfName,
    required this.fullAddress,
    required this.city,
    required this.state,
    required this.pincode,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.sports,
    required this.amenities,
    required this.operatingHours,
    required this.heroImageUrl,
    required this.imageUrls,
    required this.status,
    required this.isVerified,
    required this.isPaused,
    required this.isDeleted,
    this.createdAt,
    this.lowestPrice,
  });

  /// Build a [TurfModel] from a Firestore [DocumentSnapshot].
  factory TurfModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    // Parse operating hours map safely
    final rawHours = data['operatingHours'];
    final Map<String, String> hours = {};
    if (rawHours is Map) {
      rawHours.forEach((key, value) {
        hours[key.toString()] = value?.toString() ?? '';
      });
    }

    final parentOwnerId = doc.reference.parent.parent?.id ?? '';
    final ownerIdVal = data['ownerId']?.toString() ?? '';

    return TurfModel(
      id: data['id']?.toString() ?? doc.id,
      ownerId: ownerIdVal.isNotEmpty ? ownerIdVal : parentOwnerId,
      turfName: data['turfName']?.toString() ?? '',
      fullAddress: data['fullAddress'] ?? '',
      city: data['city'] ?? '',
      state: data['state'] ?? '',
      pincode: data['pincode'] ?? '',
      latitude: (data['latitude'] ?? 0).toDouble(),
      longitude: (data['longitude'] ?? 0).toDouble(),
      description: data['description'] ?? '',
      sports: List<String>.from(data['sports'] ?? []),
      amenities: List<String>.from(data['amenities'] ?? []),
      operatingHours: hours,
      heroImageUrl: data['heroImageUrl'] ?? '',
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      status: data['status'] ?? 'draft',
      isVerified: data['isVerified'] ?? false,
      isPaused: data['isPaused'] ?? false,
      isDeleted: data['isDeleted'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ownerId': ownerId,
      'turfName': turfName,
      'fullAddress': fullAddress,
      'city': city,
      'state': state,
      'pincode': pincode,
      'latitude': latitude,
      'longitude': longitude,
      'description': description,
      'sports': sports,
      'amenities': amenities,
      'operatingHours': operatingHours,
      'heroImageUrl': heroImageUrl,
      'imageUrls': imageUrls,
      'status': status,
      'isVerified': isVerified,
      'isPaused': isPaused,
      'isDeleted': isDeleted,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
    };
  }

  /// Formatted location string for UI display
  String get displayLocation => '$city, $state';

  /// All gallery images: hero first, then imageUrls
  List<String> get allImages {
    final imgs = <String>[];
    if (heroImageUrl.isNotEmpty) imgs.add(heroImageUrl);
    imgs.addAll(imageUrls.where((url) => url.isNotEmpty));
    return imgs;
  }

  /// Check if turf is currently open based on operating hours
  bool get isCurrentlyOpen {
    final now = DateTime.now();
    final isWeekend = now.weekday == DateTime.saturday || now.weekday == DateTime.sunday;

    final startKey = isWeekend ? 'satSunStart' : 'monFriStart';
    final endKey = isWeekend ? 'satSunEnd' : 'monFriEnd';

    final startStr = operatingHours[startKey];
    final endStr = operatingHours[endKey];

    if (startStr == null || endStr == null) return false;

    try {
      final startParts = startStr.split(':');
      final endParts = endStr.split(':');
      final startMinutes = int.parse(startParts[0]) * 60 + int.parse(startParts[1]);
      final endMinutes = int.parse(endParts[0]) * 60 + int.parse(endParts[1]);
      final nowMinutes = now.hour * 60 + now.minute;
      return nowMinutes >= startMinutes && nowMinutes <= endMinutes;
    } catch (_) {
      return false;
    }
  }
}
