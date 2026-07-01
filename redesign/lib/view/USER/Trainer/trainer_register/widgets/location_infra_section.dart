import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'step_header.dart';
import 'trainer_form_fields.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kGreen = AppColors.accent;
const kCard = Color(0xFF1A1A1A);
const kMuted = Color(0xFFA7A7A7);

class LocationInfraSection extends StatefulWidget {
  LocationInfraSection({super.key});

  @override
  State<LocationInfraSection> createState() => _LocationInfraSectionState();
}

class _LocationInfraSectionState extends State<LocationInfraSection> {
  bool isRentedGround = true;
  final List<String> facilityPhotos = [];

  final TextEditingController addressController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  @override
  void dispose() {
    addressController.dispose();
    areaController.dispose();
    cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// ───────── HEADER ─────────
        StepHeader(step: 6, title: 'Location & Infra'),

        SizedBox(height: 16),

        /// ───────── TRAINING GROUND ─────────
        Text(
          'Training Ground',
          style: TextStyle(color: kMuted, fontSize: 13),
        ),
        SizedBox(height: 10),

        Row(
          children: [
            GroundChip(
              label: 'Own Ground',
              selected: !isRentedGround,
              onTap: () {
                setState(() => isRentedGround = false);
              },
            ),
            SizedBox(width: 10),
            GroundChip(
              label: 'Rented / Partner',
              selected: isRentedGround,
              onTap: () {
                setState(() => isRentedGround = true);
              },
            ),
          ],
        ),

        SizedBox(height: 20),

        /// ───────── LOCATION INPUT ─────────
        Text(
          'Training Location',
          style: TextStyle(color: kMuted, fontSize: 13),
        ),
        SizedBox(height: 10),

        TrainerInputField(
          label: 'Full Address',
          hint: 'Street / Ground name',
          controller: addressController,
        ),

        SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: TrainerInputField(
                label: 'Area',
                hint: 'e.g. Baner',
                controller: areaController,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: TrainerInputField(
                label: 'City',
                hint: 'e.g. Pune',
                controller: cityController,
              ),
            ),
          ],
        ),

        SizedBox(height: 20),

        /// ───────── FACILITY PHOTOS ─────────
        Text(
          'Facility Photos',
          style: TextStyle(color: kMuted, fontSize: 13),
        ),
        SizedBox(height: 12),

        SizedBox(
          height: ResponsiveHelper.h(96),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: facilityPhotos.length + 1,
            separatorBuilder: (_, __) => SizedBox(width: 12),
            itemBuilder: (context, index) {
              if (index == 0) {
                return AddPhotoTile(
                  onTap: () {
                    // TODO: Image picker
                  },
                );
              }

              return PhotoPreviewTile(imageUrl: facilityPhotos[index - 1]);
            },
          ),
        ),
      ],
    );
  }
}

class GroundChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  GroundChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(18), vertical: ResponsiveHelper.h(10)),
        decoration: BoxDecoration(
          color: selected ? kGreen.withValues(alpha: 0.15) : kCard,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(24)),
          border: Border.all(
            color: selected ? kGreen : Colors.transparent,
            width: ResponsiveHelper.w(1.2),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? kGreen : kMuted,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class AddPhotoTile extends StatelessWidget {
  final VoidCallback onTap;
  AddPhotoTile({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: ResponsiveHelper.w(96),
        decoration: BoxDecoration(
          color: kCard,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
          border: Border.all(color: Colors.grey.shade800),
        ),
        child: Icon(Icons.add_rounded, color: kMuted, size: 28),
      ),
    );
  }
}

class PhotoPreviewTile extends StatelessWidget {
  final String imageUrl;
  PhotoPreviewTile({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
      child: Image.network(imageUrl, width: ResponsiveHelper.w(96), height: ResponsiveHelper.h(96), fit: BoxFit.cover),
    );
  }
}
