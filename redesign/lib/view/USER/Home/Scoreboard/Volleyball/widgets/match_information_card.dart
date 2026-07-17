import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Volleyball/volleyball_initialize_match_controller.dart';
import 'package:get/get.dart';
import 'official_dropdown_widget.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MatchInformationCard extends StatelessWidget {
  final VolleyballInitializeMatchController controller;

  MatchInformationCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(24)),
      decoration: BoxDecoration(
        color: AppColors.card.withOpacity(0.8),
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField('MATCH NAME', 'e.g. Inter-City Finals', (val) => controller.matchName.value = val),
          SizedBox(height: 24),
          _buildTextField('TOURNAMENT (OPTIONAL)', 'e.g. National Open 2024', (val) => controller.tournament.value = val),
          SizedBox(height: 24),
          _buildDateTimeField(context),
          SizedBox(height: 24),
          _buildVenueField(),
          SizedBox(height: 24),
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
        SizedBox(height: 8),
        TextFormField(
          style: AppTypography.bodyMd.copyWith(color: AppColors.accent),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.bodyMd.copyWith(color: AppColors.muted),
            filled: true,
            fillColor: AppColors.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
              borderSide: BorderSide(color: AppColors.outlineVariant),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
              borderSide: BorderSide(color: AppColors.outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
              borderSide: BorderSide(color: AppColors.accent),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16), vertical: ResponsiveHelper.h(16)),
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
        SizedBox(height: 8),
        InkWell(
          onTap: () {
            controller.pickDate(context);
            controller.pickTime(context);
          },
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16), vertical: ResponsiveHelper.h(16)),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
              border: Border.all(color: AppColors.outlineVariant),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => Text(
                  controller.date.value.isEmpty ? 'dd-mm-yyyy --:--' : '${controller.date.value} ${controller.time.value}',
                  style: AppTypography.bodyMd.copyWith(color: controller.date.value.isEmpty ? AppColors.muted : AppColors.accent),
                )),
                Icon(Icons.calendar_today, color: AppColors.muted, size: 20),
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
        SizedBox(height: 8),
        TextFormField(
          style: AppTypography.bodyMd.copyWith(color: AppColors.accent),
          decoration: InputDecoration(
            hintText: 'Court 04 - Stadium Center',
            hintStyle: AppTypography.bodyMd.copyWith(color: AppColors.muted),
            prefixIcon: Icon(Icons.location_on_outlined, color: AppColors.muted),
            filled: true,
            fillColor: AppColors.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
              borderSide: BorderSide(color: AppColors.outlineVariant),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
              borderSide: BorderSide(color: AppColors.outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
              borderSide: BorderSide(color: AppColors.accent),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16), vertical: ResponsiveHelper.h(16)),
          ),
          onChanged: (val) => controller.selectVenue(val),
        ),
      ],
    );
  }
}
