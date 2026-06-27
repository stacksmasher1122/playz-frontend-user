import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  final String groupId;
  final String name;
  final String description;
  final String sport;
  final bool isPublic;
  final int maxMembers;
  final String imageUrl;
  final String creator;
  final Map<String, dynamic> members;
  final DateTime createdAt;
  final bool profanityModerationMembers;
  final bool profanityModerationAdmins;

  GroupModel({
    required this.groupId,
    required this.name,
    required this.description,
    required this.sport,
    required this.isPublic,
    required this.maxMembers,
    required this.imageUrl,
    required this.creator,
    required this.members,
    required this.createdAt,
    this.profanityModerationMembers = false,
    this.profanityModerationAdmins = false,
  });

  // ── Convert to Map for Firestore ──
  Map<String, dynamic> toMap() {
    return {
      'groupId': groupId,
      'name': name,
      'description': description,
      'sport': sport,
      'isPublic': isPublic,
      'maxMembers': maxMembers,
      'imageUrl': imageUrl,
      'creator': creator,
      'members': members,
      'createdAt': Timestamp.fromDate(createdAt),
      'profanityModerationMembers': profanityModerationMembers,
      'profanityModerationAdmins': profanityModerationAdmins,
    };
  }

  // ── Recursive sanitizer: converts every Timestamp anywhere in a nested
  //    structure to millisecondsSinceEpoch (int). This handles the case where
  //    Firestore dot-notation splits email keys like "user@gmail.com" into
  //    nested maps { user@gmail: { com: { joinedAt: Timestamp } } }.
  static dynamic _sanitize(dynamic value) {
    if (value is Timestamp) {
      return value.millisecondsSinceEpoch;
    }
    if (value is Map) {
      return Map<String, dynamic>.fromEntries(
        value.entries.map(
          (e) => MapEntry(e.key.toString(), _sanitize(e.value)),
        ),
      );
    }
    if (value is List) {
      return value.map(_sanitize).toList();
    }
    return value; // String, int, double, bool, null — safe for jsonEncode
  }

  // ── Recursive restore: converts every int at known Timestamp field names
  //    back to Timestamp when reading from SQFlite.
  static dynamic _restore(dynamic value, {bool isTimestampField = false}) {
    if (value is int && isTimestampField) {
      return Timestamp.fromMillisecondsSinceEpoch(value);
    }
    if (value is Map) {
      return Map<String, dynamic>.fromEntries(
        value.entries.map((e) => MapEntry(
          e.key.toString(),
          _restore(
            e.value,
            isTimestampField:
                e.key == 'joinedAt' || e.key == 'lastSeenAt',
          ),
        )),
      );
    }
    if (value is List) {
      return value.map((v) => _restore(v)).toList();
    }
    return value;
  }

  // ── Convert to Map for SQFlite ──
  // Uses _sanitize() to recursively strip ALL Timestamps before jsonEncode,
  // regardless of nesting depth (handles dot-split email keys in Firestore).
  Map<String, dynamic> toSqfliteMap() {
    return {
      'groupId': groupId,
      'name': name,
      'description': description,
      'sport': sport,
      'isPublic': isPublic ? 1 : 0,
      'maxMembers': maxMembers,
      'imageUrl': imageUrl,
      'creator': creator,
      'members': jsonEncode(_sanitize(members)),
      'createdAt': createdAt.millisecondsSinceEpoch,
      'profanityModerationMembers': profanityModerationMembers ? 1 : 0,
      'profanityModerationAdmins': profanityModerationAdmins ? 1 : 0,
    };
  }

  // ── Summary map for storing in the User document ──
  Map<String, dynamic> toUserGroupRef() {
    return {
      'groupId': groupId,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
    };
  }

  // ── Create from Firestore ──
  factory GroupModel.fromMap(Map<String, dynamic> map, String docId) {
    return GroupModel(
      groupId: docId,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      sport: map['sport'] ?? '',
      isPublic: map['isPublic'] ?? true,
      maxMembers: map['maxMembers'] ?? 25,
      imageUrl: map['imageUrl'] ?? '',
      creator: map['creator'] ?? '',
      members: Map<String, dynamic>.from(map['members'] ?? {}),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      profanityModerationMembers: map['profanityModerationMembers'] ?? false,
      profanityModerationAdmins: map['profanityModerationAdmins'] ?? false,
    );
  }

  // ── Create from SQFlite Map ──
  // Uses _restore() to recursively rebuild Timestamps from ints.
  factory GroupModel.fromSqfliteMap(Map<String, dynamic> map) {
    final rawDecoded = map['members'] != null
        ? jsonDecode(map['members']) as Map
        : {};

    final restoredMembers = Map<String, dynamic>.from(
      _restore(rawDecoded) as Map,
    );

    return GroupModel(
      groupId: map['groupId'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      sport: map['sport'] ?? '',
      isPublic: map['isPublic'] == 1,
      maxMembers: map['maxMembers'] ?? 25,
      imageUrl: map['imageUrl'] ?? '',
      creator: map['creator'] ?? '',
      members: restoredMembers,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
      profanityModerationMembers: (map['profanityModerationMembers'] ?? 0) == 1,
      profanityModerationAdmins: (map['profanityModerationAdmins'] ?? 0) == 1,
    );
  }
}
