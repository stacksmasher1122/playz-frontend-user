import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Booking_Controller/booking_controller.dart';
import 'package:redesign/model/User_Models/Booking_Models/turf_model.dart';
import 'package:redesign/model/User_Models/Booking_Models/ground_model.dart';
import 'package:redesign/model/User_Models/Booking_Models/slot_model.dart';

class VenueLocationSection extends StatelessWidget {
  final String locationType;
  final String? selectedSport;
  final TextEditingController turfSearchController;
  final String turfSearchQuery;
  final TurfModel? selectedTurf;
  final GroundModel? selectedGround;
  final SlotModel? selectedSlot;
  final TextEditingController customAddressController;
  final BookingController bookingController;
  final ValueChanged<String> onLocationTypeChanged;
  final ValueChanged<String> onTurfSearchChanged;
  final VoidCallback onClearTurfSearch;
  final ValueChanged<TurfModel> onTurfSelected;
  final ValueChanged<GroundModel?> onGroundSelected;
  final ValueChanged<SlotModel> onSlotSelected;
  final VoidCallback onOpenGoogleMapsPicker;
  final String Function(TurfModel turf, int index) calculateDistance;

  const VenueLocationSection({
    super.key,
    required this.locationType,
    this.selectedSport,
    required this.turfSearchController,
    required this.turfSearchQuery,
    required this.selectedTurf,
    required this.selectedGround,
    required this.selectedSlot,
    required this.customAddressController,
    required this.bookingController,
    required this.onLocationTypeChanged,
    required this.onTurfSearchChanged,
    required this.onClearTurfSearch,
    required this.onTurfSelected,
    required this.onGroundSelected,
    required this.onSlotSelected,
    required this.onOpenGoogleMapsPicker,
    required this.calculateDistance,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.location_on_rounded, color: AppColors.accent, size: 18),
            SizedBox(width: context.widthPct(2)),
            Text(
              'Venue & Ground Location',
              style: AppTypography.headlineSm.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.bold,
                fontSize: context.responsiveFont(14),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        SizedBox(height: context.heightPct(1)),

        // Location Type Selector (PlayZ Turf vs Custom / Unofficial)
        Row(
          children: [
            Expanded(
              child: ChoiceChip(
                showCheckmark: false,
                label: Center(
                  child: Text(
                    'PlayZ Turf',
                    style: AppTypography.headlineSm.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: context.responsiveFont(13),
                      color: locationType == 'playz_turf' ? AppColors.background : AppColors.muted,
                    ),
                  ),
                ),
                selected: locationType == 'playz_turf',
                selectedColor: AppColors.accent,
                backgroundColor: AppColors.card,
                onSelected: (val) {
                  if (val) onLocationTypeChanged('playz_turf');
                },
              ),
            ),
            SizedBox(width: context.widthPct(2.5)),
            Expanded(
              child: ChoiceChip(
                showCheckmark: false,
                label: Center(
                  child: Text(
                    'Custom / Unofficial',
                    style: AppTypography.headlineSm.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: context.responsiveFont(13),
                      color: locationType == 'custom' ? AppColors.background : AppColors.muted,
                    ),
                  ),
                ),
                selected: locationType == 'custom',
                selectedColor: AppColors.accent,
                backgroundColor: AppColors.card,
                onSelected: (val) {
                  if (val) onLocationTypeChanged('custom');
                },
              ),
            ),
          ],
        ),

        SizedBox(height: context.heightPct(1.5)),

        // PLAYZ TURF FLOW (Search Bar + Distance + Closest Turfs for Selected Sport)
        if (locationType == 'playz_turf') ...[
          TextField(
            controller: turfSearchController,
            style: AppTypography.bodySm.copyWith(
              color: AppColors.textPrimary,
              fontSize: context.responsiveFont(14),
            ),
            decoration: InputDecoration(
              hintText: 'Search PlayZ turfs by name, city...',
              hintStyle: AppTypography.bodySm.copyWith(
                color: AppColors.muted.withValues(alpha: 0.6),
                fontSize: context.responsiveFont(13),
              ),
              prefixIcon: const Icon(Icons.search, color: AppColors.accent),
              suffixIcon: turfSearchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: AppColors.muted),
                      onPressed: onClearTurfSearch,
                    )
                  : null,
              filled: true,
              fillColor: AppColors.card,
              contentPadding: EdgeInsets.symmetric(vertical: context.heightPct(1.5)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
                borderSide: const BorderSide(color: AppColors.borderDark),
              ),
            ),
            onChanged: onTurfSearchChanged,
          ),

          SizedBox(height: context.heightPct(1.5)),

          // Turf Results / Closest Turfs Filtered by Selected Sport
          Obx(() {
            final turfs = bookingController.allTurfs.toList();

            if (selectedSport == null || selectedSport!.trim().isEmpty) {
              return Container(
                padding: EdgeInsets.all(context.widthPct(4)),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
                  border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.sports_soccer_outlined, color: AppColors.accent, size: 22),
                    SizedBox(width: context.widthPct(3)),
                    Expanded(
                      child: Text(
                        'Please select a sport at the top first to view nearby turfs available for your sport.',
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: context.responsiveFont(12.5),
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }

            if (turfs.isEmpty) {
              return Container(
                padding: EdgeInsets.all(context.widthPct(4)),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
                ),
                child: Center(
                  child: Text(
                    'No PlayZ Turfs available',
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.muted,
                      fontSize: context.responsiveFont(13),
                    ),
                  ),
                ),
              );
            }

            // Filter turfs strictly supporting the selected sport
            final sportFilteredTurfs = turfs.where((t) {
              if (t.sports.isEmpty) return true;
              return t.sports.any((s) => s.toLowerCase().contains(selectedSport!.toLowerCase()) || selectedSport!.toLowerCase().contains(s.toLowerCase()));
            }).toList();

            final displayList = turfSearchQuery.isEmpty
                ? sportFilteredTurfs.take(3).toList()
                : sportFilteredTurfs.where((t) {
                    final query = turfSearchQuery.toLowerCase();
                    return t.turfName.toLowerCase().contains(query) ||
                        t.city.toLowerCase().contains(query);
                  }).toList();

            if (displayList.isEmpty) {
              return Container(
                padding: EdgeInsets.all(context.widthPct(4)),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
                ),
                child: Center(
                  child: Text(
                    'No turfs nearby supporting "$selectedSport"',
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.muted,
                      fontSize: context.responsiveFont(13),
                    ),
                  ),
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  turfSearchQuery.isEmpty
                      ? 'Closest Turfs for $selectedSport Near You'
                      : 'Matching $selectedSport Turfs (${displayList.length})',
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: context.responsiveFont(12),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: context.heightPct(1)),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: displayList.length,
                  separatorBuilder: (_, __) => SizedBox(height: context.heightPct(1)),
                  itemBuilder: (context, index) {
                    final turf = displayList[index];
                    final isSelected = selectedTurf?.id == turf.id;
                    final distanceStr = calculateDistance(turf, index);

                    return GestureDetector(
                      onTap: () => onTurfSelected(turf),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: EdgeInsets.all(context.widthPct(3)),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.accent.withValues(alpha: 0.12)
                              : AppColors.card,
                          borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
                          border: Border.all(
                            color: isSelected ? AppColors.accent : AppColors.borderDark,
                            width: isSelected ? 1.8 : 1.0,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(context.widthPct(2.5)),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.accent
                                    : AppColors.textPrimary.withValues(alpha: 0.05),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.stadium_rounded,
                                color: isSelected ? AppColors.background : AppColors.accent,
                                size: 20,
                              ),
                            ),
                            SizedBox(width: context.widthPct(3)),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    turf.turfName,
                                    style: AppTypography.headlineSm.copyWith(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: context.responsiveFont(14),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: context.heightPct(0.3)),
                                  Text(
                                    turf.city,
                                    style: AppTypography.bodySm.copyWith(
                                      color: AppColors.muted,
                                      fontSize: context.responsiveFont(12),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            // Distance Pill
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.widthPct(2.5),
                                vertical: context.heightPct(0.5),
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.textPrimary.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.near_me_rounded,
                                    color: AppColors.accent,
                                    size: 12,
                                  ),
                                  SizedBox(width: context.widthPct(1)),
                                  Text(
                                    distanceStr,
                                    style: AppTypography.bodySm.copyWith(
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: context.responsiveFont(11),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          }),

          // Ground / Court Selector for Selected Turf
          if (selectedTurf != null) ...[
            SizedBox(height: context.heightPct(1.5)),
            Obx(() {
              final grounds = bookingController.grounds.toList();
              if (grounds.isEmpty) return const SizedBox.shrink();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Ground / Court',
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: context.responsiveFont(12),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: context.heightPct(0.8)),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: context.widthPct(3)),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
                      border: Border.all(color: AppColors.borderDark),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<GroundModel>(
                        value: selectedGround,
                        hint: Text(
                          'Select Ground / Court',
                          style: AppTypography.bodySm.copyWith(
                            color: AppColors.muted,
                            fontSize: context.responsiveFont(13),
                          ),
                        ),
                        dropdownColor: AppColors.card,
                        isExpanded: true,
                        style: AppTypography.headlineSm.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: context.responsiveFont(14),
                        ),
                        items: grounds.map((g) {
                          final specStr = g.dimensions.isNotEmpty ? ' (${g.dimensions})' : '';
                          return DropdownMenuItem<GroundModel>(
                            value: g,
                            child: Text('${g.name}$specStr'),
                          );
                        }).toList(),
                        onChanged: onGroundSelected,
                      ),
                    ),
                  ),
                ],
              );
            }),
          ],
        ]
        // CUSTOM / UNOFFICIAL GROUND FLOW WITH GOOGLE MAPS PICKER
        else ...[
          GestureDetector(
            onTap: onOpenGoogleMapsPicker,
            child: Container(
              padding: EdgeInsets.all(context.widthPct(4)),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
                border: Border.all(color: AppColors.accent.withValues(alpha: 0.4)),
                gradient: LinearGradient(
                  colors: [
                    AppColors.card,
                    AppColors.accent.withValues(alpha: 0.08),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(context.widthPct(2.5)),
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
                        ),
                        child: const Icon(
                          Icons.map_rounded,
                          color: AppColors.background,
                          size: 22,
                        ),
                      ),
                      SizedBox(width: context.widthPct(3)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pick Location on Google Maps',
                              style: AppTypography.headlineSm.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: context.responsiveFont(14),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: context.heightPct(0.3)),
                            Text(
                              'Tap to open interactive map picker',
                              style: AppTypography.bodySm.copyWith(
                                color: AppColors.accent,
                                fontSize: context.responsiveFont(11),
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: AppColors.muted,
                        size: 16,
                      ),
                    ],
                  ),
                  if (customAddressController.text.isNotEmpty) ...[
                    SizedBox(height: context.heightPct(1.5)),
                    const Divider(color: AppColors.borderDark, height: 1),
                    SizedBox(height: context.heightPct(1.2)),
                    Row(
                      children: [
                        const Icon(
                          Icons.pin_drop_rounded,
                          color: AppColors.accent,
                          size: 16,
                        ),
                        SizedBox(width: context.widthPct(1.5)),
                        Expanded(
                          child: Text(
                            customAddressController.text,
                            style: AppTypography.bodySm.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: context.responsiveFont(12),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          SizedBox(height: context.heightPct(1.2)),
          TextField(
            controller: customAddressController,
            style: AppTypography.bodySm.copyWith(
              color: AppColors.textPrimary,
              fontSize: context.responsiveFont(14),
            ),
            decoration: InputDecoration(
              hintText: 'Or enter custom address manually...',
              hintStyle: AppTypography.bodySm.copyWith(
                color: AppColors.muted.withValues(alpha: 0.6),
                fontSize: context.responsiveFont(13),
              ),
              prefixIcon: const Icon(Icons.edit_location_alt_rounded, color: AppColors.accent),
              filled: true,
              fillColor: AppColors.card,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
                borderSide: const BorderSide(color: AppColors.borderDark),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
