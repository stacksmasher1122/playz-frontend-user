import 'package:flutter/material.dart';
import '../bookings_screen.dart';
import 'package:redesign/theme/responsive_helper.dart';

class BookingsTabs extends StatelessWidget {
  final TabController controller;
  BookingsTabs({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return TabBar(
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      padding: EdgeInsets.only(left: 16),
      controller: controller,
      indicatorColor: MyBookingsConstants.green,
      labelColor: MyBookingsConstants.green,
      unselectedLabelColor: Colors.white70,
      tabs: [
        Tab(text: 'Upcoming'),
        Tab(text: 'Past'),
        Tab(text: 'Cancelled'),
      ],
    );
  }
}
