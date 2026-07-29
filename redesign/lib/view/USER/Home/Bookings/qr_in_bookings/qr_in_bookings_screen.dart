import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

import 'widgets/qr_section.dart';
import 'widgets/booking_info_card.dart';
import 'widgets/location_card.dart';
import 'widgets/payment_summary_card.dart';
import 'widgets/qr_action_section.dart';

class QrBookingConstants {
  static Color bg = AppColors.background;
  static Color surface = AppColors.surface;
  static Color green = AppColors.accent;
  static Color red = AppColors.error;
  static Color amber = Colors.amber;
  static Color muted = AppColors.muted;
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
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            context.widthPct(4),
            context.heightPct(1),
            context.widthPct(4),
            context.heightPct(3),
          ),
          child: Column(
            children: [
              // Header
              Padding(
                padding: EdgeInsets.only(bottom: context.heightPct(1)),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                    Expanded(
                      child: Text(
                        'Booking Details',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.headlineSm.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                          fontSize: context.responsiveFont(18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              QrSection(status: status, bookingData: bookingData),
              SizedBox(height: context.heightPct(2.5)),
              BookingInfoCard(bookingData: bookingData),
              SizedBox(height: context.heightPct(1.5)),
              LocationCard(bookingData: bookingData),
              SizedBox(height: context.heightPct(1.5)),
              PaymentSummaryCard(bookingData: bookingData),
              SizedBox(height: context.heightPct(2.5)),
              QrActionSection(status: status, bookingData: bookingData),
              SizedBox(height: context.heightPct(3)),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'Need help? Contact Support',
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.muted,
                    fontSize: context.responsiveFont(13),
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
