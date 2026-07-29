import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'qr_card.dart';
import 'package:redesign/theme/responsive_helper.dart';

class LocationCard extends StatelessWidget {
  final Map<String, dynamic>? bookingData;

  const LocationCard({super.key, this.bookingData});

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

    final address = bookingData?['turfAddress'] ?? bookingData?['address'] ?? 'Local Turf Arena';
    final turfName = bookingData?['turfName'] ?? 'Venue';

    return QrCard(
      title: 'Location',
      trailing: Text(
        turfName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTypography.bodySm.copyWith(
          color: AppColors.accent,
          fontWeight: FontWeight.w600,
          fontSize: context.responsiveFont(13),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            address,
            style: AppTypography.bodySm.copyWith(
              color: AppColors.muted,
              fontSize: context.responsiveFont(13),
            ),
          ),
          SizedBox(height: context.heightPct(1.5)),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.background,
              foregroundColor: AppColors.textPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
              ),
            ),
            onPressed: _launchGoogleMaps,
            icon: const Icon(Icons.near_me_outlined),
            label: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'Get Directions',
                style: AppTypography.bodySm.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
