import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/view/USER/Home/Bookings/qr_in_bookings/qr_in_bookings_screen.dart';
import 'package:redesign/view/USER/Navigation/user_navigation.dart';

import 'widgets/booking_reminders.dart';
import 'widgets/confirmation_actions.dart';
import 'widgets/confirmation_venue_card.dart';
import 'widgets/payment_summary_card.dart';
import 'widgets/success_ripple_animation.dart';
import 'package:redesign/theme/responsive_helper.dart';

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
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _rippleController.dispose();
    super.dispose();
  }

  void _navigateToBook() {
    if (Get.isRegistered<UserNavController>()) {
      Get.find<UserNavController>().changeTab(1);
    }
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => const UserAppNavShell(initialIndex: 1),
      ),
      (route) => false,
    );
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
          _navigateToBook();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            onPressed: _navigateToBook,
          ),
        ),
        body: SafeArea(
          top: false,
          bottom: false,
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              context.widthPct(4),
              context.heightPct(2),
              context.widthPct(4),
              context.heightPct(4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SuccessRippleAnimation(controller: _rippleController),
                SizedBox(height: context.heightPct(1)),
                Text(
                  'Booking Confirmed!',
                  style: AppTypography.displayLg.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: context.responsiveFont(22),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: context.heightPct(0.8)),
                Text(
                  'Confirmation & QR ticket generated for $userEmail',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.muted,
                    fontSize: context.responsiveFont(12),
                  ),
                ),
                SizedBox(height: context.heightPct(3)),

                ConfirmationVenueCard(size: size, bookingData: widget.bookingData),
                SizedBox(height: context.heightPct(2.5)),

                PaymentSummaryCard(bookingData: widget.bookingData),
                SizedBox(height: context.heightPct(2.5)),

                const BookingReminders(),
                SizedBox(height: context.heightPct(3.5)),

                ConfirmationActions(
                  onGoToBookings: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => BookingQrScreen(bookingData: widget.bookingData),
                      ),
                    );
                  },
                ),
                SizedBox(height: context.heightPct(2.5)),

                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Need help? Contact Support',
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.muted,
                      decoration: TextDecoration.underline,
                      fontSize: context.responsiveFont(13),
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
