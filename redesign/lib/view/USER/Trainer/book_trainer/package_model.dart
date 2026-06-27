import 'package:flutter/material.dart';

class PackageModel {
  final String? badge;
  final Color? badgeColor;
  final String title;
  final String desc;
  final List<String> chips;
  final int price;
  final String billing;
  final int coins;
  final bool highlight;

  PackageModel({
    this.badge,
    this.badgeColor,
    required this.title,
    required this.desc,
    required this.chips,
    required this.price,
    required this.billing,
    required this.coins,
    this.highlight = false,
  });
}
