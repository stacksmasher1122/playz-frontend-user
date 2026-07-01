import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

Color kCard = Color(0xFF1A1A1A);
Color kMuted = Color(0xFFA7A7A7);

class ActivityRow extends StatelessWidget {
  ActivityRow({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
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

  ActivityTab({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      children: [
        Container(
          width: ResponsiveHelper.w(56),
          height: ResponsiveHelper.h(56),
          decoration: BoxDecoration(color: kCard, shape: BoxShape.circle),
          child: Icon(icon, color: Colors.white),
        ),
        SizedBox(height: 6),
        Text(label, style: TextStyle(color: kMuted, fontSize: 12)),
      ],
    );
  }
}
