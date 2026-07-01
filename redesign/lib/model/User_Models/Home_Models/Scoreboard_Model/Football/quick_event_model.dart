import 'package:flutter/material.dart';

class QuickEventModel {
  final String title;
  final IconData icon;
  final Color? color;
  final String eventType;

  const QuickEventModel({
    required this.title,
    required this.icon,
    this.color,
    required this.eventType,
  });

  QuickEventModel copyWith({
    String? title,
    IconData? icon,
    Color? color,
    String? eventType,
  }) {
    return QuickEventModel(
      title: title ?? this.title,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      eventType: eventType ?? this.eventType,
    );
  }
}
