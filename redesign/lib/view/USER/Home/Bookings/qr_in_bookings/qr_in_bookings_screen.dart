import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';

import 'widgets/qr_section.dart';
import 'widgets/booking_info_card.dart';
import 'widgets/location_card.dart';
import 'widgets/payment_summary_card.dart';
import 'widgets/qr_action_section.dart';
import 'package:redesign/theme/responsive_helper.dart';

class QrBookingConstants {
  static Color bg = AppColors.background;
  static Color surface = Color(0xFF0E0E0E);
  static Color green = AppColors.accent;
  static Color red = Color(0xFFE53935);
  static Color amber = Color(0xFFF5C542);
  static Color muted = Color(0xFFA7A7A7);
}

enum BookingStatus { confirmed, cancelled, expired }

class BookingQrScreen extends StatelessWidget {
  final Map<String, dynamic>? bookingData;

  const BookingQrScreen({super.key, this.bookingData});

  BookingStatus get status {
    final s = (bookingData?['status'] ?? 'confirmed').toString().toLowerCase();
    if (s == 'cancelled' || s == 'rejected' || s == 'refunded') {
      return BookingStatus.cancelled;
    }
    return BookingStatus.confirmed;
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Scaffold(
      backgroundColor: QrBookingConstants.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            children: [
              // Header
              Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                    Expanded(
                      child: Text(
                        'Booking Details',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontSize: ResponsiveHelper.sp(18),
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
              QrSection(status: status, bookingData: bookingData),
              SizedBox(height: 20),
              BookingInfoCard(bookingData: bookingData),
              SizedBox(height: 12),
              LocationCard(bookingData: bookingData),
              SizedBox(height: 12),
              PaymentSummaryCard(bookingData: bookingData),
              SizedBox(height: 20),
              QrActionSection(status: status, bookingData: bookingData),
              SizedBox(height: 24),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'Need help? Contact Support',
                  style: TextStyle(
                    color: QrBookingConstants.muted,
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
