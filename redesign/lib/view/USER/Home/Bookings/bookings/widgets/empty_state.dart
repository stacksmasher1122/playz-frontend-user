import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class BookingsEmptyState extends StatelessWidget {
  final IconData icon;
  final String text;

  BookingsEmptyState({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: Colors.white38),
          SizedBox(height: 12),
          Text(text, style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}
