import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import '../qr_in_bookings_screen.dart';
import 'qr_status_badge.dart';
import 'package:redesign/theme/responsive_helper.dart';

class QrSection extends StatelessWidget {
  final BookingStatus status;
  final Map<String, dynamic>? bookingData;

  const QrSection({super.key, required this.status, this.bookingData});

  Color get glowColor {
    switch (status) {
      case BookingStatus.confirmed:
        return AppColors.accent;
      case BookingStatus.cancelled:
        return AppColors.error;
      case BookingStatus.expired:
        return AppColors.muted;
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
              padding: EdgeInsets.all(context.widthPct(4)),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(context.minDimensionPct(5)),
                border: Border.all(color: AppColors.borderDark),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(context.minDimensionPct(2.5)),
                child: QrImageView(
                  data: qrData,
                  size: size,
                  backgroundColor: AppColors.textPrimary,
                ),
              ),
            );
          },
        ),
        SizedBox(height: context.heightPct(2)),
        Text(
          'Scan at venue entry counter',
          style: AppTypography.bodySm.copyWith(
            color: AppColors.muted,
            fontSize: context.responsiveFont(13),
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: context.heightPct(1.2)),
        QrStatusBadge(
          statusText,
          status == BookingStatus.confirmed ? AppColors.accent : AppColors.error,
        ),
        SizedBox(height: context.heightPct(0.8)),
        Text(
          'Booking ID: #$bookingId',
          style: AppTypography.bodyXs.copyWith(
            color: AppColors.muted,
            fontSize: context.responsiveFont(12),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
