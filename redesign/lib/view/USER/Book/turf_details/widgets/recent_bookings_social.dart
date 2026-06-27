import 'package:flutter/material.dart';

class RecentBookingsSocial extends StatelessWidget {
  const RecentBookingsSocial({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: const [
          CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage('https://i.pravatar.cc/100'),
          ),
          SizedBox(width: 8),
          CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage('https://i.pravatar.cc/101'),
          ),
          SizedBox(width: 8),
          CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage('https://i.pravatar.cc/102'),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Arjun and 2 others have booked here recently.',
              style: TextStyle(color: Color(0xFFA7A7A7)),
            ),
          ),
        ],
      ),
    );
  }
}
