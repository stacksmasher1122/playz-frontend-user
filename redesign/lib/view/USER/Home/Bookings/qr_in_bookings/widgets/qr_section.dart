import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../qr_in_bookings_screen.dart';
import 'qr_status_badge.dart';
import 'package:redesign/theme/responsive_helper.dart';

class QrSection extends StatelessWidget {
  final BookingStatus status;
  QrSection({super.key, required this.status});

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
    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final size = constraints.maxWidth * 0.75;
            return Container(
              padding: EdgeInsets.all(ResponsiveHelper.w(16)),
              decoration: BoxDecoration(
                color: QrBookingConstants.surface,
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(22)),
                boxShadow: [
                  BoxShadow(
                    color: glowColor.withValues(alpha: 0.35),
                    blurRadius: 5,
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadiusGeometry.all(Radius.circular(ResponsiveHelper.w(10))),
                child: QrImageView(
                  data: 'BOOKING_ID_PZ_8821',
                  size: size,
                  backgroundColor: Colors.white,
                ),
              ),
            );
          },
        ),
        SizedBox(height: 12),
        Text(
          'Show this QR at the venue counter',
          style: TextStyle(color: QrBookingConstants.muted),
        ),
        SizedBox(height: 10),
        QrStatusBadge(statusText,
            status == BookingStatus.confirmed ? QrBookingConstants.green : QrBookingConstants.red),
        SizedBox(height: 6),
        Text(
          'Booking ID: #PZ-8821',
          style: TextStyle(color: QrBookingConstants.muted, fontSize: 12),
        ),
      ],
    );
  }
}
