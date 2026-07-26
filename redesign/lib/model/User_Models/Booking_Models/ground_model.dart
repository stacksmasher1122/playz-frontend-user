import 'package:cloud_firestore/cloud_firestore.dart';

class GroundModel {
  final String id;
  final String name;
  final int groundIndex;
  final List<String> sports;
  final String dimensions;
  final double defaultPrice;
  final String peakStartTime;
  final String peakEndTime;
  final double peakPrice;
  final int totalSlots;

  GroundModel({
    required this.id,
    required this.name,
    required this.groundIndex,
    required this.sports,
    required this.dimensions,
    required this.defaultPrice,
    required this.peakStartTime,
    required this.peakEndTime,
    required this.peakPrice,
    required this.totalSlots,
  });

  factory GroundModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    return GroundModel(
      id: data['id'] ?? doc.id,
      name: data['name'] ?? '',
      groundIndex: (data['groundIndex'] ?? 0).toInt(),
      sports: List<String>.from(data['sports'] ?? []),
      dimensions: data['dimensions'] ?? '',
      defaultPrice: (data['defaultPrice'] ?? 0).toDouble(),
      peakStartTime: data['peakStartTime'] ?? '',
      peakEndTime: data['peakEndTime'] ?? '',
      peakPrice: (data['peakPrice'] ?? 0).toDouble(),
      totalSlots: (data['totalSlots'] ?? 0).toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'groundIndex': groundIndex,
      'sports': sports,
      'dimensions': dimensions,
      'defaultPrice': defaultPrice,
      'peakStartTime': peakStartTime,
      'peakEndTime': peakEndTime,
      'peakPrice': peakPrice,
      'totalSlots': totalSlots,
    };
  }
}
