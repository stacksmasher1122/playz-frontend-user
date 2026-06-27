import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';

import 'widgets/qr_section.dart';
import 'widgets/booking_info_card.dart';
import 'widgets/location_card.dart';
import 'widgets/payment_summary_card.dart';
import 'widgets/qr_weather_alert.dart';
import 'widgets/qr_action_section.dart';

class QrBookingConstants {
  static const Color bg = AppColors.background;
  static const Color surface = Color(0xFF0E0E0E);
  static const Color green = AppColors.accent;
  static const Color red = Color(0xFFE53935);
  static const Color amber = Color(0xFFF5C542);
  static const Color muted = Color(0xFFA7A7A7);
}

enum BookingStatus { confirmed, cancelled, expired }

class BookingQrScreen extends StatelessWidget {
  const BookingQrScreen({super.key});

  final BookingStatus status = BookingStatus.confirmed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: QrBookingConstants.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            children: [
              // Header (moved from AppBar into the scrollable body)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                    const Expanded(
                      child: Text(
                        'Booking Details',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.share_outlined, color: Colors.white),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 12),
                  ],
                ),
              ),
              QrSection(status: status),
              const SizedBox(height: 20),
              BookingInfoCard(),
              const SizedBox(height: 12),
              LocationCard(),
              const SizedBox(height: 12),
              PaymentSummaryCard(),
              const SizedBox(height: 12),
              const QrWeatherAlert(),
              const SizedBox(height: 20),
              QrActionSection(status: status),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () {},
                child: const Text(
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
