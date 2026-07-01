import 'package:flutter/material.dart';
import '../bookings_screen.dart';
import 'package:redesign/theme/responsive_helper.dart';

class BookingsHeader extends StatelessWidget {
  BookingsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Bookings',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.sp(22),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Upcoming sessions & history',
                  style: TextStyle(color: MyBookingsConstants.muted, fontSize: 13),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
          CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(
              'https://randomuser.me/api/portraits/men/32.jpg',
            ),
          ),
        ],
      ),
    );
  }
}
