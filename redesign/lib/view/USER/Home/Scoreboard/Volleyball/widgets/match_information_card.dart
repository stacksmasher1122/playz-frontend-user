import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Volleyball/volleyball_initialize_match_controller.dart';
import 'package:get/get.dart';
import 'official_dropdown_widget.dart';

class MatchInformationCard extends StatelessWidget {
  final VolleyballInitializeMatchController controller;

  const MatchInformationCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.surfaceContainerHighest),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField('MATCH NAME', 'e.g. Inter-City Finals', (val) => controller.matchName.value = val),
          const SizedBox(height: 24),
          _buildTextField('TOURNAMENT (OPTIONAL)', 'e.g. National Open 2024', (val) => controller.tournament.value = val),
          const SizedBox(height: 24),
          _buildDateTimeField(context),
          const SizedBox(height: 24),
          _buildVenueField(),
          const SizedBox(height: 24),
          OfficialDropdownWidget(
            label: 'REFEREE ASSIGNMENT',
            hint: 'Select Lead Official...',
            onChanged: (val) => controller.selectOfficial('referee', val ?? ''),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String hint, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.labelCaps10.copyWith(color: AppColors.muted, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
        const SizedBox(height: 8),
        TextFormField(
          style: AppTypography.bodyMd.copyWith(color: AppColors.primary),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.bodyMd.copyWith(color: AppColors.muted),
            filled: true,
            fillColor: AppColors.surfaceContainerLowest,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.surfaceContainerHighest),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.surfaceContainerHighest),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primaryContainer),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildDateTimeField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('DATE & TIME', style: AppTypography.labelCaps10.copyWith(color: AppColors.muted, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
        const SizedBox(height: 8),
        InkWell(
          onTap: () {
            controller.pickDate(context);
            controller.pickTime(context);
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.surfaceContainerHighest),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => Text(
                  controller.date.value.isEmpty ? 'dd-mm-yyyy --:--' : '${controller.date.value} ${controller.time.value}',
                  style: AppTypography.bodyMd.copyWith(color: controller.date.value.isEmpty ? AppColors.muted : AppColors.primary),
                )),
                const Icon(Icons.calendar_today, color: AppColors.muted, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVenueField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('VENUE / COURT', style: AppTypography.labelCaps10.copyWith(color: AppColors.muted, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
        const SizedBox(height: 8),
        TextFormField(
          style: AppTypography.bodyMd.copyWith(color: AppColors.primary),
          decoration: InputDecoration(
            hintText: 'Court 04 - Stadium Center',
            hintStyle: AppTypography.bodyMd.copyWith(color: AppColors.muted),
            prefixIcon: const Icon(Icons.location_on_outlined, color: AppColors.muted),
            filled: true,
            fillColor: AppColors.surfaceContainerLowest,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.surfaceContainerHighest),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.surfaceContainerHighest),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primaryContainer),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          onChanged: (val) => controller.selectVenue(val),
        ),
      ],
    );
  }
}
