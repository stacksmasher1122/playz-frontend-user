import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MapPreview extends StatelessWidget {
  final double latitude;
  final double longitude;

  const MapPreview({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    // Basic dark style for preview
    final String darkMapStyle = '''
    [
      {"elementType":"geometry","stylers":[{"color":"#212121"}]},
      {"elementType":"labels.icon","stylers":[{"visibility":"off"}]},
      {"elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},
      {"elementType":"labels.text.stroke","stylers":[{"color":"#212121"}]},
      {"featureType":"water","elementType":"geometry","stylers":[{"color":"#000000"}]}
    ]
    ''';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
      width: double.infinity,
      height: context.heightPct(18).clamp(120.0, 160.0),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
        border: Border.all(color: AppColors.borderDark, width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
        child: AbsorbPointer(
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(latitude, longitude),
              zoom: 14,
            ),
            markers: {
              Marker(
                markerId: const MarkerId('preview_location'),
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
        ),
      ),
    );
  }
}
