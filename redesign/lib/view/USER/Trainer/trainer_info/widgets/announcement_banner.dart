import 'package:flutter/material.dart';

const Color kYellow = Color(0xFFFFC107);

class AnnouncementBanner extends StatelessWidget {
  const AnnouncementBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kYellow.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: const [
          Icon(Icons.campaign, color: kYellow),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Summer Camp Registration Open!\nBatch starts 10th Feb • Limited slots',
              style: TextStyle(color: kYellow),
            ),
          ),
        ],
      ),
    );
  }
}
