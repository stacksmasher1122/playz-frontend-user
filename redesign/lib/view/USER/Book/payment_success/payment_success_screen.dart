import 'package:flutter/material.dart';

import 'widgets/booking_reminders.dart';
import 'widgets/confirmation_actions.dart';
import 'widgets/confirmation_venue_card.dart';
import 'widgets/payment_summary_card.dart';
import 'widgets/success_ripple_animation.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kBg = Colors.black;
const kMuted = Color(0xFFA7A7A7);

class BookingConfirmationScreen extends StatefulWidget {
  BookingConfirmationScreen({super.key});

  @override
  State<BookingConfirmationScreen> createState() =>
      _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _rippleController;

  @override
  void initState() {
    super.initState();
    _rippleController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _rippleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        top: false,
        bottom: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16, 50, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SuccessRippleAnimation(controller: _rippleController),
              SizedBox(height: 0),
              Text(
                'Booking Confirmed!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.sp(22),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Confirmation sent to john.doe@gmail.com',
                style: TextStyle(color: kMuted),
              ),
              SizedBox(height: 24),

              ConfirmationVenueCard(size: size),
              SizedBox(height: 20),

              PaymentSummaryCard(),
              SizedBox(height: 20),

              BookingReminders(),
              SizedBox(height: 28),

              ConfirmationActions(
                onGoToBookings: () {},
                onInviteFriends: () {},
              ),
              SizedBox(height: 20),

              GestureDetector(
                onTap: () {},
                child: Text(
                  'Need help? Contact Support',
                  style: TextStyle(
                    color: kMuted,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
