import 'package:flutter/material.dart';

class PlayerStatusChip extends StatelessWidget {
  final String status;

  const PlayerStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    bool isFit = status.toLowerCase() == 'fit';
    
    return Text(
      status.toUpperCase(),
      style: TextStyle(
        color: isFit ? const Color(0xFFC6FF00) : Colors.red,
        fontSize: 12,
        fontWeight: FontWeight.w900,
        letterSpacing: 0.5,
      ),
    );
  }
}
