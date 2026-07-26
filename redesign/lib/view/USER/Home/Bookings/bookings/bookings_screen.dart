import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';

import 'widgets/bookings_header.dart';
import 'widgets/bookings_tabs.dart';
import 'widgets/upcoming_bookings.dart';
import 'widgets/past_bookings.dart';
import 'widgets/cancelled_bookings.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MyBookingsConstants {
  static Color bg = AppColors.background;
  static Color surface = Color(0xFF0E0E0E);
  static Color green = AppColors.accent;
  static Color muted = Colors.white70;
  static Color red = Color(0xFFE53935);
  static Color amber = Color(0xFFFFB300);
}

class MyBookingsScreen extends StatefulWidget {
  MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Scaffold(
      backgroundColor: MyBookingsConstants.bg,
      body: SafeArea(
        child: Column(
          children: [
            BookingsHeader(),
            BookingsTabs(controller: _tabController),
            SizedBox(height: 8),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  UpcomingBookingsWidget(),
                  PastBookingsWidget(),
                  CancelledBookingsWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
