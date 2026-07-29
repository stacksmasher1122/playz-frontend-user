import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class QrBookingCard extends StatelessWidget {
  final Size size;

  const QrBookingCard({
    super.key,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final qrBoxSize = context.widthPct(55).clamp(180.0, 240.0);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.widthPct(5)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(context.minDimensionPct(5)),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Column(
        children: [
          _verifiedBadge(context),
          SizedBox(height: context.heightPct(2.5)),

          /// QR PLACEHOLDER
          Container(
            width: qrBoxSize,
            constraints: const BoxConstraints(maxWidth: 240),
            padding: EdgeInsets.all(context.widthPct(4)),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.15),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
                child: QrImageView(
                  data: 'PZ-883492-QR|CrossFit Arena|08:00-09:00', // dynamic later
                  version: QrVersions.auto,
                  backgroundColor: Colors.white,
                  dataModuleStyle: const QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.square,
                    color: Colors.black,
                  ),
                  eyeStyle: const QrEyeStyle(
                    eyeShape: QrEyeShape.square,
                    color: Colors.black,
                  ),
                  gapless: false,
                  errorCorrectionLevel: QrErrorCorrectLevel.H,
                ),
              ),
            ),
          ),

          SizedBox(height: context.heightPct(2.5)),

          Text(
            'CrossFit Arena',
            style: AppTypography.headlineSm.copyWith(
              color: AppColors.textPrimary,
              fontSize: context.responsiveFont(18),
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: context.heightPct(0.6)),

          Text(
            'Thu, 4 Dec · 08:00 AM – 09:00 AM',
            style: AppTypography.bodySm.copyWith(
              color: AppColors.muted,
              fontSize: context.responsiveFont(14),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: context.heightPct(0.6)),

          Text(
            'Football · Solo Queue · 4 Players',
            style: AppTypography.bodySm.copyWith(
              color: AppColors.muted,
              fontSize: context.responsiveFont(13),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: context.heightPct(1.8)),

          _bookingId(context),
        ],
      ),
    );
  }

  Widget _verifiedBadge(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.widthPct(3),
        vertical: context.heightPct(0.8),
      ),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(context.minDimensionPct(5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.verified, color: AppColors.accent, size: 16),
          SizedBox(width: context.widthPct(1.5)),
          Text(
            'Verified PlayZ Booking',
            style: AppTypography.labelCaps10.copyWith(
              color: AppColors.accent,
              fontSize: context.responsiveFont(12),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bookingId(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.widthPct(3),
        vertical: context.heightPct(0.8),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.minDimensionPct(5)),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Text(
        'Booking ID: PZ-883492-QR',
        style: AppTypography.bodySm.copyWith(
          color: AppColors.muted,
          fontSize: context.responsiveFont(12),
          fontFamily: 'monospace',
        ),
      ),
    );
  }
}
