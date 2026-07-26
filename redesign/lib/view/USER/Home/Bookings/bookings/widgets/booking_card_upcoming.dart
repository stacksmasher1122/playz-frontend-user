import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:redesign/view/USER/Home/Bookings/qr_in_bookings/qr_in_bookings_screen.dart';
import '../bookings_screen.dart';
import 'action_chip.dart';
import 'status_badge.dart';
import 'package:redesign/theme/responsive_helper.dart';

class BookingCardUpcoming extends StatelessWidget {
  final Map<String, dynamic>? bookingData;

  BookingCardUpcoming({super.key, this.bookingData});

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

    final turfName = bookingData?['turfName'] ?? 'Neon Futsal Arena';
    final turfImage = bookingData?['turfImage'] ?? 'https://images.unsplash.com/photo-1517927033932-b3d18e61fb3a';
    final groundName = bookingData?['groundName'] ?? 'Court 4';
    final sport = bookingData?['sport'] ?? '5-a-side';
    final timeSlot = bookingData?['timeSlot'] ?? '20:00 – 21:00';
    final dateFormatted = bookingData?['dateFormatted'] ?? bookingData?['date'] ?? 'Today';
    final address = bookingData?['turfAddress'] ?? 'Local Turf Arena';
    final statusText = (bookingData?['status'] ?? 'CONFIRMED').toString().toUpperCase();

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 6, 16, 12),
      child: Material(
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
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
                      child: Image.network(
                        turfImage,
                        height: ResponsiveHelper.h(56),
                        width: ResponsiveHelper.w(56),
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: ResponsiveHelper.h(56),
                          width: ResponsiveHelper.w(56),
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
                              fontWeight: FontWeight.w700,
                              fontSize: ResponsiveHelper.sp(14),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '$groundName · $sport',
                            style: TextStyle(
                              color: MyBookingsConstants.muted,
                              fontSize: ResponsiveHelper.sp(12),
                            ),
                          ),
                        ],
                      ),
                    ),

                    StatusBadge(statusText, MyBookingsConstants.green),
                  ],
                ),

                SizedBox(height: 10),

                Text(
                  '$dateFormatted · $timeSlot',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: ResponsiveHelper.sp(12),
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(height: 6),

                Text(
                  '📍 $address',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: MyBookingsConstants.muted,
                    fontSize: ResponsiveHelper.sp(12),
                  ),
                ),

                SizedBox(height: 12),

                /// ACTIONS
                Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  children: [
                    ActionChipWidget(
                      Icons.qr_code,
                      'View QR Code',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => BookingQrScreen(bookingData: bookingData),
                          ),
                        );
                      },
                    ),
                    ActionChipWidget(
                      Icons.directions,
                      'Directions',
                      onTap: _launchGoogleMaps,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
