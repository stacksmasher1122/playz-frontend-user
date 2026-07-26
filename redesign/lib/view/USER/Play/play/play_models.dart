import 'package:cloud_firestore/cloud_firestore.dart';

class GameData {
  final String id;
  final String hostId;
  final String hostName;
  final String avatarUrl;
  final int hostXp;
  final String time;
  final String date;
  final String price;
  final int priceNum;
  final int currentPlayers;
  final int maxPlayers;
  final String address;
  final String distance;
  final double latitude;
  final double longitude;
  final String sport;
  final String type; // 'Casual' or 'Competitive'
  final String locationType; // 'playz_turf' or 'custom'
  final String? turfId;
  final String? groundId;
  final String? slotId;
  final bool isFull;
  final DateTime? createdAt;
  final List<String> playerIds;

  GameData({
    required this.id,
    required this.hostId,
    required this.hostName,
    required this.avatarUrl,
    this.hostXp = 100,
    required this.time,
    required this.date,
    required this.price,
    this.priceNum = 0,
    required this.currentPlayers,
    required this.maxPlayers,
    required this.address,
    required this.distance,
    this.latitude = 0.0,
    this.longitude = 0.0,
    required this.sport,
    required this.type,
    this.locationType = 'custom',
    this.turfId,
    this.groundId,
    this.slotId,
    this.isFull = false,
    this.createdAt,
    this.playerIds = const [],
  });

  factory GameData.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    final currentP = (data['currentPlayers'] as num?)?.toInt() ?? 1;
    final maxP = (data['maxPlayers'] as num?)?.toInt() ?? 10;
    final priceVal = (data['priceNum'] as num?)?.toInt() ?? 0;
    final isComp = data['isCompetitive'] == true || data['type'] == 'Competitive';

    return GameData(
      id: doc.id,
      hostId: (data['hostId'] ?? '').toString(),
      hostName: (data['hostName'] ?? 'Host Player').toString(),
      avatarUrl: (data['avatarUrl'] ?? data['hostAvatar'] ?? 'https://i.pravatar.cc/100?img=1').toString(),
      hostXp: (data['hostXp'] as num?)?.toInt() ?? 100,
      time: (data['time'] ?? '18:00').toString(),
      date: (data['date'] ?? '').toString(),
      price: priceVal > 0 ? '₹$priceVal' : 'Free',
      priceNum: priceVal,
      currentPlayers: currentP,
      maxPlayers: maxP,
      address: (data['address'] ?? data['location'] ?? 'Local Ground').toString(),
      distance: (data['distance'] ?? '1.0 km').toString(),
      latitude: (data['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (data['longitude'] as num?)?.toDouble() ?? 0.0,
      sport: (data['sport'] ?? 'Football').toString(),
      type: isComp ? 'Competitive' : 'Casual',
      locationType: (data['locationType'] ?? 'custom').toString(),
      turfId: data['turfId']?.toString(),
      groundId: data['groundId']?.toString(),
      slotId: data['slotId']?.toString(),
      isFull: currentP >= maxP,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      playerIds: List<String>.from(data['playerIds'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'hostId': hostId,
      'hostName': hostName,
      'hostAvatar': avatarUrl,
      'hostXp': hostXp,
      'time': time,
      'date': date,
      'price': price,
      'priceNum': priceNum,
      'currentPlayers': currentPlayers,
      'maxPlayers': maxPlayers,
      'address': address,
      'distance': distance,
      'latitude': latitude,
      'longitude': longitude,
      'sport': sport,
      'type': type,
      'isCompetitive': type == 'Competitive',
      'locationType': locationType,
      'turfId': turfId,
      'groundId': groundId,
      'slotId': slotId,
      'createdAt': FieldValue.serverTimestamp(),
      'playerIds': playerIds,
    };
  }
}
