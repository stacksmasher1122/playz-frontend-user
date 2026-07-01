import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'step_header.dart';
import 'trainer_form_fields.dart';

const kGreen = AppColors.accent;
const kCard = Color(0xFF1A1A1A);
const kMuted = Color(0xFFA7A7A7);

class LocationInfraSection extends StatefulWidget {
  const LocationInfraSection({super.key});

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// ───────── HEADER ─────────
        const StepHeader(step: 6, title: 'Location & Infra'),

        const SizedBox(height: 16),

        /// ───────── TRAINING GROUND ─────────
        const Text(
          'Training Ground',
          style: TextStyle(color: kMuted, fontSize: 13),
        ),
        const SizedBox(height: 10),

        Row(
          children: [
            GroundChip(
              label: 'Own Ground',
              selected: !isRentedGround,
              onTap: () {
                setState(() => isRentedGround = false);
              },
            ),
            const SizedBox(width: 10),
            GroundChip(
              label: 'Rented / Partner',
              selected: isRentedGround,
              onTap: () {
                setState(() => isRentedGround = true);
              },
            ),
          ],
        ),

        const SizedBox(height: 20),

        /// ───────── LOCATION INPUT ─────────
        const Text(
          'Training Location',
          style: TextStyle(color: kMuted, fontSize: 13),
        ),
        const SizedBox(height: 10),

        TrainerInputField(
          label: 'Full Address',
          hint: 'Street / Ground name',
          controller: addressController,
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: TrainerInputField(
                label: 'Area',
                hint: 'e.g. Baner',
                controller: areaController,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TrainerInputField(
                label: 'City',
                hint: 'e.g. Pune',
                controller: cityController,
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        /// ───────── FACILITY PHOTOS ─────────
        const Text(
          'Facility Photos',
          style: TextStyle(color: kMuted, fontSize: 13),
        ),
        const SizedBox(height: 12),

        SizedBox(
          height: 96,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: facilityPhotos.length + 1,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
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

  const GroundChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? kGreen.withValues(alpha: 0.15) : kCard,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected ? kGreen : Colors.transparent,
            width: 1.2,
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
  const AddPhotoTile({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 96,
        decoration: BoxDecoration(
          color: kCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade800),
        ),
        child: const Icon(Icons.add_rounded, color: kMuted, size: 28),
      ),
    );
  }
}

class PhotoPreviewTile extends StatelessWidget {
  final String imageUrl;
  const PhotoPreviewTile({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.network(imageUrl, width: 96, height: 96, fit: BoxFit.cover),
    );
  }
}
