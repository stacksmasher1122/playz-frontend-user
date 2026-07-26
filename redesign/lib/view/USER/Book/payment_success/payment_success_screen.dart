import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/view/USER/Home/Bookings/qr_in_bookings/qr_in_bookings_screen.dart';
import 'package:redesign/view/USER/Navigation/user_navigation.dart';

import 'widgets/booking_reminders.dart';
import 'widgets/confirmation_actions.dart';
import 'widgets/confirmation_venue_card.dart';
import 'widgets/payment_summary_card.dart';
import 'widgets/success_ripple_animation.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kBg = Colors.black;
const kMuted = Color(0xFFA7A7A7);

class BookingConfirmationScreen extends StatefulWidget {
  final Map<String, dynamic>? bookingData;

  const BookingConfirmationScreen({super.key, this.bookingData});

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

  void _navigateToHome() {
    Get.offAll(() => UserAppNavShell());
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final size = MediaQuery.of(context).size;
    final userEmail = widget.bookingData?['userEmail'] ?? 'your email';

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _navigateToHome();
        }
      },
      child: Scaffold(
        backgroundColor: kBg,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: _navigateToHome,
          ),
        ),
        body: SafeArea(
          top: false,
          bottom: false,
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 32),
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
                  'Confirmation & QR ticket generated for $userEmail',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: kMuted, fontSize: ResponsiveHelper.sp(12)),
                ),
                SizedBox(height: 24),

                ConfirmationVenueCard(size: size, bookingData: widget.bookingData),
                SizedBox(height: 20),

                PaymentSummaryCard(bookingData: widget.bookingData),
                SizedBox(height: 20),

                BookingReminders(),
                SizedBox(height: 28),

                ConfirmationActions(
                  onGoToBookings: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => BookingQrScreen(bookingData: widget.bookingData),
                      ),
                    );
                  },
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
      ),
    );
  }
}
