import 'package:cloud_firestore/cloud_firestore.dart';

class GroupRequestModel {
  final String senderEmail;
  final String senderName;
  final String senderPic;
  final String groupId;
  final DateTime timestamp;

  GroupRequestModel({
    required this.senderEmail,
    required this.senderName,
    required this.senderPic,
    required this.groupId,
    required this.timestamp,
  });

  // ── Convert to Map for Firestore ──
  Map<String, dynamic> toMap() {
    return {
      'senderEmail': senderEmail,
      'senderName': senderName,
      'senderPic': senderPic,
      'groupId': groupId,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  // ── Create from Firestore ──
  factory GroupRequestModel.fromMap(Map<String, dynamic> map) {
    return GroupRequestModel(
      senderEmail: map['senderEmail'] ?? '',
      senderName: map['senderName'] ?? '',
      senderPic: map['senderPic'] ?? '',
      groupId: map['groupId'] ?? '',
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
