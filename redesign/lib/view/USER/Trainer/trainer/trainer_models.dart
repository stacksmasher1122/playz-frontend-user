import 'package:flutter/material.dart';

enum EntityType { trainer, academy }

class DiscoveryItem {
  final String name;
  final String subtitle;
  final double rating;
  final EntityType type;
  final List<String> images;
  final List<String> tags;
  final List<IconData> sports;

  const DiscoveryItem({
    required this.name,
    required this.subtitle,
    required this.rating,
    required this.type,
    required this.images,
    required this.tags,
    required this.sports,
  });
}
