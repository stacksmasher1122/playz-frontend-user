import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class RecentBookingsSocial extends StatelessWidget {
  RecentBookingsSocial({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
      child: Row(
        children: [
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
