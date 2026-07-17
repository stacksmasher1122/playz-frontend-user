import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../../../../theme/app_colors.dart';
import '../../../../../../../theme/app_typography.dart';
import '../../../../../../../theme/app_dimensions.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Tennis/setup_match_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SmBasicInfoCardWidget extends StatelessWidget {
  SmBasicInfoCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<SetupMatchController>();

    return ClipRRect(
      borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: EdgeInsets.all(ResponsiveHelper.w(24)),
          decoration: BoxDecoration(
            color: Color(0x001a1a1a).withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            backgroundBlendMode: BlendMode.dstATop,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMatchNameField(controller),
              SizedBox(height: AppDimensions.gutter),
              
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth >= 768) {
                    return Row(
                      children: [
                        Expanded(child: _buildTournamentDropdown(controller)),
                        SizedBox(width: AppDimensions.gutter),
                        Expanded(child: _buildDateTimePicker(context, controller)),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        _buildTournamentDropdown(controller),
                        SizedBox(height: AppDimensions.gutter),
                        _buildDateTimePicker(context, controller),
                      ],
                    );
                  }
                },
              ),
              
              SizedBox(height: AppDimensions.gutter),
              
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth >= 768) {
                    return Row(
                      children: [
                        Expanded(child: _buildCourtNumberField(controller)),
                        SizedBox(width: AppDimensions.gutter),
                        Expanded(child: _buildChairUmpireField(controller)),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        _buildCourtNumberField(controller),
                        SizedBox(height: AppDimensions.gutter),
                        _buildChairUmpireField(controller),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMatchNameField(SetupMatchController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'MATCH NAME',
          style: AppTypography.labelCaps.copyWith(color: AppColors.muted),
        ),
        SizedBox(height: AppDimensions.sm),
        TextField(
          controller: controller.matchNameController,
          style: AppTypography.headlineMd.copyWith(color: AppColors.accent),
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.accent, width: 2),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.10), width: 1),
            ),
            hintText: "e.g., Club Championship Final",
            hintStyle: AppTypography.headlineMd.copyWith(color: AppColors.muted),
            contentPadding: EdgeInsets.symmetric(vertical: AppDimensions.sm, horizontal: 0),
            fillColor: Colors.transparent,
            filled: true,
          ),
          onChanged: controller.updateMatchName,
        ),
      ],
    );
  }

  Widget _buildTournamentDropdown(SetupMatchController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TOURNAMENT',
          style: AppTypography.labelCaps.copyWith(color: AppColors.muted),
        ),
        SizedBox(height: AppDimensions.sm),
        Obx(() {
          return DropdownButtonFormField<String>(
            initialValue: controller.matchSetup.value.tournament,
            dropdownColor: AppColors.card,
            icon: Icon(Icons.arrow_drop_down, color: AppColors.muted),
            style: AppTypography.bodyMd.copyWith(color: AppColors.onPrimary),
            decoration: InputDecoration(
              border: InputBorder.none,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.accent, width: 2),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.10), width: 1),
              ),
              fillColor: Colors.transparent,
              filled: true,
            ),
            items: ["Summer Open 2024", "Inter-Club League", "Grand Slam Qualifier"]
                .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                .toList(),
            onChanged: (val) {
              if (val != null) controller.selectTournament(val);
            },
          );
        }),
      ],
    );
  }

  Widget _buildDateTimePicker(BuildContext context, SetupMatchController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'DATE & TIME',
          style: AppTypography.labelCaps.copyWith(color: AppColors.muted),
        ),
        SizedBox(height: AppDimensions.sm),
        Obx(() {
          final dt = controller.matchSetup.value.dateTime;
          final dtString = dt != null ? DateFormat('dd MMM yyyy, HH:mm').format(dt) : "mm/dd/yyyy, --:-- --";
          
          return TextField(
            readOnly: true,
            showCursor: false,
            controller: TextEditingController(text: dtString),
            style: AppTypography.bodyMd.copyWith(color: AppColors.onPrimary),
            decoration: InputDecoration(
              border: InputBorder.none,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.accent, width: 2),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.10), width: 1),
              ),
              fillColor: Colors.transparent,
              filled: true,
              suffixIcon: Icon(Icons.calendar_today, color: AppColors.muted, size: 18),
            ),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: dt ?? DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
              );
              if (date != null && context.mounted) {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(dt ?? DateTime.now()),
                );
                if (time != null) {
                  controller.setDateTime(DateTime(date.year, date.month, date.day, time.hour, time.minute));
                }
              }
            },
          );
        }),
      ],
    );
  }

  Widget _buildCourtNumberField(SetupMatchController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'COURT NUMBER',
          style: AppTypography.labelCaps.copyWith(color: AppColors.muted),
        ),
        SizedBox(height: AppDimensions.sm),
        TextField(
          controller: controller.courtNumberController,
          style: AppTypography.bodyMd.copyWith(color: AppColors.accent),
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.accent, width: 2),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.10), width: 1),
            ),
            hintText: "Court 1 (Center)",
            hintStyle: AppTypography.bodyMd.copyWith(color: AppColors.muted),
            contentPadding: EdgeInsets.symmetric(vertical: AppDimensions.sm, horizontal: 0),
            fillColor: Colors.transparent,
            filled: true,
          ),
          onChanged: controller.updateCourtNumber,
        ),
      ],
    );
  }

  Widget _buildChairUmpireField(SetupMatchController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CHAIR UMPIRE',
          style: AppTypography.labelCaps.copyWith(color: AppColors.muted),
        ),
        SizedBox(height: AppDimensions.sm),
        TextField(
          controller: controller.umpireNameController,
          style: AppTypography.bodyMd.copyWith(color: AppColors.accent),
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.accent, width: 2),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.10), width: 1),
            ),
            hintText: "Enter Name",
            hintStyle: AppTypography.bodyMd.copyWith(color: AppColors.muted),
            contentPadding: EdgeInsets.symmetric(vertical: AppDimensions.sm, horizontal: 0),
            fillColor: Colors.transparent,
            filled: true,
          ),
          onChanged: controller.updateChairUmpire,
        ),
      ],
    );
  }
}
