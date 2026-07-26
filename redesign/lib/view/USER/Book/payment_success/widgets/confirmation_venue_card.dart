import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/view/USER/Home/Bookings/qr_in_bookings/qr_in_bookings_screen.dart';
import 'package:shimmer/shimmer.dart';
import 'notched_dashed_divider.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ConfirmationVenueCard extends StatelessWidget {
  final Size size;
  final Map<String, dynamic>? bookingData;

  ConfirmationVenueCard({super.key, required this.size, this.bookingData});

  static const _kCard = Color(0xFF1A1A1A);
  static const _kGreen = AppColors.accent;
  static const _kMuted = Color(0xFFA7A7A7);
  static const _kYellow = Color(0xFFFFC107);

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    final turfName = bookingData?['turfName'] ?? 'PlayZ Arena';
    final turfImage = bookingData?['turfImage'] ?? 'https://images.unsplash.com/photo-1546519638-68e109498ffc';
    final bookingId = bookingData?['bookingId'] ?? 'PLZ_883492';
    final dateFormatted = bookingData?['dateFormatted'] ?? bookingData?['date'] ?? 'Today';
    final timeSlot = bookingData?['timeSlot'] ?? '08:00 – 09:00 AM';
    final sport = bookingData?['sport'] ?? 'Football';
    final location = bookingData?['turfAddress'] ?? 'Local Turf Arena';

    return Container(
      decoration: BoxDecoration(
        color: _kCard,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IMAGE
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(ResponsiveHelper.w(16))),
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: turfImage,
                  height: size.width * 0.45,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Shimmer.fromColors(
                    baseColor: Colors.grey.shade900,
                    highlightColor: Colors.grey.shade800,
                    child: Container(color: Colors.black),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    height: size.width * 0.45,
                    color: Colors.grey.shade900,
                    child: Icon(Icons.sports_soccer, size: 50, color: Colors.white),
                  ),
                ),
                Positioned(
                  top: ResponsiveHelper.h(12),
                  right: ResponsiveHelper.w(12),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.sports_soccer, color: _kGreen, size: 16),
                        SizedBox(width: 6),
                        Text(
                          sport,
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
                  child: Text(
                    turfName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ResponsiveHelper.sp(18),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 4),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
                  child: Text(
                    'ID: #$bookingId',
                    style: TextStyle(color: _kMuted, fontFamily: 'monospace'),
                  ),
                ),

                SizedBox(height: 16),

                /// NOTCHED DASHED DIVIDER
                NotchedDashedDivider(),

                SizedBox(height: 16),

                _infoRow('Date', dateFormatted),
                _infoRow('Time', timeSlot),
                _infoRow('Location', location),
                SizedBox(height: 8),
                _weatherCard(),
                SizedBox(height: 12),
                _qrBlock(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(6), horizontal: ResponsiveHelper.w(16)),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: TextStyle(color: _kMuted)),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _weatherCard() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
      child: Container(
        padding: EdgeInsets.all(ResponsiveHelper.w(12)),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
        ),
        child: Row(
          children: [
            Icon(Icons.wb_sunny, color: _kYellow),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                '24°C • Good match conditions',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _qrBlock(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => BookingQrScreen(bookingData: bookingData),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.all(ResponsiveHelper.w(12)),
          decoration: BoxDecoration(
            color: Color(0xFF1E3A2B),
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
            border: Border.all(color: Colors.greenAccent, width: 1.2),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.qr_code_scanner, color: Colors.greenAccent, size: 18),
                        SizedBox(width: 6),
                        Text(
                          'Scan at Entry',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: ResponsiveHelper.sp(14),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Tap to view your entry QR code',
                      style: TextStyle(color: _kMuted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(10)),
                  color: Colors.white,
                ),
                width: ResponsiveHelper.w(52),
                height: ResponsiveHelper.h(52),
                child: Icon(Icons.qr_code_2, size: 38, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
