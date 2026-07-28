import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:redesign/view/USER/Home/Bookings/qr_in_bookings/qr_in_bookings_screen.dart';
import '../bookings_screen.dart';
import 'action_chip.dart';
import 'status_badge.dart';
import 'package:redesign/theme/responsive_helper.dart';

class CompletedBookingCard extends StatelessWidget {
  final Map<String, dynamic>? bookingData;

  const CompletedBookingCard({super.key, this.bookingData});

  Future<void> _launchGoogleMaps() async {
    final turfName = bookingData?['turfName'] ?? '';
    final address = bookingData?['turfAddress'] ?? bookingData?['address'] ?? '';
    final query = Uri.encodeComponent('$turfName $address'.trim());
    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    final turfName = bookingData?['turfName'] ?? 'PlayZ Arena';
    final turfImage = bookingData?['turfImage'] ?? 'https://images.unsplash.com/photo-1517649763962-0c623066013b';
    final groundName = bookingData?['groundName'] ?? 'Court 1';
    final sport = bookingData?['sport'] ?? 'Ground';
    final timeSlot = bookingData?['timeSlot'] ?? '';
    final dateFormatted = bookingData?['dateFormatted'] ?? bookingData?['date'] ?? '';
    final amount = bookingData?['amount'] ?? 0;

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
                          '$dateFormatted  $timeSlot  •  ₹$amount Paid',
                          style: TextStyle(color: Colors.white54, fontSize: 12),
                        ),
                      ],
                    ),
                  ),

                  StatusBadge(
                    'COMPLETED',
                    Colors.white24,
                    textColor: Colors.white70,
                  ),
                ],
              ),

              SizedBox(height: 14),

              /// ACTIONS
              Row(
                children: [
                  ActionChipWidget(Icons.directions, 'Directions', onTap: _launchGoogleMaps),
                  Spacer(),
                  ActionChipWidget(
                    Icons.qr_code,
                    'View Pass',
                    outlined: true,
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
