import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/view/USER/Home/Bookings/qr_in_bookings/qr_in_bookings_screen.dart';
import 'action_chip.dart';
import 'rate_review_bottom_sheet.dart';
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
    final imageSize = context.minDimensionPct(13).clamp(44.0, 56.0);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => BookingQrScreen(bookingData: bookingData),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.all(context.widthPct(3.5)),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
            border: Border.all(color: AppColors.borderDark),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// TOP ROW
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
                    child: Image.network(
                      turfImage,
                      height: imageSize,
                      width: imageSize,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: imageSize,
                        width: imageSize,
                        color: AppColors.surface,
                        child: const Icon(Icons.sports_soccer, color: AppColors.textPrimary),
                      ),
                    ),
                  ),
                  SizedBox(width: context.widthPct(3)),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          turfName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.headlineSm.copyWith(
                            color: AppColors.textPrimary,
                            fontSize: context.responsiveFont(15),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: context.heightPct(0.4)),
                        Text(
                          '$groundName · $sport',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.bodySm.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: context.responsiveFont(12),
                          ),
                        ),
                        SizedBox(height: context.heightPct(0.6)),
                        Text(
                          '$dateFormatted  $timeSlot',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.bodyXs.copyWith(
                            color: AppColors.muted,
                            fontSize: context.responsiveFont(12),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: context.widthPct(2)),
                  const StatusBadge('COMPLETED', AppColors.accent),
                ],
              ),

              SizedBox(height: context.heightPct(1.5)),

              /// ACTION BUTTONS ROW
              Row(
                children: [
                  ActionChipWidget(
                    Icons.location_on_outlined,
                    '',
                    onTap: _launchGoogleMaps,
                    outlined: true,
                  ),
                  SizedBox(width: context.widthPct(2)),
                  ActionChipWidget(
                    Icons.qr_code_2,
                    'QR Code',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => BookingQrScreen(bookingData: bookingData),
                        ),
                      );
                    },
                    outlined: false,
                  ),
                  SizedBox(width: context.widthPct(2)),
                  Expanded(
                    child: ActionChipWidget(
                      (bookingData?['isReviewed'] == true ||
                              bookingData?['userRating'] != null ||
                              bookingData?['rating'] != null)
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      'Rate',
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) =>
                              RateReviewBottomSheet(bookingData: bookingData),
                        );
                      },
                      outlined: true,
                    ),
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
