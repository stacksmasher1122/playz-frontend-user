import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:redesign/model/maps_model.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class GroupLocationPickerCard extends StatelessWidget {
  final LocationData? selectedLocation;
  final VoidCallback onTapSelect;

  const GroupLocationPickerCard({
    super.key,
    required this.selectedLocation,
    required this.onTapSelect,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final hasLoc = selectedLocation != null;
    final displayLocality = hasLoc
        ? (selectedLocation!.subLocality.isNotEmpty
            ? selectedLocation!.subLocality
            : selectedLocation!.city)
        : '';
    final displayAddress = hasLoc ? selectedLocation!.fullAddress : '';

    return GestureDetector(
      onTap: onTapSelect,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
          border: Border.all(
            color: hasLoc ? AppColors.accent : AppColors.borderDark,
            width: hasLoc ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top Google Map Preview Graphic / Live Map ──
              SizedBox(
                height: 120,
                width: double.infinity,
                child: Stack(
                  children: [
                    if (hasLoc)
                      AbsorbPointer(
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                              selectedLocation!.lat,
                              selectedLocation!.lng,
                            ),
                            zoom: 15,
                          ),
                          zoomControlsEnabled: false,
                          myLocationButtonEnabled: false,
                          compassEnabled: false,
                          mapToolbarEnabled: false,
                          markers: {
                            Marker(
                              markerId: const MarkerId('group_loc'),
                              position: LatLng(
                                selectedLocation!.lat,
                                selectedLocation!.lng,
                              ),
                            ),
                          },
                        ),
                      )
                    else
                      Container(
                        color: AppColors.surface,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.map_outlined,
                                color: AppColors.muted,
                                size: context.responsiveFont(28),
                              ),
                              SizedBox(width: context.widthPct(2)),
                              Text(
                                'Tap to select locality on Google Maps',
                                style: AppTypography.bodySm.copyWith(
                                  color: AppColors.muted,
                                  fontSize: context.responsiveFont(13),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Map overlay gradient
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              AppColors.card.withValues(alpha: 0.9),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Pin badge overlay
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.widthPct(3),
                          vertical: context.heightPct(0.5),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.background.withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
                          border: Border.all(color: AppColors.accent.withValues(alpha: 0.6)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: AppColors.accent,
                              size: 14,
                            ),
                            SizedBox(width: context.widthPct(1)),
                            Text(
                              hasLoc ? 'Locality Set' : 'Select Locality',
                              style: AppTypography.labelCaps10.copyWith(
                                color: AppColors.accent,
                                fontSize: context.responsiveFont(11),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Bottom Location Details Bar ──
              Padding(
                padding: EdgeInsets.all(context.widthPct(3.5)),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(context.widthPct(2.5)),
                      decoration: BoxDecoration(
                        color: hasLoc
                            ? AppColors.accent.withValues(alpha: 0.15)
                            : AppColors.surface,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.my_location_rounded,
                        color: hasLoc ? AppColors.accent : AppColors.muted,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: context.widthPct(3)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hasLoc ? displayLocality : 'Group Locality',
                            style: AppTypography.headlineSm.copyWith(
                              color: AppColors.textPrimary,
                              fontSize: context.responsiveFont(15),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: context.heightPct(0.3)),
                          Text(
                            hasLoc
                                ? displayAddress
                                : 'Tap to pin the home turf or city locality for your group',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.bodySm.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: context.responsiveFont(12),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.muted,
                      size: 24,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
