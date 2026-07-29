import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

import 'widgets/bookings_header.dart';
import 'widgets/bookings_tabs.dart';
import 'widgets/upcoming_bookings.dart';
import 'widgets/past_bookings.dart';
import 'widgets/cancelled_bookings.dart';

class MyBookingsConstants {
  static Color bg = AppColors.background;
  static Color surface = AppColors.card;
  static Color green = AppColors.accent;
  static Color muted = AppColors.muted;
  static Color red = AppColors.error;
  static Color amber = Colors.amber;
}

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

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
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const BookingsHeader(),
            BookingsTabs(controller: _tabController),
            SizedBox(height: context.heightPct(1)),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
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
