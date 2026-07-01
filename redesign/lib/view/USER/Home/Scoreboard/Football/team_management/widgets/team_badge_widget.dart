import 'package:flutter/material.dart';

class TeamBadgeWidget extends StatelessWidget {
  final String logoUrl;

  const TeamBadgeWidget({super.key, required this.logoUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFC6FF00), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFC6FF00).withValues(alpha: 0.2),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.all(4),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(12),
          // Using a placeholder icon as the logoUrl from the dummy data is just a placeholder
          // You would normally use Image.network(logoUrl)
        ),
        child: const Icon(
          Icons.shield,
          color: Colors.greenAccent,
          size: 60,
        ),
      ),
    );
  }
}
