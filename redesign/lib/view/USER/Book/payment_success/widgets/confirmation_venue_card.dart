import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/view/USER/Home/Bookings/qr_in_bookings/qr_in_bookings_screen.dart';
import 'package:shimmer/shimmer.dart';
import 'notched_dashed_divider.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ConfirmationVenueCard extends StatelessWidget {
  final Size size;
  final Map<String, dynamic>? bookingData;

  const ConfirmationVenueCard({super.key, required this.size, this.bookingData});

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
        color: AppColors.card,
        borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IMAGE
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(context.minDimensionPct(4))),
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: turfImage,
                  height: context.widthPct(45).clamp(160.0, 240.0),
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Shimmer.fromColors(
                    baseColor: AppColors.surfaceElevated,
                    highlightColor: AppColors.borderDark,
                    child: Container(color: AppColors.surface),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    height: context.widthPct(45).clamp(160.0, 240.0),
                    color: AppColors.surface,
                    child: const Icon(Icons.sports_soccer, size: 50, color: AppColors.textPrimary),
                  ),
                ),
                Positioned(
                  top: context.heightPct(1.5),
                  right: context.widthPct(3),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.widthPct(3),
                      vertical: context.heightPct(0.8),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.background.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(context.minDimensionPct(5)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.sports_soccer, color: AppColors.accent, size: 16),
                        SizedBox(width: context.widthPct(1.5)),
                        Text(
                          sport,
                          style: AppTypography.headlineSm.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: context.responsiveFont(12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(vertical: context.heightPct(2)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
                  child: Text(
                    turfName,
                    style: AppTypography.headlineSm.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: context.responsiveFont(18),
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: context.heightPct(0.5)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
                  child: Text(
                    'ID: #$bookingId',
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.muted,
                      fontFamily: 'monospace',
                      fontSize: context.responsiveFont(13),
                    ),
                  ),
                ),

                SizedBox(height: context.heightPct(2)),

                /// NOTCHED DASHED DIVIDER
                const NotchedDashedDivider(),

                SizedBox(height: context.heightPct(2)),

                _infoRow(context, 'Date', dateFormatted),
                _infoRow(context, 'Time', timeSlot),
                _infoRow(context, 'Location', location),
                SizedBox(height: context.heightPct(1.5)),
                _qrBlock(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: context.heightPct(0.6),
        horizontal: context.widthPct(4),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTypography.bodySm.copyWith(
                color: AppColors.muted,
                fontSize: context.responsiveFont(13),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.headlineSm.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: context.responsiveFont(13),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _qrBlock(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => BookingQrScreen(bookingData: bookingData),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.all(context.widthPct(3)),
          decoration: BoxDecoration(
            color: AppColors.accent.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
            border: Border.all(color: AppColors.accent, width: 1.2),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.qr_code_scanner, color: AppColors.accent, size: 18),
                        SizedBox(width: context.widthPct(1.5)),
                        Text(
                          'Scan at Entry',
                          style: AppTypography.headlineSm.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: context.responsiveFont(14),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: context.heightPct(0.5)),
                    Text(
                      'Tap to view your entry QR code',
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.muted,
                        fontSize: context.responsiveFont(12),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(context.minDimensionPct(2.5)),
                  color: AppColors.textPrimary,
                ),
                width: context.minDimensionPct(13).clamp(44.0, 56.0),
                height: context.minDimensionPct(13).clamp(44.0, 56.0),
                child: const Icon(Icons.qr_code_2, size: 36, color: AppColors.background),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
