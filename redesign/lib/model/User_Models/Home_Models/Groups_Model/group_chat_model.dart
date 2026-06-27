import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a single chat message in Groups/{groupId}/chats/{id}
/// Includes senderName and senderPic since group chats display identity per message.
class GroupChatMessageModel {
  final String id;
  final String groupId;
  final String senderEmail;
  final String senderName;
  final String senderPic;
  final String type; // text | image | video | audio | location
  final String content; // text body, download URL, or "lat,lng"
  final DateTime timestamp;
  final bool isRead;
  final String? replyToId;
  final String? replyToContent;
  final String? replyToSender;
  final bool isEdited;
  final String status; // 'pending' | 'sent' | 'flagged'

  GroupChatMessageModel({
    required this.id,
    required this.groupId,
    required this.senderEmail,
    this.senderName = '',
    this.senderPic = '',
    required this.type,
    required this.content,
    DateTime? timestamp,
    this.isRead = false,
    this.replyToId,
    this.replyToContent,
    this.replyToSender,
    this.isEdited = false,
    this.status = 'sent',
  }) : timestamp = timestamp ?? DateTime.now();

  // ── Firestore ──
  factory GroupChatMessageModel.fromMap(
      String docId, String groupId, Map<String, dynamic> map) {
    return GroupChatMessageModel(
      id: docId,
      groupId: groupId,
      senderEmail: map['senderEmail'] ?? '',
      senderName: map['senderName'] ?? '',
      senderPic: map['senderPic'] ?? '',
      type: map['type'] ?? 'text',
      content: map['content'] ?? '',
      timestamp: map['timestamp'] is Timestamp
          ? (map['timestamp'] as Timestamp).toDate()
          : DateTime.tryParse(map['timestamp']?.toString() ?? '') ??
              DateTime.now(),
      isRead: map['isRead'] ?? false,
      replyToId: map['replyToId'],
      replyToContent: map['replyToContent'],
      replyToSender: map['replyToSender'],
      isEdited: map['isEdited'] ?? false,
      status: map['status'] ?? 'sent',
    );
  }

  Map<String, dynamic> toMap() => {
        'senderEmail': senderEmail,
        'senderName': senderName,
        'senderPic': senderPic,
        'type': type,
        'content': content,
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': isRead,
        'replyToId': replyToId,
        'replyToContent': replyToContent,
        'replyToSender': replyToSender,
        'isEdited': isEdited,
        'status': status,
      };

  // ── SQFlite ──
  Map<String, dynamic> toSqfliteMap() => {
        'id': id,
        'groupId': groupId,
        'senderEmail': senderEmail,
        'senderName': senderName,
        'senderPic': senderPic,
        'type': type,
        'content': content,
        'timestamp': timestamp.toIso8601String(),
        'isRead': isRead ? 1 : 0,
        'replyToId': replyToId,
        'replyToContent': replyToContent,
        'replyToSender': replyToSender,
        'isEdited': isEdited ? 1 : 0,
        'status': status,
      };

  factory GroupChatMessageModel.fromSqfliteMap(Map<String, dynamic> map) {
    return GroupChatMessageModel(
      id: map['id'] ?? '',
      groupId: map['groupId'] ?? '',
      senderEmail: map['senderEmail'] ?? '',
      senderName: map['senderName'] ?? '',
      senderPic: map['senderPic'] ?? '',
      type: map['type'] ?? 'text',
      content: map['content'] ?? '',
      timestamp: DateTime.tryParse(map['timestamp']?.toString() ?? '') ??
          DateTime.now(),
      isRead: (map['isRead'] ?? 0) == 1,
      replyToId: map['replyToId'],
      replyToContent: map['replyToContent'],
      replyToSender: map['replyToSender'],
      isEdited: (map['isEdited'] ?? 0) == 1,
      status: map['status'] ?? 'sent',
    );
  }
}
