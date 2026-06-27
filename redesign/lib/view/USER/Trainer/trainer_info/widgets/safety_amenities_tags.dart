import 'package:flutter/material.dart';

const Color kCard = Color(0xFF1A1A1A);

class SafetyAmenitiesTags extends StatelessWidget {
  const SafetyAmenitiesTags({super.key});

  @override
  Widget build(BuildContext context) {
    const items = ['CCTV Monitored', 'First Aid Kit', 'RO Water', 'Change Rooms'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Safety & Amenities',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: items
              .map(
                (e) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: kCard,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    e,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
