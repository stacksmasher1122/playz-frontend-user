import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../qr_in_bookings_screen.dart';
import 'qr_status_badge.dart';
import 'package:redesign/theme/responsive_helper.dart';

class QrSection extends StatelessWidget {
  final BookingStatus status;
  final Map<String, dynamic>? bookingData;

  QrSection({super.key, required this.status, this.bookingData});

  Color get glowColor {
    switch (status) {
      case BookingStatus.confirmed:
        return QrBookingConstants.green;
      case BookingStatus.cancelled:
        return QrBookingConstants.red;
      case BookingStatus.expired:
        return Colors.white24;
    }
  }

  String get statusText {
    switch (status) {
      case BookingStatus.confirmed:
        return 'CONFIRMED';
      case BookingStatus.cancelled:
        return 'CANCELLED';
      case BookingStatus.expired:
        return 'EXPIRED';
    }
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    final qrData = bookingData?['qrData'] ?? bookingData?['bookingId'] ?? 'BOOKING_ID_PZ_8821';
    final bookingId = bookingData?['bookingId'] ?? 'PZ-8821';

    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final size = constraints.maxWidth * 0.72;
            return Container(
              padding: EdgeInsets.all(ResponsiveHelper.w(16)),
              decoration: BoxDecoration(
                color: QrBookingConstants.surface,
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(22)),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                boxShadow: [
                  BoxShadow(
                    color: glowColor.withValues(alpha: 0.35),
                    blurRadius: 12,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(ResponsiveHelper.w(10))),
                child: QrImageView(
                  data: qrData,
                  size: size,
                  backgroundColor: Colors.white,
                ),
              ),
            );
          },
        ),
        SizedBox(height: 16),
        Text(
          'Scan at venue entry counter',
          style: TextStyle(
            color: QrBookingConstants.muted,
            fontSize: ResponsiveHelper.sp(13),
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 10),
        QrStatusBadge(
          statusText,
          status == BookingStatus.confirmed ? QrBookingConstants.green : QrBookingConstants.red,
        ),
        SizedBox(height: 6),
        Text(
          'Booking ID: #$bookingId',
          style: TextStyle(
            color: QrBookingConstants.muted,
            fontSize: ResponsiveHelper.sp(12),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
