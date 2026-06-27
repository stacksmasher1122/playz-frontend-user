import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../qr_in_bookings_screen.dart';
import 'qr_status_badge.dart';

class QrSection extends StatelessWidget {
  final BookingStatus status;
  const QrSection({required this.status});

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
    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final size = constraints.maxWidth * 0.75;
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: QrBookingConstants.surface,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: glowColor.withOpacity(0.35),
                    blurRadius: 5,
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadiusGeometry.all(Radius.circular(10)),
                child: QrImageView(
                  data: 'BOOKING_ID_PZ_8821',
                  size: size,
                  backgroundColor: Colors.white,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        const Text(
          'Show this QR at the venue counter',
          style: TextStyle(color: QrBookingConstants.muted),
        ),
        const SizedBox(height: 10),
        QrStatusBadge(statusText,
            status == BookingStatus.confirmed ? QrBookingConstants.green : QrBookingConstants.red),
        const SizedBox(height: 6),
        const Text(
          'Booking ID: #PZ-8821',
          style: TextStyle(color: QrBookingConstants.muted, fontSize: 12),
        ),
      ],
    );
  }
}
