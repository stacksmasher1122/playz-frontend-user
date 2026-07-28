import 'package:flutter/material.dart';
import 'package:redesign/view/USER/Home/Bookings/qr_in_bookings/qr_in_bookings_screen.dart';
import '../bookings_screen.dart';
import 'action_chip.dart';
import 'status_badge.dart';
import 'package:redesign/theme/responsive_helper.dart';

class CancelledBookingCard extends StatelessWidget {
  final Map<String, dynamic>? bookingData;

  const CancelledBookingCard({super.key, this.bookingData});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    final turfName = bookingData?['turfName'] ?? 'PlayZ Arena';
    final turfImage = bookingData?['turfImage'] ?? 'https://images.unsplash.com/photo-1521412644187-c49fa049e84d';
    final groundName = bookingData?['groundName'] ?? 'Court 1';
    final sport = bookingData?['sport'] ?? 'Ground';
    final timeSlot = bookingData?['timeSlot'] ?? '';
    final dateFormatted = bookingData?['dateFormatted'] ?? bookingData?['date'] ?? '';
    final statusText = (bookingData?['status'] ?? 'CANCELLED').toString().toUpperCase();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(18)),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => BookingQrScreen(bookingData: bookingData),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.all(ResponsiveHelper.w(14)),
          decoration: BoxDecoration(
            color: MyBookingsConstants.surface,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(18)),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.08),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// TOP ROW
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
                    child: Image.network(
                      turfImage,
                      height: ResponsiveHelper.h(52),
                      width: ResponsiveHelper.w(52),
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: ResponsiveHelper.h(52),
                        width: ResponsiveHelper.w(52),
                        color: Colors.grey.shade800,
                        child: Icon(Icons.sports_soccer, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          turfName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ResponsiveHelper.sp(15),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '$groundName · $sport',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        SizedBox(height: 6),
                        Text(
                          '$dateFormatted  $timeSlot',
                          style: TextStyle(color: Colors.white54, fontSize: 12),
                        ),
                      ],
                    ),
                  ),

                  StatusBadge(statusText, MyBookingsConstants.red),
                ],
              ),

              SizedBox(height: 14),

              /// BOTTOM ROW
              Row(
                children: [
                  Icon(Icons.cancel_outlined, size: 16, color: MyBookingsConstants.red),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Booking $statusText',
                      style: TextStyle(
                        color: MyBookingsConstants.red,
                        fontSize: ResponsiveHelper.sp(13),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  ActionChipWidget(
                    Icons.info_outline,
                    'Details',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => BookingQrScreen(bookingData: bookingData),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
