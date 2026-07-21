import 'package:cloud_firestore/cloud_firestore.dart';

class BracketMatchModel {
  final String id;
  final int round;
  final String? teamAId; // nullable for byes
  final String? teamBId;
  final DateTime? scheduledDate;
  final String status; // 'unscheduled', 'scheduled', 'completed'
  final String? winnerId;
  final String? groupName; // Used for group stage matches

  BracketMatchModel({
    required this.id,
    required this.round,
    this.teamAId,
    this.teamBId,
    this.scheduledDate,
    required this.status,
    this.winnerId,
    this.groupName,
  });

  Map<String, dynamic> toMap() {
    return {
      'round': round,
      'teamAId': teamAId,
      'teamBId': teamBId,
      'scheduledDate': scheduledDate != null ? Timestamp.fromDate(scheduledDate!) : null,
      'status': status,
      'winnerId': winnerId,
      'groupName': groupName,
    };
  }

  factory BracketMatchModel.fromMap(String id, Map<String, dynamic> map) {
    return BracketMatchModel(
      id: id,
      round: map['round'] ?? 1,
      teamAId: map['teamAId'],
      teamBId: map['teamBId'],
      scheduledDate: map['scheduledDate'] != null ? (map['scheduledDate'] as Timestamp).toDate() : null,
      status: map['status'] ?? 'unscheduled',
      winnerId: map['winnerId'],
      groupName: map['groupName'],
    );
  }
}
