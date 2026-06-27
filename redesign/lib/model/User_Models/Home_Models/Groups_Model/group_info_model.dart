import 'package:cloud_firestore/cloud_firestore.dart';

// ═══════════════════════════════════════════════════════
//  GROUP MEDIA MODEL
// ═══════════════════════════════════════════════════════
class GroupMediaModel {
  final String id;
  final String groupId;
  final String url;
  final String type; // 'image' or 'video'
  final DateTime timestamp;

  GroupMediaModel({
    required this.id,
    required this.groupId,
    required this.url,
    required this.type,
    required this.timestamp,
  });

  factory GroupMediaModel.fromMap(String id, String fetchedGroupId, Map<String, dynamic> map) {
    return GroupMediaModel(
      id: id,
      groupId: fetchedGroupId,
      url: map['content'] ?? '',
      type: map['type'] ?? 'image',
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'groupId': groupId,
      'content': url,
      'type': type,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  // SQFlite mapping
  Map<String, dynamic> toSqfliteMap() {
    return {
      'id': id,
      'groupId': groupId,
      'url': url,
      'type': type,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  factory GroupMediaModel.fromSqfliteMap(Map<String, dynamic> map) {
    return GroupMediaModel(
      id: map['id'] ?? '',
      groupId: map['groupId'] ?? '',
      url: map['url'] ?? '',
      type: map['type'] ?? 'image',
      timestamp: DateTime.fromMillisecondsSinceEpoch(
        map['timestamp'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════
//  GROUP MEMBER MODEL
// ═══════════════════════════════════════════════════════
class GroupMemberModel {
  final String email;
  final String name;
  final String imageUrl;
  final String role; // 'admin' or 'member'
  final DateTime joinedAt;

  GroupMemberModel({
    required this.email,
    required this.name,
    required this.imageUrl,
    required this.role,
    required this.joinedAt,
  });

  factory GroupMemberModel.fromMap(String email, Map<String, dynamic> map) {
    return GroupMemberModel(
      email: email,
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      role: map['role'] ?? 'member',
      joinedAt: (map['joinedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'role': role,
      'joinedAt': Timestamp.fromDate(joinedAt),
    };
  }
}
