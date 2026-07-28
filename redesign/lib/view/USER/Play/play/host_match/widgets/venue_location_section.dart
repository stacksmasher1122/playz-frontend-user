import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:redesign/theme/app_colors.dart';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.location_on_rounded, color: AppColors.accent, size: 18),
            const SizedBox(width: 8),
            Text(
              'Venue & Ground Location',
              style: GoogleFonts.inter(
                color: AppColors.accent,
                fontWeight: FontWeight.bold,
                fontSize: ResponsiveHelper.sp(14),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Location Type Selector (PlayZ Turf vs Custom / Unofficial)
        Row(
          children: [
            Expanded(
              child: ChoiceChip(
                showCheckmark: false,
                label: Center(
                  child: Text(
                    'PlayZ Turf',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: ResponsiveHelper.sp(13),
                    ),
                  ),
                ),
                selected: locationType == 'playz_turf',
                selectedColor: AppColors.accent,
                backgroundColor: AppColors.card,
                labelStyle: TextStyle(
                  color: locationType == 'playz_turf' ? Colors.black : Colors.white70,
                ),
                onSelected: (val) {
                  if (val) onLocationTypeChanged('playz_turf');
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ChoiceChip(
                showCheckmark: false,
                label: Center(
                  child: Text(
                    'Custom / Unofficial',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: ResponsiveHelper.sp(13),
                    ),
                  ),
                ),
                selected: locationType == 'custom',
                selectedColor: AppColors.accent,
                backgroundColor: AppColors.card,
                labelStyle: TextStyle(
                  color: locationType == 'custom' ? Colors.black : Colors.white70,
                ),
                onSelected: (val) {
                  if (val) onLocationTypeChanged('custom');
                },
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        // PLAYZ TURF FLOW (Search Bar + Distance + Closest Turfs for Selected Sport)
        if (locationType == 'playz_turf') ...[
          TextField(
            controller: turfSearchController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search PlayZ turfs by name, city...',
              hintStyle: const TextStyle(color: Colors.white38),
              prefixIcon: const Icon(Icons.search, color: AppColors.accent),
              suffixIcon: turfSearchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.white54),
                      onPressed: onClearTurfSearch,
                    )
                  : null,
              filled: true,
              fillColor: AppColors.card,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Colors.white12),
              ),
            ),
            onChanged: onTurfSearchChanged,
          ),

          const SizedBox(height: 12),

          // Turf Results / Closest Turfs Filtered by Selected Sport
          Obx(() {
            final turfs = bookingController.allTurfs.toList();

            if (selectedSport == null || selectedSport!.trim().isEmpty) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.sports_soccer_outlined, color: AppColors.accent, size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Please select a sport at the top first to view nearby turfs available for your sport.',
                        style: GoogleFonts.inter(
                          color: Colors.white70,
                          fontSize: ResponsiveHelper.sp(12.5),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            if (turfs.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    'No PlayZ Turfs available',
                    style: TextStyle(color: Colors.white54),
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
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'No turfs nearby supporting "$selectedSport"',
                    style: const TextStyle(color: Colors.white54),
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
                  style: GoogleFonts.inter(
                    color: Colors.white70,
                    fontSize: ResponsiveHelper.sp(12),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: displayList.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final turf = displayList[index];
                    final isSelected = selectedTurf?.id == turf.id;
                    final distanceStr = calculateDistance(turf, index);

                    return GestureDetector(
                      onTap: () => onTurfSelected(turf),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.accent.withValues(alpha: 0.12)
                              : AppColors.card,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected ? AppColors.accent : Colors.white12,
                            width: isSelected ? 1.8 : 1.0,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.accent
                                    : Colors.white.withValues(alpha: 0.05),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.stadium_rounded,
                                color: isSelected ? Colors.black : AppColors.accent,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    turf.turfName,
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: ResponsiveHelper.sp(14),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    turf.city,
                                    style: GoogleFonts.inter(
                                      color: Colors.white60,
                                      fontSize: ResponsiveHelper.sp(12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Distance Pill
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.near_me_rounded,
                                    color: AppColors.accent,
                                    size: 12,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    distanceStr,
                                    style: GoogleFonts.inter(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w600,
                                      fontSize: ResponsiveHelper.sp(11),
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
            const SizedBox(height: 14),
            Obx(() {
              final grounds = bookingController.grounds.toList();
              if (grounds.isEmpty) return const SizedBox.shrink();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Ground / Court',
                    style: GoogleFonts.inter(
                      color: Colors.white70,
                      fontSize: ResponsiveHelper.sp(12),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<GroundModel>(
                        value: selectedGround,
                        hint: const Text(
                          'Select Ground / Court',
                          style: TextStyle(color: Colors.white54),
                        ),
                        dropdownColor: AppColors.card,
                        isExpanded: true,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
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
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(16),
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
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.map_rounded,
                          color: Colors.black,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pick Location on Google Maps',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: ResponsiveHelper.sp(14),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Tap to open interactive map picker',
                              style: GoogleFonts.inter(
                                color: AppColors.accent,
                                fontSize: ResponsiveHelper.sp(11),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.white54,
                        size: 16,
                      ),
                    ],
                  ),
                  if (customAddressController.text.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    const Divider(color: Colors.white10, height: 1),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(
                          Icons.pin_drop_rounded,
                          color: AppColors.accent,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            customAddressController.text,
                            style: GoogleFonts.inter(
                              color: Colors.white70,
                              fontSize: ResponsiveHelper.sp(12),
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
          const SizedBox(height: 10),
          TextField(
            controller: customAddressController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Or enter custom address manually...',
              hintStyle: const TextStyle(color: Colors.white38),
              prefixIcon: const Icon(Icons.edit_location_alt_rounded, color: AppColors.accent),
              filled: true,
              fillColor: AppColors.card,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Colors.white12),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
