import 'package:flutter/material.dart';

enum TimelineEventType { point, ace, block, substitution, timeout, yellowCard, redCard }

class TimelineEventModel {
  final String id;
  final TimelineEventType type;
  final String title;
  final String description;
  final String time;
  final String scoreAtTime;
  final bool isTeamA;

  TimelineEventModel({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.time,
    required this.scoreAtTime,
    required this.isTeamA,
  });
}
