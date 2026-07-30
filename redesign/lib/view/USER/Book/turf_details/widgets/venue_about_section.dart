import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class VenueAboutSection extends StatelessWidget {
  final String description;
  final double latitude;
  final double longitude;
  final String fullAddress;
  final bool isExpanded;
  final VoidCallback onToggleExpand;

  const VenueAboutSection({
    super.key,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.fullAddress,
    required this.isExpanded,
    required this.onToggleExpand,
  });

  Future<void> _openGoogleMaps() async {
    Uri uri;
    if (latitude != 0 && longitude != 0) {
      uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
    } else {
      final query = Uri.encodeComponent(fullAddress.isNotEmpty ? fullAddress : 'Turf');
      uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');
    }

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(uri);
      }
    } catch (e) {
      debugPrint('🔴 [VenueAboutSection] Could not launch maps: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final mapHeight = context.heightPct(20).clamp(140.0, 180.0);
    final displayDescription = description.trim().isNotEmpty
        ? description
        : 'Welcome to this premium sports facility! Enjoy top-tier grounds with professional floodlights, high-quality turf surface, and complete amenities for the ultimate playing experience.';

    final rules = const [
      'Please wear appropriate sports shoes (non-marking for indoor, rubber studs for outdoor).',
      'Arrive 10-15 minutes prior to your booked slot time.',
      'Smoking, alcohol, and glass containers are strictly prohibited on the turf.',
      'Maintain ground cleanliness and dispose of waste in designated bins.',
      'Full refund if cancelled at least 5 days prior to slot booking time.',
    ];

    const String darkMapStyle = '''
    [
      {"elementType":"geometry","stylers":[{"color":"#212121"}]},
      {"elementType":"labels.icon","stylers":[{"visibility":"off"}]},
      {"elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},
      {"elementType":"labels.text.stroke","stylers":[{"color":"#212121"}]},
      {"featureType":"water","elementType":"geometry","stylers":[{"color":"#000000"}]}
    ]
    ''';

    final bool hasValidCoords = latitude != 0 && longitude != 0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About Venue',
            style: AppTypography.headlineSm.copyWith(
              color: AppColors.textPrimary,
              fontSize: context.responsiveFont(18),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: context.heightPct(0.8)),
          Text(
            displayDescription,
            maxLines: isExpanded ? null : 3,
            overflow: isExpanded ? null : TextOverflow.ellipsis,
            style: AppTypography.bodySm.copyWith(
              color: AppColors.muted,
              fontSize: context.responsiveFont(14),
              height: 1.4,
            ),
          ),
          if (displayDescription.length > 100)
            GestureDetector(
              onTap: onToggleExpand,
              child: Padding(
                padding: EdgeInsets.only(top: context.heightPct(0.5)),
                child: Text(
                  isExpanded ? 'Read less' : 'Read more',
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.accent,
                    fontSize: context.responsiveFont(13),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          SizedBox(height: context.heightPct(2)),

          /// GROUND RULES
          Text(
            'Ground Rules',
            style: AppTypography.headlineSm.copyWith(
              color: AppColors.textPrimary,
              fontSize: context.responsiveFont(16),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: context.heightPct(0.8)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: rules.map((rule) {
              return Padding(
                padding: EdgeInsets.only(bottom: context.heightPct(0.6)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold)),
                    Expanded(
                      child: Text(
                        rule,
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.muted,
                          fontSize: context.responsiveFont(13),
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),

          SizedBox(height: context.heightPct(2)),

          /// REAL GOOGLE MAPS LOCATION PREVIEW
          GestureDetector(
            onTap: _openGoogleMaps,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
                border: Border.all(color: AppColors.borderDark),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
                child: Stack(
                  children: [
                    SizedBox(
                      height: mapHeight,
                      width: double.infinity,
                      child: hasValidCoords
                          ? AbsorbPointer(
                              child: GoogleMap(
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(latitude, longitude),
                                  zoom: 14,
                                ),
                                markers: {
                                  Marker(
                                    markerId: const MarkerId('turf_location'),
                                    position: LatLng(latitude, longitude),
                                  ),
                                },
                                myLocationEnabled: false,
                                myLocationButtonEnabled: false,
                                zoomControlsEnabled: false,
                                compassEnabled: false,
                                mapToolbarEnabled: false,
                                style: darkMapStyle,
                              ),
                            )
                          : Container(
                              color: AppColors.surface,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.location_on, color: AppColors.accent, size: 32),
                                    const SizedBox(height: 6),
                                    Text(
                                      fullAddress.isNotEmpty ? fullAddress : 'Venue Location',
                                      style: AppTypography.bodySm.copyWith(color: AppColors.textSecondary),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ),
                    Positioned(
                      bottom: context.heightPct(1.2),
                      right: context.widthPct(3),
                      child: ElevatedButton.icon(
                        onPressed: _openGoogleMaps,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: AppColors.background,
                          backgroundColor: AppColors.accent,
                          padding: EdgeInsets.symmetric(
                            horizontal: context.widthPct(3.5),
                            vertical: context.heightPct(0.8),
                          ),
                          elevation: 4,
                        ),
                        icon: const Icon(Icons.directions, size: 16, color: AppColors.background),
                        label: Text(
                          'Get Directions',
                          style: AppTypography.bodySm.copyWith(
                            color: AppColors.background,
                            fontSize: context.responsiveFont(12),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
