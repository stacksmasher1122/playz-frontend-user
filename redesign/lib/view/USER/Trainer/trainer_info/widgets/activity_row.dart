import 'package:flutter/material.dart';

const Color kCard = Color(0xFF1A1A1A);
const Color kMuted = Color(0xFFA7A7A7);

class ActivityRow extends StatelessWidget {
  const ActivityRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          ActivityTab(icon: Icons.sports_cricket, label: 'Cricket'),
          ActivityTab(icon: Icons.fitness_center, label: 'Fitness'),
          ActivityTab(icon: Icons.emoji_events, label: 'Matches'),
        ],
      ),
    );
  }
}

class ActivityTab extends StatelessWidget {
  final IconData icon;
  final String label;

  const ActivityTab({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: const BoxDecoration(color: kCard, shape: BoxShape.circle),
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(color: kMuted, fontSize: 12)),
      ],
    );
  }
}
