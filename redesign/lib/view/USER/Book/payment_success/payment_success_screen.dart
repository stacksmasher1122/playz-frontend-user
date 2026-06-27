import 'package:flutter/material.dart';

import 'widgets/booking_reminders.dart';
import 'widgets/confirmation_actions.dart';
import 'widgets/confirmation_venue_card.dart';
import 'widgets/payment_summary_card.dart';
import 'widgets/success_ripple_animation.dart';

const kBg = Colors.black;
const kMuted = Color(0xFFA7A7A7);

class BookingConfirmationScreen extends StatefulWidget {
  const BookingConfirmationScreen({super.key});

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
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _rippleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        top: false,
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 50, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SuccessRippleAnimation(controller: _rippleController),
              const SizedBox(height: 0),
              const Text(
                'Booking Confirmed!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Confirmation sent to john.doe@gmail.com',
                style: TextStyle(color: kMuted),
              ),
              const SizedBox(height: 24),

              ConfirmationVenueCard(size: size),
              const SizedBox(height: 20),

              const PaymentSummaryCard(),
              const SizedBox(height: 20),

              const BookingReminders(),
              const SizedBox(height: 28),

              ConfirmationActions(
                onGoToBookings: () {},
                onInviteFriends: () {},
              ),
              const SizedBox(height: 20),

              GestureDetector(
                onTap: () {},
                child: const Text(
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
